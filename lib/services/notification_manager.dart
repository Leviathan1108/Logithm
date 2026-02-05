import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final ValueNotifier<int> unreadCount = ValueNotifier(0);

  Future<void> init() async {
    // 1. Setup Android
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/launcher_icon'); 

    // 2. Setup iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 3. Initialize Plugin
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notifikasi diklik: ${response.payload}");
      },
    );

    // [BARU] 4. BUAT CHANNEL SECARA EKSPLISIT (PENTING UNTUK ANDROID 8+)
    // Agar notifikasi background bisa masuk ke channel yang benar
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        // Request Permission
        await androidImplementation.requestNotificationsPermission();

        // Create Channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'channel_logithm_main', // ID harus SAMA dengan di AndroidManifest
          'Logithm Notifications', // Nama yang muncul di setting HP
          description: 'Pemberitahuan aplikasi Logithm',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );
        
        await androidImplementation.createNotificationChannel(channel);
      }
    }

    // 5. Mulai dengarkan update dari database
    _listenToSupabase();
  }

  // --- [PENTING] FUNGSI PUBLIK UNTUK DIPANGGIL DARI MAIN.DART ---
  // Fungsi ini dipanggil oleh FirebaseMessaging.onMessage di main.dart
  Future<void> showManualNotification({
    required String title, 
    required String body, 
    String? payload
  }) async {
    await _showAndroidNotification(title: title, body: body, payload: payload);
  }

  // --- LISTENER DATABASE (SUPABASE REALTIME) ---
  void _listenToSupabase() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    Supabase.instance.client
        .channel('public:notifications:$userId') 
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: userId),
          callback: (payload) {
            // [LOGIKA PENTING]
            // Kita HANYA update unread count di sini.
            // JANGAN show notifikasi di sini, karena FCM di main.dart sudah melakukannya.
            // Kalau di sini di-show juga, nanti notifikasi muncul 2 kali (double).
            
            debugPrint("Data baru di database, update counter...");
            _fetchUnreadCount(); 
          },
        )
        .subscribe();

    _fetchUnreadCount();
  }

  // --- FUNGSI INTERNAL MENAMPILKAN NOTIFIKASI ---
  Future<void> _showAndroidNotification({
    required String title, 
    required String body, 
    String? payload
  }) async {
    // ID Notifikasi unik berdasarkan waktu
    int notificationId = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_logithm_main', // ID Channel
      'Logithm Notifications', // Nama Channel
      channelDescription: 'Pemberitahuan aplikasi Logithm',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      // color: Colors.blue, // Opsional: Warna icon notif
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    try {
      await _localNotifications.show(
        notificationId, 
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      debugPrint("Gagal show notif lokal: $e");
    }
  }

  // --- HITUNG JUMLAH BELUM DIBACA ---
  Future<void> _fetchUnreadCount() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final res = await Supabase.instance.client
          .from('notifications')
          .select('id') 
          .eq('user_id', userId)
          .eq('is_read', false)
          .count(CountOption.exact);
      unreadCount.value = res.count;
    } catch (_) {}
  }

  // --- TANDAI SUDAH DIBACA (SATU) ---
  Future<void> markAsRead(int notificationId) async {
    try {
      await Supabase.instance.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      _fetchUnreadCount();
    } catch (_) {}
  }
  
  // --- TANDAI SUDAH DIBACA (SEMUA) ---
  Future<void> markAllAsRead() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await Supabase.instance.client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId);
      _fetchUnreadCount();
    } catch (_) {}
  }
}