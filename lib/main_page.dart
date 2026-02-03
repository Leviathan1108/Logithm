import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'belajar/belajar_page.dart';
import 'quiz/quiz_page.dart';
import 'leaderboard/leaderboard_page.dart';
import 'profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Home di tengah (index 2)
  int _currentIndex = 2;

  final List<Widget> _pages = const [
    LeaderboardPage(),   // index 0
    QuizPage(),          // index 1
    HomePage(),          // index 2 (tengah)
    BelajarPage(),       // index 3
    ProfilePage(),       // index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFE491FF),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,

        onTap: (index) => setState(() => _currentIndex = index),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: "Rank",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension_outlined),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: "Belajar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
