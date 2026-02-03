import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'; // [WAJIB] Tambahkan package ini
import 'fullscreen_visualization.dart';
import '../services/auth_manager.dart';
import '../services/audio_manager.dart'; 

// ==========================================
// 1. HELPER WIDGETS (DEKORASI) - Tidak Berubah
// ==========================================
class BranchAnimation extends StatelessWidget {
  final double progress;
  const BranchAnimation({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 150),
      painter: _BranchPainter(progress),
    );
  }
}

class _BranchPainter extends CustomPainter {
  final double progress;
  _BranchPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width * 0.5;
    final start = Offset(centerX, 0);
    final splitY = 40.0;
    
    if (progress > 0) {
       canvas.drawLine(start, Offset(centerX, splitY * (progress * 2).clamp(0, 1)), paint);
    }

    if (progress > 0.3) {
      double branchProgress = ((progress - 0.3) * 2).clamp(0.0, 1.0);
      final leftPath = Path();
      leftPath.moveTo(centerX, splitY);
      leftPath.quadraticBezierTo(centerX - 20, splitY + 20, centerX - (80 * branchProgress), splitY + 60);
      canvas.drawPath(leftPath, paint);

      final rightPath = Path();
      rightPath.moveTo(centerX, splitY);
      rightPath.quadraticBezierTo(centerX + 20, splitY + 20, centerX + (80 * branchProgress), splitY + 60);
      canvas.drawPath(rightPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==========================================
// 2. TEMPLATE UTAMA (LOGIC & UI)
// ==========================================

class MateriTemplate extends StatefulWidget {
  final int idMateri; 
  final String title;
  final String content;
  final Duration duration;
  final Widget Function(AnimationController) animationBuilder;
  final Widget nextPage; 

  const MateriTemplate({
    super.key,
    required this.idMateri,
    required this.title,
    required this.content,
    required this.duration,
    required this.animationBuilder,
    required this.nextPage,
  });

  @override
  State<MateriTemplate> createState() => _MateriTemplateState();
}

class _MateriTemplateState extends State<MateriTemplate> {
  bool _isProcessing = false; 
  
  // [BARU] Variable Tutorial
  final GlobalKey _keyVisualisasi = GlobalKey();
  final GlobalKey _keySelesai = GlobalKey();
  late TutorialCoachMark _tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Cek Tutorial setelah layout selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  // --- LOGIKA TUTORIAL ---
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    // Gunakan key unik agar hanya muncul sekali seumur hidup aplikasi
    bool hasShown = prefs.getBool('has_shown_materi_tutorial') ?? false;

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
      paddingFocus: 10,
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
    await prefs.setBool('has_shown_materi_tutorial', true);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // Target 1: Tombol Visualisasi
    targets.add(TargetFocus(
      identify: "Visualisasi",
      keyTarget: _keyVisualisasi,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lihat Visualisasi 🎥",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "Bingung dengan teks? Tekan tombol ini untuk melihat animasi penjelasannya secara Full Screen.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            );
          },
        )
      ],
    ));

    // Target 2: Tombol Selesai
    targets.add(TargetFocus(
      identify: "Selesai",
      keyTarget: _keySelesai,
      alignSkip: Alignment.topRight,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selesaikan Materi ✅",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "Jika sudah paham, tekan tombol ini untuk mendapatkan poin dan lanjut ke latihan soal.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            );
          },
        )
      ],
    ));

    return targets;
  }

  // --- LOGIKA CEK & SIMPAN PENYELESAIAN MATERI ---
  Future<bool> _checkAndSaveCompletion() async {
    setState(() => _isProcessing = true);
    
    final user = Supabase.instance.client.auth.currentUser;
    int pointsToAdd = 10; 

    try {
      if (user != null) {
        final supabase = Supabase.instance.client;
        final check = await supabase
            .from('user_progress')
            .select()
            .match({'user_id': user.id, 'materi_id': widget.idMateri})
            .maybeSingle();

        if (check != null) return false;

        await supabase.from('user_progress').insert({
          'user_id': user.id,
          'materi_id': widget.idMateri,
          'score_earned': pointsToAdd,
          'completed_at': DateTime.now().toIso8601String(),
        });

        final profile = await supabase.from('profiles').select('total_score').eq('id', user.id).single();
        int currentTotal = profile['total_score'] ?? 0;

        await supabase.from('profiles').update({'total_score': currentTotal + pointsToAdd}).eq('id', user.id);
        return true; 
      } else {
        final prefs = await SharedPreferences.getInstance();
        List<String> finished = prefs.getStringList('guest_finished_materi') ?? [];
        if (finished.contains(widget.idMateri.toString())) return false; 

        finished.add(widget.idMateri.toString());
        await prefs.setStringList('guest_finished_materi', finished);
        
        int localScore = prefs.getInt('guest_total_score') ?? 0;
        await prefs.setInt('guest_total_score', localScore + pointsToAdd);
        
        AuthManager().guestScore = localScore + pointsToAdd;
        AuthManager().guestCompletedMateriIds.add(widget.idMateri);
        return true; 
      }
    } catch (e) {
      debugPrint("Error saving materi completion: $e");
      return false; 
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- TAMPILKAN POP-UP SELESAI ---
  void _showCompletionDialog() async {
    bool isFirstTime = await _checkAndSaveCompletion();

    if (!mounted) return;

    if (isFirstTime) {
       await AudioManager().playMateriComplete();
    }

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              isFirstTime ? Icons.check_circle : Icons.history, 
              color: isFirstTime ? Colors.green : Colors.blueGrey, 
              size: 60
            ),
            const SizedBox(height: 10),
            Text(
              isFirstTime ? "Materi Selesai!" : "Review Selesai", 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isFirstTime 
                ? "Selamat! Anda telah mempelajari konsep ini dengan baik."
                : "Anda telah membaca ulang materi ini untuk memperkuat ingatan.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            if (isFirstTime)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: Colors.orange),
                    SizedBox(width: 10),
                    Text(
                      "+10 Poin",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange),
                    ),
                  ],
                ),
              )
            else
              const Text(
                "Poin materi ini sudah Anda ambil sebelumnya.",
                style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => widget.nextPage),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Lanjut ke Latihan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // --- BAGIAN 1: KARTU MATERI ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: Colors.indigo[400], size: 28),
                        const SizedBox(width: 15),
                        Text(
                          "Konsep & Penjelasan",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[800]),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    _buildCleanContent(widget.content),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- BAGIAN 2: TOMBOL VISUALISASI ---
              Center(
                child: Container(
                  key: _keyVisualisasi, // [KEY 1: DISINI]
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Colors.black.withOpacity(0.9),
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation1, animation2) {
                          return FullScreenVisualization(
                            title: widget.title,
                            duration: widget.duration,
                            animationBuilder: widget.animationBuilder,
                          );
                        },
                        transitionBuilder: (context, animation1, animation2, child) {
                          return SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(
                              parent: animation1,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[50],
                      foregroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      side: BorderSide(color: Colors.indigo.withOpacity(0.3)),
                    ),
                    icon: const Icon(Icons.play_circle_fill_rounded, size: 28),
                    label: const Text("PUTAR VISUALISASI (FULL SCREEN)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      
      // --- BAGIAN 3: TOMBOL LANJUT (FLOATING) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
        ),
        child: Container(
          key: _keySelesai, // [KEY 2: DISINI]
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _showCompletionDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              shadowColor: Colors.indigo.withOpacity(0.4),
            ),
            child: _isProcessing 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Selesaikan & Latihan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Icon(Icons.check_circle_outline, color: Colors.white),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildCleanContent(String rawContent) {
    List<String> paragraphs = rawContent.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        if (paragraph.trim().startsWith('#')) {
             return Padding(
               padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
               child: Text(
                 paragraph.replaceAll('#', '').trim(), 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
               ),
             );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            paragraph,
            style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.6),
            textAlign: TextAlign.left,
          ),
        );
      }).toList(),
    );
  }
}