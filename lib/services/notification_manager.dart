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
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    // 3. Initialize (VERSI STABIL 17.x)
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notifikasi diklik: ${response.payload}");
      },
    );

    // 4. Request Permission (Android 13+)
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }

    _listenToSupabase();
  }

  void _listenToSupabase() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    Supabase.instance.client
        .channel('public:notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: userId),
          callback: (payload) {
            final newRecord = payload.newRecord;
            _showAndroidNotification(
              title: newRecord['title']?.toString() ?? 'Info',
              body: newRecord['body']?.toString() ?? '',
              payload: newRecord['type']?.toString(), 
            );
            _fetchUnreadCount(); 
          },
        )
        .subscribe();

    _fetchUnreadCount();
  }

  Future<void> _showAndroidNotification({
    required String title, 
    required String body, 
    String? payload
  }) async {
    // ID Notifikasi (Int)
    int notificationId = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

    // Detail Notifikasi
    // HAPUS 'channelDescription' jika masih error, tapi di v17 biasanya aman.
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_logithm_main', 
      'Logithm Notifications',
      channelDescription: 'Pemberitahuan aplikasi Logithm',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    // TAMPILKAN
    try {
      await _localNotifications.show(
        notificationId, 
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      debugPrint("Gagal show notif: $e");
    }
  }

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

  Future<void> markAsRead(int notificationId) async {
    try {
      await Supabase.instance.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
      _fetchUnreadCount();
    } catch (_) {}
  }
  
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