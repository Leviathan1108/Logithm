import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan path ini sesuai dengan file AuthManager Anda
import 'auth_manager.dart';

class ProgressManager {
  // ============================================================
  // STATE MANAGEMENT (REAKTIF)
  // ============================================================
  
  static final ValueNotifier<int> totalScore = ValueNotifier(0);
  static final ValueNotifier<Set<int>> completedMateri = ValueNotifier({});
  static bool _isSyncing = false;

  // ============================================================
  // 1. INITIALIZATION
  // ============================================================
  static Future<void> init() async {
    final auth = AuthManager();
    totalScore.value = 0;
    completedMateri.value = {};

    debugPrint("ProgressManager: Inisialisasi...");

    if (auth.currentUserType == UserType.loggedIn) {
      await _loadFromLocal();
      if (await isOnline()) {
        await _fetchFromCloud(); 
        await _syncLocalToCloud(); 
      }
    }
  }

  static Future<bool> isOnline() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  // ============================================================
  // 2. LOCAL STORAGE
  // ============================================================
  
  static Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int localScore = prefs.getInt('local_total_score') ?? 0;
      totalScore.value = localScore;

      List<String>? localMateri = prefs.getStringList('local_completed_materi');
      if (localMateri != null) {
        completedMateri.value = localMateri.map((e) => int.parse(e)).toSet();
      }
    } catch (e) {
      debugPrint("Error Load Local: $e");
    }
  }

  static Future<void> _saveToLocal() async {
    final auth = AuthManager();
    if (auth.currentUserType == UserType.guest) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('local_total_score', totalScore.value);
      List<String> stringIds = completedMateri.value.map((e) => e.toString()).toList();
      await prefs.setStringList('local_completed_materi', stringIds);
      await prefs.setBool('needs_sync', true);
    } catch (e) {
      debugPrint("Error Save Local: $e");
    }
  }

  // ============================================================
  // 3. CLOUD SYNC
  // ============================================================

  static Future<void> _syncLocalToCloud() async {
    if (_isSyncing) return;
    _isSyncing = true;
    
    final prefs = await SharedPreferences.getInstance();
    bool needsSync = prefs.getBool('needs_sync') ?? false;
    final auth = AuthManager();

    if (needsSync && auth.currentUserType == UserType.loggedIn) {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) return;
        
        // Update Total Score Profile
        await Supabase.instance.client.from('profiles').update({
          'total_score': totalScore.value,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);

        // Sync Materi Selesai
        for (int materiId in completedMateri.value) {
          // Cek dulu apakah sudah ada record progress untuk materi ini
          final existing = await Supabase.instance.client
              .from('user_progress')
              .select()
              .match({'user_id': userId, 'materi_id': materiId})
              .maybeSingle();

          if (existing == null) {
             await Supabase.instance.client.from('user_progress').insert({
              'user_id': userId,
              'materi_id': materiId,
              'score_earned': 10, // Default reward materi
              'completed_at': DateTime.now().toIso8601String(),
            });
          }
        }

        await prefs.setBool('needs_sync', false);
      } catch (e) {
        debugPrint("Gagal Sync ke Cloud: $e");
      }
    }
    _isSyncing = false;
  }

  static Future<void> _fetchFromCloud() async {
    final auth = AuthManager();
    if (auth.currentUserType == UserType.guest) return;

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      // Ambil Score
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select('total_score')
          .eq('id', userId)
          .maybeSingle();

      if (profileData != null) {
        int cloudScore = profileData['total_score'] as int;
        if (cloudScore > totalScore.value) {
          totalScore.value = cloudScore;
          await _saveToLocal();
        }
      }

      // Ambil Materi Selesai
      final progressData = await Supabase.instance.client
          .from('user_progress')
          .select('materi_id')
          .eq('user_id', userId);
      
      if (progressData is List) {
        final cloudMateriSet = progressData.map((e) => e['materi_id'] as int).toSet();
        if (cloudMateriSet.length > completedMateri.value.length) {
           completedMateri.value = cloudMateriSet;
           await _saveToLocal();
        }
      }

    } catch (e) {
      debugPrint("Gagal fetch dari Cloud: $e");
    }
  }

  // ============================================================
  // 4. ACTION UTAMA
  // ============================================================
  
  static Future<void> addScore(int newPoints) async {
    if (newPoints <= 0) return;
    final auth = AuthManager();
    totalScore.value += newPoints;
    
    if (auth.currentUserType == UserType.loggedIn) {
      await _saveToLocal();
      if (await isOnline()) {
        await _syncLocalToCloud(); 
      }
    }
  }

  /// [BARU] Fungsi Khusus Menyimpan Skor Latihan ke Database
  /// Returns [true] jika berhasil disimpan (poin bertambah).
  /// Returns [false] jika gagal atau sudah pernah dikerjakan sebelumnya.
  static Future<bool> saveLatihanScore(int materiId, int score) async {
    final auth = AuthManager();
    
    // 1. Jika GUEST: Simpan lokal saja (pake SharedPreferences terpisah)
    if (auth.currentUserType == UserType.guest) {
      final prefs = await SharedPreferences.getInstance();
      List<String> done = prefs.getStringList('guest_latihan_done') ?? [];
      
      // Jika sudah pernah, jangan kasih poin lagi
      if (done.contains(materiId.toString())) return false;

      // Simpan status dan tambah poin
      done.add(materiId.toString());
      await prefs.setStringList('guest_latihan_done', done);
      
      totalScore.value += score; // Update UI
      return true;
    }

    // 2. Jika USER LOGIN: Simpan ke Supabase
    if (await isOnline()) {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) return false;

        // Cek apakah sudah pernah mengerjakan latihan ini?
        // Kita asumsikan 'materi_id' untuk latihan pakai kode unik misal 100+ID_Materi 
        // Atau buat kolom 'type' di tabel user_progress (materi/latihan).
        // DI SINI SAYA GUNAKAN ID_MATERI ASLI.
        // Jadi asumsinya 1 Materi punya 1 Latihan.
        // Kita cek di tabel user_progress apakah sudah ada record dengan skor > 10 (skor materi default 10)
        // ATAU kita buat aturan: Record materi score 10, Record latihan kita update scorenya jadi 10 + LatihanScore.
        
        // CARA AMAN: Update skor yang ada.
        final existing = await Supabase.instance.client
            .from('user_progress')
            .select()
            .match({'user_id': userId, 'materi_id': materiId})
            .maybeSingle();

        int previousScore = 0;
        if (existing != null) {
           previousScore = existing['score_earned'] as int;
           // Jika skor sebelumnya > 10, berarti sudah pernah ngerjain latihan (asumsi skor materi cuma 10)
           if (previousScore > 10) return false; 
        }

        // Update Poin di user_progress (Total Skor Materi = 10 + Skor Latihan)
        int newEntryScore = previousScore + score;
        
        await Supabase.instance.client.from('user_progress').upsert({
          'user_id': userId,
          'materi_id': materiId,
          'score_earned': newEntryScore,
          'completed_at': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id, materi_id');

        // Update Total Score di Profile (Hanya tambahkan selisih skor latihan)
        await Supabase.instance.client.rpc('increment_score', params: {
          'row_id': userId, 
          'amount': score
        }); 
        // Note: Pastikan Anda punya fungsi RPC 'increment_score' di Supabase 
        // ATAU pakai cara manual get-update:
        
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('total_score')
            .eq('id', userId)
            .single();
        
        int currentTotal = profile['total_score'] ?? 0;
        await Supabase.instance.client.from('profiles').update({
          'total_score': currentTotal + score
        }).eq('id', userId);

        // Update UI Lokal
        totalScore.value += score;
        await _saveToLocal(); // Sync lokal biar sama

        return true;

      } catch (e) {
        debugPrint("Gagal simpan latihan ke DB: $e");
        return false;
      }
    } else {
      // Jika Offline: Simpan pending (Logic sederhana: tambah poin lokal dulu)
      // Nanti pas online disync lewat _syncLocalToCloud (tapi perlu logika antrian khusus sebenarnya)
      // Untuk simplifikasi: Poin Latihan Offline hanya disimpan ke totalScore lokal.
      totalScore.value += score;
      await _saveToLocal();
      return true;
    }
  }

  static Future<bool> markAsComplete(int materiId) async {
    if (completedMateri.value.contains(materiId)) return false;

    final newSet = Set<int>.from(completedMateri.value);
    newSet.add(materiId);
    completedMateri.value = newSet;
    
    totalScore.value += 10; 

    final auth = AuthManager();
    if (auth.currentUserType == UserType.loggedIn) {
      await _saveToLocal();
      if (await isOnline()) {
         await _syncLocalToCloud();
      }
    }
    return true;
  }

  static Future<List<Map<String, dynamic>>> getLeaderboardData() async {
    if (!await isOnline()) return [];
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('id, username, total_score, avatar_data, avatar_color_index, status') 
          .order('total_score', ascending: false)
          .limit(50);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }
}