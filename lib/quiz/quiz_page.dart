import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORT SERVICES ---
import '../services/progress_manager.dart'; // Pastikan path ini benar

// --- IMPORT LEVEL QUIZ (Pastikan file-file ini ada) ---
import 'levels/quiz1.dart';
import 'levels/quiz2.dart';
import 'levels/quiz3.dart';
import 'levels/quiz4.dart';
import 'levels/quiz5.dart';
import 'levels/quiz6.dart';
import 'levels/quiz7.dart';
import 'levels/quiz8.dart';
import 'levels/quiz9.dart';
import 'levels/quiz10.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _isLoading = true;
  
  late List<QuizLevelModel> _allQuizzes;
  List<QuizLevelModel> _filteredQuizzes = [];

  @override
  void initState() {
    super.initState();
    _initQuizData();
    _loadData();
  }

  // --- 1. DATA QUIZ ---
  void _initQuizData() {
    _allQuizzes = [
      QuizLevelModel(id: 1, title: "Robot Hero", desc: "Sequence & Algoritma", requiredMateri: 0, theme: "Robot Rescue", difficulty: "Easy", time: "5 min", page: const Quiz1()),
      QuizLevelModel(id: 2, title: "Kode Brankas", desc: "Logika AND (&&)", requiredMateri: 4, theme: "Bank Vault", difficulty: "Medium", time: "10 min", page: const Quiz2()),
      QuizLevelModel(id: 3, title: "Looping Labirin", desc: "While Loop", requiredMateri: 13, theme: "Maze", difficulty: "Hard", time: "15 min", page: const Quiz3()),
      QuizLevelModel(id: 4, title: "Kode Rahasia", desc: "Ternary Operator", requiredMateri: 10, theme: "Cryptography", difficulty: "Easy", time: "8 min", page: const Quiz4()),
      QuizLevelModel(id: 5, title: "Array Hacker", desc: "For Loop & Indexing", requiredMateri: 12, theme: "Data Sort", difficulty: "Medium", time: "12 min", page: const Quiz5()),
      QuizLevelModel(id: 6, title: "Pabrik Robot", desc: "Do-While Loop", requiredMateri: 14, theme: "Factory", difficulty: "Medium", time: "12 min", page: const Quiz6()),
      QuizLevelModel(id: 7, title: "Bug Hunter 1", desc: "Break Statement", requiredMateri: 16, theme: "Antivirus", difficulty: "Hard", time: "10 min", page: const Quiz7()),
      QuizLevelModel(id: 8, title: "Bug Hunter 2", desc: "Nested Loop Fix", requiredMateri: 18, theme: "Radar", difficulty: "Hard", time: "20 min", page: const Quiz8()),
      QuizLevelModel(id: 9, title: "Memory Saver", desc: "Continue Statement", requiredMateri: 17, theme: "Optimization", difficulty: "Medium", time: "15 min", page: const Quiz9()),
      QuizLevelModel(id: 10, title: "The Final Boss", desc: "Comprehensive Exam", requiredMateri: 20, theme: "Boss Battle", difficulty: "Expert", time: "30 min", page: const Quiz10()),
    ];
    _filteredQuizzes = List.from(_allQuizzes);
  }

  Future<void> _loadData() async {
    // Simulasi loading UI agar smooth
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isLoading = false);
  }

  // --- 2. LOGIC FILTER ---
  void _applyFilters() {
    List<QuizLevelModel> temp = List.from(_allQuizzes);

    // Filter Search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      temp = temp.where((q) => 
        q.title.toLowerCase().contains(query) || 
        q.desc.toLowerCase().contains(query)
      ).toList();
    }

    // Filter Kategori
    if (_selectedFilter != 'All') {
      // Kita ambil jumlah materi yang selesai sebagai penentu Unlock
      int totalSelesai = ProgressManager.completedMateri.value.length;
      
      switch (_selectedFilter) {
        case 'Easy':
          temp = temp.where((q) => q.difficulty == 'Easy').toList();
          break;
        case 'Medium':
          temp = temp.where((q) => q.difficulty == 'Medium').toList();
          break;
        case 'Hard':
          temp = temp.where((q) => q.difficulty == 'Hard' || q.difficulty == 'Expert').toList();
          break;
        case 'Unlocked':
          temp = temp.where((q) => totalSelesai >= q.requiredMateri).toList();
          break;
      }
    }

    setState(() => _filteredQuizzes = temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Background Abu Soft
      appBar: AppBar(
        title: Text(
          'Tantangan Koding', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      
      body: _isLoading 
        ? const _SkeletonLoader() 
        : Column(
            children: [
              // SEARCH & FILTER AREA
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 2.h),
                child: Column(
                  children: [
                    _SearchBar(
                      controller: _searchController,
                      onChanged: (val) => _applyFilters(),
                      onClear: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    ),
                    SizedBox(height: 1.5.h),
                    _FilterChips(
                      selected: _selectedFilter,
                      onChanged: (val) {
                        setState(() => _selectedFilter = val);
                        _applyFilters();
                      },
                    ),
                  ],
                ),
              ),

              // LIST QUIZ
              Expanded(
                child: ValueListenableBuilder<Set<int>>(
                  valueListenable: ProgressManager.completedMateri,
                  builder: (context, completedIds, _) {
                    int totalMateriSelesai = completedIds.length;

                    if (_filteredQuizzes.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      itemCount: _filteredQuizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = _filteredQuizzes[index];
                        // Logika Unlock: User harus menyelesaikan X materi dulu
                        bool isUnlocked = totalMateriSelesai >= quiz.requiredMateri;

                        return _QuizCard(
                          quiz: quiz,
                          isUnlocked: isUnlocked,
                          onTap: () {
                            if (isUnlocked) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => quiz.page));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.lock, color: Colors.white, size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text("Selesaikan ${quiz.requiredMateri} Materi dulu!")),
                                    ],
                                  ),
                                  backgroundColor: Colors.grey[800],
                                  behavior: SnackBarBehavior.floating,
                                )
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                ),
              ),
            ],
          ),
    );
  }
}

// =================================================================
// DATA MODEL
// =================================================================
class QuizLevelModel {
  final int id;
  final String title;
  final String desc;
  final int requiredMateri;
  final Widget page;
  final String theme;
  final String difficulty;
  final String time;

  QuizLevelModel({
    required this.id, 
    required this.title, 
    required this.desc, 
    required this.requiredMateri, 
    required this.page,
    this.theme = "General",
    this.difficulty = "Medium",
    this.time = "10 min"
  });
}

// =================================================================
// CUSTOM WIDGETS
// =================================================================

class _QuizCard extends StatelessWidget {
  final QuizLevelModel quiz;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _QuizCard({required this.quiz, required this.isUnlocked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Color Logic based on Difficulty
    Color accentColor = Colors.blue;
    if (quiz.difficulty == 'Easy') accentColor = Colors.green;
    if (quiz.difficulty == 'Hard') accentColor = Colors.orange;
    if (quiz.difficulty == 'Expert') accentColor = Colors.redAccent;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: isUnlocked ? null : Border.all(color: Colors.grey[300]!),
        boxShadow: isUnlocked 
          ? [BoxShadow(color: Colors.indigo.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))]
          : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. ICON BOX
                    Container(
                      height: 60, width: 60,
                      decoration: BoxDecoration(
                        color: isUnlocked ? accentColor.withOpacity(0.1) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        isUnlocked ? _getThemeIcon(quiz.theme) : Icons.lock,
                        color: isUnlocked ? accentColor : Colors.grey,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    
                    // 2. TEXT INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: isUnlocked ? Colors.black87 : Colors.grey[600]
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quiz.desc,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                
                // 3. TAGS & BUTTON ROW
                Row(
                  children: [
                    _InfoTag(
                      text: quiz.difficulty, 
                      color: isUnlocked ? accentColor : Colors.grey,
                      icon: Icons.signal_cellular_alt
                    ),
                    SizedBox(width: 2.w),
                    _InfoTag(
                      text: quiz.time, 
                      color: Colors.grey,
                      icon: Icons.timer_outlined
                    ),
                    const Spacer(),
                    
                    // Start Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isUnlocked ? Colors.indigoAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: isUnlocked ? null : Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isUnlocked ? "Mulai" : "Terkunci",
                            style: TextStyle(
                              color: isUnlocked ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp
                            ),
                          ),
                          if (isUnlocked) ...[
                            const SizedBox(width: 5),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 14)
                          ]
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getThemeIcon(String theme) {
    switch(theme) {
      case 'Robot Rescue': return Icons.smart_toy;
      case 'Bank Vault': return Icons.lock_open;
      case 'Maze': return Icons.grid_view;
      case 'Boss Battle': return Icons.local_fire_department;
      case 'Data Sort': return Icons.bar_chart;
      case 'Cryptography': return Icons.vpn_key;
      default: return Icons.code;
    }
  }
}

class _InfoTag extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _InfoTag({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text, 
            style: GoogleFonts.poppins(
              fontSize: 9.sp, 
              fontWeight: FontWeight.w500, 
              color: color
            )
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const _SearchBar({required this.controller, required this.onChanged, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.poppins(color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Cari Tantangan...",
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller.text.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: onClear) 
            : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const _FilterChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final filters = ["All", "Easy", "Medium", "Hard", "Unlocked"];
    return SizedBox(
      height: 4.5.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigoAccent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.indigoAccent : Colors.grey[300]!),
                boxShadow: isSelected 
                  ? [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                  : [],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 10.sp
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.manage_search, size: 60, color: Colors.grey[300]),
          SizedBox(height: 2.h),
          Text("Quiz tidak ditemukan", style: GoogleFonts.poppins(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: EdgeInsets.only(bottom: 2.h),
        height: 15.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15))),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 150, height: 15, color: Colors.grey[200]),
                    SizedBox(height: 10),
                    Container(width: 100, height: 10, color: Colors.grey[200]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}