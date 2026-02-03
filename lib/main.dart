import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart'; // [WAJIB] Pastikan package ini ada

// --- IMPORTS ---
import 'services/audio_manager.dart'; 
import 'splash/splash_screen.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. KONEKSI KE SUPABASE
  await Supabase.initialize(
    url: 'https://vrirlswbgzpwwqujmypv.supabase.co',
    anonKey: 'sb_publishable_pudzup14Zxw9KAnMSJEN2w_00GRTccc',
  );

  // 2. MULAI MUSIK BACKGROUND
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
    
    // 1. Update Status Online
    _updatePresence();

    // 2. [BARU] Minta Izin Notifikasi (Android 13+)
    // Diberi delay 2 detik agar tidak bentrok dengan loading awal
    Future.delayed(const Duration(seconds: 2), () {
      _requestNotificationPermission();
    });
  }

  // --- FUNGSI REQUEST PERMISSION ---
  Future<void> _requestNotificationPermission() async {
    // Cek status izin notifikasi saat ini
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      // Jika belum diizinkan, munculkan dialog sistem
      await Permission.notification.request();
    } 
    // Jika user pernah menolak permanen (Don't allow), tidak perlu dipaksa lagi
    // agar tidak mengganggu pengalaman pengguna.
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
      // A. Aplikasi KEMBALI aktif (Foreground)
      _updatePresence(); 
      AudioManager().startBackgroundMusic(); // Lanjut musik
    } 
    else if (state == AppLifecycleState.paused) {
      // B. Aplikasi di-MINIMIZE (Background)
      AudioManager().stopBackgroundMusic(); // Stop musik hemat baterai
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