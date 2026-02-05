import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart'; // [BARU] Import Google Sign In

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
    
    _setupTokenRefreshListener();
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

    guestCompletedMateriIds.clear();
    guestScore = 0;

    _uploadFcmToken();
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
  // BAGIAN 1: STANDARD AUTH (LOGIN, REGISTER, LOGOUT)
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
    try {
      if (userId != null && currentUserType == UserType.loggedIn) {
        await Supabase.instance.client
            .from('profiles')
            .update({'fcm_token': null}) 
            .eq('id', userId!);
      }
    } catch (e) {
      debugPrint("Gagal hapus token FCM: $e");
    }

    // Logout Google juga agar bersih
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

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
  // BAGIAN 2: SECURITY (PASSWORD RESET)
  // ===========================================================================

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

  Future<void> sendForgotPasswordOTP(String targetEmail) async {
    final supabase = Supabase.instance.client;
    final check = await supabase.from('profiles').select('id').eq('email', targetEmail).maybeSingle();
    if (check == null) throw "Email tidak terdaftar.";

    String code = (Random().nextInt(900000) + 100000).toString();
    DateTime expiresAt = DateTime.now().add(const Duration(minutes: 10));

    await supabase.from('verification_codes').delete().eq('email', targetEmail);
    await supabase.from('verification_codes').insert({
      'email': targetEmail,
      'code': code,
      'expires_at': expiresAt.toIso8601String(),
    });

    await _sendEmailViaSMTP(targetEmail, code);
  }

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

  Future<void> resetPasswordManual(String targetEmail, String newPassword, String verifiedCode) async {
    bool isValid = await verifyOTP(targetEmail, verifiedCode);
    if (!isValid) throw "Kode verifikasi tidak valid.";

    await Supabase.instance.client.rpc('admin_update_user_password', params: {
      'target_email': targetEmail,
      'new_password': newPassword
    });

    await Supabase.instance.client.from('verification_codes').delete().eq('email', targetEmail);
  }

  Future<void> _sendEmailViaSMTP(String recipient, String otp) async {
    String username = 'logithm.projects@gmail.com'; 
    String password = 'kati tyxg pzze bcnn'; 

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Keamanan Logithm')
      ..recipients.add(recipient)
      ..subject = 'Kode Reset Password'
      ..text = 'Kode verifikasi Anda adalah: $otp\n\nBerlaku 10 menit.';

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

  // ===========================================================================
  // BAGIAN 4: PUSH NOTIFICATION (FCM)
  // ===========================================================================
  
  Future<void> _uploadFcmToken() async {
    if (currentUserType == UserType.guest || userId == null) return;
    if (Firebase.apps.isEmpty) {
      debugPrint("Warning: Firebase belum di-init. Melewati upload token.");
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        if (token != null) {
          debugPrint("FCM Token: $token");
          await Supabase.instance.client
              .from('profiles')
              .update({
                'fcm_token': token,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', userId!);
        }
      }
    } catch (e) {
      debugPrint("Gagal upload FCM Token: $e");
    }
  }

  void _setupTokenRefreshListener() {
    if (Firebase.apps.isNotEmpty) {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        if (currentUserType == UserType.loggedIn && userId != null) {
          try {
            await Supabase.instance.client
              .from('profiles')
              .update({
                'fcm_token': newToken,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', userId!);
          } catch (_) {}
        }
      });
    }
  }

  // ===========================================================================
  // [BARU] BAGIAN 5: GOOGLE SIGN IN
  // ===========================================================================

  Future<void> loginWithGoogle() async {
    // -----------------------------------------------------------
    // [PENTING] PASTE WEB CLIENT ID DARI GOOGLE CLOUD DISINI
    // Walaupun ini App Android, kita wajib pakai WEB Client ID 
    // agar Supabase bisa membaca tokennya.
    // -----------------------------------------------------------
    const webClientId = '412660843389-ej2mhcal7vc2tt0vsh2v7l9mqomf1gns.apps.googleusercontent.com';

    // Untuk iOS (Biarkan null jika tidak pakai iOS)
    const iosClientId = null;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId, 
    );

    try {
      // 1. Trigger Native Sign In (Muncul Pop-up Pilih Akun)
      final googleUser = await googleSignIn.signIn();
      
      // Jika user menutup pop-up tanpa memilih akun
      if (googleUser == null) return; 

      // 2. Ambil Auth Token dari Google
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No ID Token found from Google.';
      }

      // 3. Login ke Supabase menggunakan Token Google
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // 4. Handle Profil User di Database
      if (response.user != null) {
        final user = response.user!;
        
        // Cek apakah user ini sudah ada di tabel profiles
        final existingProfile = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (existingProfile == null) {
          // Jika belum ada (User Baru), buatkan profil otomatis
          // Buat username dari bagian depan email (sebelum @)
          String cleanUsername = user.email!.split('@')[0];
          // Hapus karakter aneh agar URL aman
          cleanUsername = cleanUsername.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
          
          await Supabase.instance.client.from('profiles').insert({
            'id': user.id,
            'username': cleanUsername,
            'email': user.email,
            'avatar_url': user.userMetadata?['avatar_url'], // Foto profil dari Google
            'total_score': 0,
            'tos_accepted_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'status': 'active'
          });
        }

        // 5. Set status login di aplikasi
        await _setLoggedInUser(user);
        
        // 6. Sinkronisasi data guest (jika ada)
        await _syncGuestProgressToCloud();
      }
    } catch (e) {
      if (e is AuthException) throw e.message;
      throw "Gagal Login Google: $e";
    }
  }
}