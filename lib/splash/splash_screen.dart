import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// Import services untuk inisialisasi
import '../services/auth_manager.dart';
import '../services/progress_manager.dart';
import '../home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _bgColorAnimation;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Animasi (Durasi 3 Detik)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Animasi Background: Putih -> Hitam
    _bgColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
    ));

    // Animasi Teks: Hitam -> Putih
    _textColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
    ));

    // 2. Jalankan Logika
    _startAppSequence();
  }

  Future<void> _startAppSequence() async {
    // Mulai Animasi
    _controller.forward();

    // Sambil animasi berjalan, kita Inisialisasi Data di background
    final initFuture = Future.wait([
      AuthManager().init(), // AuthManager pakai Singleton Factory, jadi pakai ()
      
      // PERBAIKAN 1: Hapus tanda kurung () karena init() adalah static method
      ProgressManager.init(), 
      
      // Tambahan delay agar animasi terlihat utuh
      Future.delayed(const Duration(seconds: 3)), 
    ]);

    // Tunggu keduanya (Animasi selesai & Data siap)
    await initFuture;

    // Pindah ke Home Page
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bgColorAnimation.value, // Background berubah
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Teks
                Text(
                  "LOGITHM",
                  // PERBAIKAN 2: Gunakan 'jetBrainsMono' (huruf B besar)
                  style: GoogleFonts.jetBrainsMono( 
                    fontSize: 32.sp, // Ukuran responsif
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5.0,
                    color: _textColorAnimation.value, // Warna teks berubah
                  ),
                ),
                SizedBox(height: 2.h),
                // Loading Indicator kecil (pudar saat selesai)
                Opacity(
                  opacity: _controller.value < 0.8 ? 1.0 : 0.0,
                  child: SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2, 
                      color: _textColorAnimation.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}