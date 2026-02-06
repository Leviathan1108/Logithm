import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Tambahkan ini untuk background handler

// --- IMPORTS ---
import 'services/audio_manager.dart'; 
import 'services/notification_manager.dart'; 
import 'splash/splash_screen.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// [PENTING] Handler Notifikasi Background (Saat App Mati/Minimize)
// Kode ini berjalan di isolate terpisah, jadi harus inisialisasi plugin sendiri
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Notifikasi Background diterima: ${message.messageId}");

  // JAGA-JAGA: Jika Edge Function mengirim Data Message saja (tanpa notification object),
  // atau jika Android memblokir notifikasi sistem, kita paksa munculkan di sini.
  if (message.notification == null && message.data.isNotEmpty) {
    final FlutterLocalNotificationsPlugin localNotif = FlutterLocalNotificationsPlugin();
    
    // Setup minimal untuk background isolate
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await localNotif.initialize(settings);

    await localNotif.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.data['title'] ?? 'Info', // Pastikan edge function kirim title di data
      message.data['body'] ?? 'Pesan baru masuk', 
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_logithm_main', // ID Channel HARUS SAMA
          'Logithm Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. SETUP FIREBASE
  await Firebase.initializeApp();
  
  // Daftarkan handler background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 2. KONEKSI KE SUPABASE
  await Supabase.initialize(
    url: 'https://vrirlswbgzpwwqujmypv.supabase.co',
    anonKey: 'sb_publishable_pudzup14Zxw9KAnMSJEN2w_00GRTccc',
  );

  // 3. SETUP NOTIFIKASI LOKAL & CHANNEL
  // Ini akan membuat Channel ID di Android settings saat pertama kali run
  await NotificationManager().init();

  // 4. MULAI MUSIK
  await AudioManager().startBackgroundMusic();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _updatePresence();
    _setupFCMListeners();

    // Request permission agak dipercepat
    _requestNotificationPermission();
  }

  // --- LOGIKA FCM LISTENER ---
  void _setupFCMListeners() {
    // 1. Saat App DIBUKA (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Pesan Foreground: ${message.notification?.title}");
      
      // Tampilkan notifikasi lokal agar user sadar ada pesan masuk saat main app
      NotificationManager().showManualNotification(
        title: message.notification?.title ?? message.data['title'] ?? 'Info',
        body: message.notification?.body ?? message.data['body'] ?? '',
        payload: message.data['type'],
      );
    });

    // 2. Saat Notifikasi DIKLIK (Dari background state)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notifikasi diklik dari background!");
      // Logic navigasi bisa ditaruh di sini
    });
    
    // 3. Saat Notifikasi DIKLIK (Dari Terminated state / App Mati)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("App dibuka dari notifikasi (Terminated): ${message.data}");
        // Logic navigasi bisa ditaruh di sini
      }
    });
  }

  // --- FUNGSI REQUEST PERMISSION ---
  Future<void> _requestNotificationPermission() async {
    // Minta izin via Permission Handler (Android 13+)
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } 
    
    // Minta izin via Firebase
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioManager().stopBackgroundMusic();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updatePresence(); 
      AudioManager().startBackgroundMusic(); 
    } 
    else if (state == AppLifecycleState.paused) {
      AudioManager().stopBackgroundMusic(); 
    }
  }

  Future<void> _updatePresence() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client
            .from('profiles')
            .update({
              'last_active': DateTime.now().toIso8601String(),
            })
            .eq('id', user.id);
      } catch (e) {
        debugPrint("Gagal update presence: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Logithm', 
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
            fontFamily: 'Roboto', 
          ),
          home: const SplashScreen(), 
        );
      },
    );
  }
}