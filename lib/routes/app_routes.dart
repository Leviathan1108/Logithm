// lib/routes/app_routes.dart

import 'package:flutter/material.dart';

// Import halaman-halaman yang sudah kita buat sebelumnya
import '../home/home_page.dart';
import '../belajar/materi_list_page.dart';
import '../quiz/quiz_page.dart';
import '../belajar/belajar_page.dart';
import '../profile/profile_page.dart';
import '../auth/login_page.dart';

class AppRoutes {
  // Nama route harus SAMA PERSIS dengan yang dipanggil di HomeDashboard baru
  static const String initial = '/';
  static const String homeDashboard = '/home-dashboard';
  static const String materialMap = '/material-map-screen';
  static const String quizList = '/quiz-list-screen';
  static const String materialLearning = '/material-learning-screen';
  static const String profile = '/profile-screen';
  static const String login = '/login-screen';

  // Peta Navigasi
  static Map<String, WidgetBuilder> routes = {
    // Route Awal
    initial: (context) => const HomePage(),
    
    // Route Utama
    homeDashboard: (context) => const HomePage(),
    
    // Peta Materi
    materialMap: (context) => const MateriListPage(),
    
    // Daftar Quiz
    quizList: (context) => const QuizPage(),
    
    // Halaman Belajar (Materi Aktif)
    materialLearning: (context) => const BelajarPage(),
    
    // Profil
    profile: (context) => const ProfilePage(),

    // Login
    login: (context) => const LoginPage(),
  };
}