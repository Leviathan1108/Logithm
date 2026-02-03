import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

enum UserType { guest, loggedIn }

class AuthManager {
  // --- SINGLETON PATTERN ---
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  // --- STATE VARIABLES ---
  UserType currentUserType = UserType.guest;
  String? userId;
  String username = "Anonim";
  String? email;

  // Data sementara untuk Guest
  List<int> guestCompletedMateriIds = [];
  int guestScore = 0;

  // --- INITIALIZATION ---
  Future<void> init() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      await _setLoggedInUser(session.user);
    } else {
      await _generateGuestIdentity();
    }
  }

  // Helper: Set User Login
  Future<void> _setLoggedInUser(User user) async {
    currentUserType = UserType.loggedIn;
    userId = user.id;
    email = user.email;

    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('id', user.id)
          .maybeSingle();
      
      username = data != null ? (data['username'] ?? "User") : (user.email?.split('@')[0] ?? "User");
    } catch (e) {
      username = user.email?.split('@')[0] ?? "User";
    }

    // Bersihkan data guest
    guestCompletedMateriIds.clear();
    guestScore = 0;
  }

  // Helper: Set Guest
  Future<void> _generateGuestIdentity() async {
    currentUserType = UserType.guest;
    userId = "guest_local";
    email = null;
    
    final prefs = await SharedPreferences.getInstance();
    String? storedGuestId = prefs.getString('guest_id');
    if (storedGuestId == null) {
      int randomNum = Random().nextInt(9000) + 1000;
      storedGuestId = "Guest-$randomNum";
      await prefs.setString('guest_id', storedGuestId);
    }
    username = storedGuestId;

    List<String> finished = prefs.getStringList('guest_finished_materi') ?? [];
    guestCompletedMateriIds = finished.map((e) => int.parse(e)).toList();
    guestScore = prefs.getInt('guest_total_score') ?? 0;
  }

  // ===========================================================================
  // BAGIAN 1: STANDARD AUTH (LOGIN, REGISTER, LOGOUT, UPDATE PROFILE)
  // ===========================================================================

  Future<void> login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await _setLoggedInUser(response.user!);
        await _syncGuestProgressToCloud(); 
      }
    } catch (e) {
      if (e is AuthException) throw e.message;
      throw "Gagal login. Periksa email atau password.";
    }
  }

  Future<void> register(String email, String password, String username) async {
    final supabase = Supabase.instance.client;
    try {
      final checkUser = await supabase.from('profiles').select('id').eq('username', username).maybeSingle();
      if (checkUser != null) throw "Username '$username' sudah dipakai.";

      final response = await supabase.auth.signUp(
        email: email, 
        password: password,
        data: {'username': username},
      );
      
      if (response.user != null) {
        await supabase.from('profiles').upsert({
          'id': response.user!.id,
          'username': username,
          'email': email,
          'total_score': 0, 
          'tos_accepted_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        if (response.session != null) {
          await _setLoggedInUser(response.user!);
          await _syncGuestProgressToCloud(); 
        }
      }
    } catch (e) {
      if (e is AuthException) throw e.message;
      rethrow; 
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    await _generateGuestIdentity();
  }

  Future<void> updateProfileName(String newName) async {
    if (currentUserType == UserType.guest) return;
    final supabase = Supabase.instance.client;
    
    final checkUser = await supabase.from('profiles')
        .select()
        .eq('username', newName)
        .neq('id', userId!) 
        .maybeSingle();
        
    if (checkUser != null) throw "Username sudah digunakan.";

    await supabase.from('profiles').update({
      'username': newName,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId!);

    username = newName;
  }

  // ===========================================================================
  // BAGIAN 2: SECURITY & PASSWORD MANAGEMENT
  // ===========================================================================

  // A. UPDATE PASSWORD (SAAT USER SUDAH LOGIN)
  Future<void> updatePassword(String newPassword) async {
    try {
      if (currentUserType != UserType.loggedIn) throw "Anda harus login.";
      
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      if (e is AuthException) throw e.message;
      throw "Gagal memperbarui kata sandi: $e";
    }
  }

  // B. FORGOT PASSWORD FLOW (SMTP + OTP + RPC)

  // 1. Generate & Kirim Kode
  Future<void> sendForgotPasswordOTP(String targetEmail) async {
    final supabase = Supabase.instance.client;
    
    // Cek email ada di profiles
    final check = await supabase.from('profiles').select('id').eq('email', targetEmail).maybeSingle();
    if (check == null) throw "Email tidak terdaftar dalam sistem.";

    // Generate Kode
    String code = (Random().nextInt(900000) + 100000).toString();
    DateTime expiresAt = DateTime.now().add(const Duration(minutes: 10));

    // Simpan ke DB
    await supabase.from('verification_codes').delete().eq('email', targetEmail);
    await supabase.from('verification_codes').insert({
      'email': targetEmail,
      'code': code,
      'expires_at': expiresAt.toIso8601String(),
    });

    // Kirim Email
    await _sendEmailViaSMTP(targetEmail, code);
  }

  // 2. Verifikasi Kode
  Future<bool> verifyOTP(String targetEmail, String inputCode) async {
    final response = await Supabase.instance.client
        .from('verification_codes')
        .select()
        .eq('email', targetEmail)
        .eq('code', inputCode)
        .maybeSingle();

    if (response == null) return false;

    final expiresAt = DateTime.parse(response['expires_at']);
    if (DateTime.now().isAfter(expiresAt)) return false;

    return true; 
  }

  // 3. Reset Password Manual (Panggil RPC)
  Future<void> resetPasswordManual(String targetEmail, String newPassword, String verifiedCode) async {
    // Validasi ulang
    bool isValid = await verifyOTP(targetEmail, verifiedCode);
    if (!isValid) throw "Kode verifikasi tidak valid atau sudah kadaluarsa.";

    // Panggil RPC Admin
    await Supabase.instance.client.rpc('admin_update_user_password', params: {
      'target_email': targetEmail,
      'new_password': newPassword
    });

    // Bersihkan kode
    await Supabase.instance.client.from('verification_codes').delete().eq('email', targetEmail);
  }

  // Helper SMTP
  Future<void> _sendEmailViaSMTP(String recipient, String otp) async {
    // GANTI DENGAN KREDENSIAL PENGIRIM ANDA
    String username = 'logithm.projects@gmail.com'; 
    String password = 'kati tyxg pzze bcnn'; 

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Keamanan Logithm')
      ..recipients.add(recipient)
      ..subject = 'Kode Reset Password'
      ..text = '''
Halo,

Permintaan reset password diterima.
Kode verifikasi Anda adalah:

$otp

Kode berlaku 10 menit.
''';

    try {
      await send(message, smtpServer);
    } catch (e) {
      debugPrint("SMTP Error: $e");
      throw "Gagal mengirim email verifikasi.";
    }
  }

  // ===========================================================================
  // BAGIAN 3: DATA SYNC (GUEST -> CLOUD)
  // ===========================================================================

  Future<void> _syncGuestProgressToCloud() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> finished = prefs.getStringList('guest_finished_materi') ?? [];
    int localScore = prefs.getInt('guest_total_score') ?? 0;

    if (finished.isEmpty && localScore == 0) return; 
    final supabase = Supabase.instance.client;

    try {
      if (finished.isNotEmpty) {
        List<Map<String, dynamic>> progressData = [];
        for (String idStr in finished) {
          progressData.add({
            'user_id': userId,
            'materi_id': int.parse(idStr),
            'score_earned': 10, 
            'completed_at': DateTime.now().toIso8601String(),
          });
        }
        await supabase.from('user_progress').upsert(progressData, onConflict: 'user_id, materi_id');
      }

      if (localScore > 0) {
        final profileData = await supabase.from('profiles').select('total_score').eq('id', userId!).single();
        int currentDbScore = profileData['total_score'] ?? 0;
        await supabase.from('profiles').update({
          'total_score': currentDbScore + localScore
        }).eq('id', userId!);
      }

      await prefs.remove('guest_finished_materi');
      await prefs.remove('guest_total_score');
      guestCompletedMateriIds.clear();
      guestScore = 0;
    } catch (e) {
      debugPrint("Sync error: $e");
    }
  }

  Future<int> getLatestTotalScore() async {
    if (currentUserType == UserType.guest) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('guest_total_score') ?? 0;
    } else {
      try {
        final data = await Supabase.instance.client.from('profiles').select('total_score').eq('id', userId!).single();
        return data['total_score'] ?? 0;
      } catch (e) {
        return 0;
      }
    }
  }
}