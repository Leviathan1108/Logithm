import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:firebase_core/firebase_core.dart'; // [WAJIB] Core Firebase
import 'package:firebase_messaging/firebase_messaging.dart'; // [WAJIB] FCM

// --- IMPORTS ---
import 'services/audio_manager.dart'; 
import 'services/notification_manager.dart'; 
import 'splash/splash_screen.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// [PENTING] Handler Notifikasi Background (Saat App Mati/Minimize)
// Harus ditaruh di luar class (Top Level Function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Pastikan Firebase di-init di isolate terpisah ini
  await Firebase.initializeApp();
  debugPrint("Notifikasi Background diterima: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. SETUP FIREBASE (Urutan Pertama)
  // Wajib ada agar FCM di AuthManager tidak error
  await Firebase.initializeApp();
  
  // Daftarkan handler untuk notifikasi saat app mati
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 2. KONEKSI KE SUPABASE
  await Supabase.initialize(
    url: 'https://vrirlswbgzpwwqujmypv.supabase.co',
    anonKey: 'sb_publishable_pudzup14Zxw9KAnMSJEN2w_00GRTccc',
  );

  // 3. SETUP NOTIFIKASI LOKAL (Agar channel Android dibuat)
  await NotificationManager().init();

  // 4. MULAI MUSIK BACKGROUND
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
    
    // A. Update Status Online Database
    _updatePresence();

    // B. Setup Listener Notifikasi (FCM)
    _setupFCMListeners();

    // C. Request Permission (Delay sedikit agar tidak tabrakan saat startup)
    Future.delayed(const Duration(seconds: 2), () {
      _requestNotificationPermission();
    });
  }

  // --- LOGIKA FCM LISTENER ---
  void _setupFCMListeners() {
    // 1. Saat App sedang DIBUKA (Foreground)
    // Firebase tidak otomatis munculkan notif jika app sedang dibuka.
    // Kita harus memunculkannya manual pakai NotificationManager.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Pesan Foreground diterima: ${message.notification?.title}");
      
      if (message.notification != null) {
        // Panggil fungsi publik di NotificationManager
        NotificationManager().showManualNotification(
          title: message.notification!.title ?? 'Info',
          body: message.notification!.body ?? '',
          payload: message.data['type'],
        );
      }
    });

    // 2. Saat Notifikasi DIKLIK (Dari background/closed)
    // (Opsional) Tambahkan logika navigasi di sini
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notifikasi diklik dari background!");
      // Contoh: Navigator.pushNamed(...)
    });
  }

  // --- FUNGSI REQUEST PERMISSION ---
  Future<void> _requestNotificationPermission() async {
    // Minta izin via Permission Handler (Android 13+)
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } 
    
    // Minta izin via Firebase (Khusus iOS & Android Settings)
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
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
      // App kembali aktif
      _updatePresence(); 
      AudioManager().startBackgroundMusic(); 
    } 
    else if (state == AppLifecycleState.paused) {
      // App di-minimize
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