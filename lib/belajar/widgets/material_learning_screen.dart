import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ganti path ini sesuai struktur folder Anda
import '../../services/progress_manager.dart'; 
import '../../services/audio_manager.dart';
import '../models/materi_model.dart';

// --- IMPORT SEMUA HALAMAN LATIHAN (Pastikan path benar) ---
import '../latihan/latihan1.dart';
import '../latihan/latihan2.dart';
import '../latihan/latihan3.dart';
import '../latihan/latihan4.dart';
import '../latihan/latihan5.dart';
import '../latihan/latihan6.dart';
import '../latihan/latihan7.dart';
import '../latihan/latihan8.dart';
import '../latihan/latihan9.dart';
import '../latihan/latihan10.dart';
import '../latihan/latihan11.dart';
import '../latihan/latihan12.dart';
import '../latihan/latihan13.dart';
import '../latihan/latihan14.dart';
import '../latihan/latihan15.dart';
import '../latihan/latihan16.dart';
import '../latihan/latihan17.dart';
import '../latihan/latihan18.dart';
import '../latihan/latihan19.dart';
import '../latihan/latihan20.dart';

import 'introduction_phase_widget.dart';
import 'definition_phase_widget.dart';
import 'analogy_phase_widget.dart';
import 'visualization_phase_widget.dart';

class MaterialLearningScreen extends StatefulWidget {
  final MateriContent content;

  const MaterialLearningScreen({
    super.key,
    required this.content,
  });

  @override
  State<MaterialLearningScreen> createState() => _MaterialLearningScreenState();
}

class _MaterialLearningScreenState extends State<MaterialLearningScreen> {
  final PageController _pageController = PageController();
  int _currentPhase = 0;
  bool _isLoading = false;

  late TutorialCoachMark _tutorialCoachMark;
  final GlobalKey _keyProgressBar = GlobalKey();
  final GlobalKey _keyNextButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- LOGIKA TUTORIAL ---
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('has_shown_learning_tutorial') ?? false;

    if (!hasShown) {
      _createTutorial();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _tutorialCoachMark.show(context: context);
      });
    }
  }

  void _createTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "LEWATI",
      paddingFocus: 5,
      opacityShadow: 0.85,
      onFinish: () => _markTutorialAsShown(),
      onSkip: () {
        _markTutorialAsShown();
        return true;
      },
    );
  }

  Future<void> _markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_learning_tutorial', true);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(TargetFocus(
      identify: "ProgressBar",
      keyTarget: _keyProgressBar,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tahapan Belajar 📊", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 10),
                Text("Materi dibagi menjadi 4 tahap: Pendahuluan, Analogi, Definisi, dan Visualisasi. Pantau progresmu di sini.", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            );
          },
        )
      ],
      shape: ShapeLightFocus.RRect,
      radius: 5,
    ));

    targets.add(TargetFocus(
      identify: "NextButton",
      keyTarget: _keyNextButton,
      alignSkip: Alignment.topLeft,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Lanjut Materi ➡️", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 10),
                Text("Tekan tombol ini untuk pindah ke tahap berikutnya. Di tahap terakhir, tombol ini akan membawamu ke Latihan Soal.", textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            );
          },
        )
      ],
      shape: ShapeLightFocus.RRect,
      radius: 30,
    ));

    return targets;
  }

  // --- LOGIKA Navigasi ke Latihan ---
  Widget _getLatihanPage(int id) {
    switch (id) {
      case 1: return const Latihan1();
      case 2: return const Latihan2();
      case 3: return const Latihan3();
      case 4: return const Latihan4();
      case 5: return const Latihan5();
      case 6: return const Latihan6();
      case 7: return const Latihan7();
      case 8: return const Latihan8();
      case 9: return const Latihan9();
      case 10: return const Latihan10();
      case 11: return const Latihan11();
      case 12: return const Latihan12();
      case 13: return const Latihan13();
      case 14: return const Latihan14();
      case 15: return const Latihan15();
      case 16: return const Latihan16();
      case 17: return const Latihan17();
      case 18: return const Latihan18();
      case 19: return const Latihan19();
      case 20: return const Latihan20();
      default: return const Scaffold(body: Center(child: Text("Latihan belum tersedia")));
    }
  }

  // --- [UPDATE] LOGIKA SELESAI MATERI ---
  Future<void> _finishAndGoToPractice() async {
    setState(() => _isLoading = true);
    
    // 1. Play Audio Materi Selesai
    await AudioManager().playMateriComplete();

    // 2. [BARU] Paksa BGM nyala lagi setelah 3 detik
    // Ini memastikan musik latar kembali hidup setelah SFX selesai
    Future.delayed(const Duration(seconds: 3), () {
      AudioManager().startBackgroundMusic();
    });

    try {
      // 3. Simpan Progress dan Cek Status (Apakah Baru?)
      bool isFirstTimeCompletion = await ProgressManager.markAsComplete(widget.content.id);
      
      if (mounted) {
        setState(() => _isLoading = false); // Stop loading sebelum popup

        if (isFirstTimeCompletion) {
          // A. Jika Baru Pertama Kali Selesai -> Tampilkan Pop-Up Reward
          await showDialog(
            context: context,
            barrierDismissible: false, // User harus klik tombol
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/trophy.png', height: 100, errorBuilder: (c,e,s) => const Icon(Icons.emoji_events, size: 80, color: Colors.amber)),
                    const SizedBox(height: 16),
                    Text(
                      "Selamat!",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Kamu telah menyelesaikan materi ini.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            "+10 Poin",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Tutup Dialog
                        _navigateToPractice(); // Lanjut ke Latihan
                      },
                      child: const Text("Lanjut Latihan"),
                    ),
                  )
                ],
              );
            },
          );
        } else {
          // B. Jika Sudah Pernah Selesai -> Langsung Pindah tanpa Pop-up
          _navigateToPractice();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToPractice() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _getLatihanPage(widget.content.id)),
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentPhase = index);
    HapticFeedback.lightImpact();
  }

  void _nextPhase() {
    if (_currentPhase < 3) {
      _pageController.animateToPage(
        _currentPhase + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishAndGoToPractice();
    }
  }

  void _previousPhase() {
    if (_currentPhase > 0) {
      _pageController.animateToPage(
        _currentPhase - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = widget.content;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(theme, data.title),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: [
                  IntroductionPhaseWidget(
                    title: data.introduction['title'] ?? '',
                    description: data.introduction['description'] ?? '',
                    conceptOverview: data.introduction['conceptOverview'] ?? '',
                  ),
                  AnalogyPhaseWidget(
                    title: data.analogy['title'] ?? '',
                    analogyTitle: data.analogy['analogyTitle'] ?? '',
                    analogyDescription: data.analogy['analogyDescription'] ?? '',
                    realWorldExample: data.analogy['realWorldExample'] ?? '',
                    imageUrl: data.analogy['imageUrl'] ?? '',
                    semanticLabel: data.analogy['semanticLabel'] ?? '',
                  ),
                  DefinitionPhaseWidget(
                    title: data.definition['title'] ?? '',
                    technicalDefinition: data.definition['technicalDefinition'] ?? '',
                    codeExample: data.definition['codeExample'] ?? '',
                    syntax: data.definition['syntax'] ?? '',
                  ),
                  VisualizationPhaseWidget(
                    title: data.visualization['title'] ?? '',
                    visualizationType: data.visualization['visualizationType'] ?? 'default',
                    description: data.visualization['description'] ?? '',
                  ),
                ],
              ),
            ),
            _buildBottomNavigation(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.primary),
                onPressed: () => Navigator.of(context).pop(), 
              ),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            key: _keyProgressBar,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentPhase + 1) / 4,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          if (_currentPhase > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousPhase,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Kembali'),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 1.5.h)),
              ),
            )
          else
            const Spacer(),
          SizedBox(width: 4.w),
          Expanded(
            child: Container(
              key: _keyNextButton, 
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _nextPhase,
                icon: _isLoading 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(_currentPhase < 3 ? Icons.arrow_forward : Icons.play_arrow, size: 18), 
                label: Text(_currentPhase < 3 ? 'Lanjut' : 'Mulai Latihan'), 
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}