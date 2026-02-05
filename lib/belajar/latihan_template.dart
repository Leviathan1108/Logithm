import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../services/auth_manager.dart';
import '../services/audio_manager.dart'; 
import '../services/progress_manager.dart'; 

class LatihanTemplate extends StatefulWidget {
  final String title;
  final String question;
  final List<String> options;
  final List<String> explanations; 
  final int correctAnswerIndex;
  final int idMateri; 
  final int baseScore; 

  const LatihanTemplate({
    super.key,
    required this.title,
    required this.question,
    required this.options,
    required this.explanations, 
    required this.correctAnswerIndex,
    required this.idMateri,
    this.baseScore = 10, 
  });

  @override
  State<LatihanTemplate> createState() => _LatihanTemplateState();
}

class _LatihanTemplateState extends State<LatihanTemplate> {
  int? selectedIndex; 
  bool isChecked = false; 
  bool isCorrect = false; 
  bool isSaving = false; 
  bool pointsAwarded = false; 
  late int potentialScore; 

  late TutorialCoachMark _tutorialCoachMark;
  final GlobalKey _keyQuestion = GlobalKey();
  final GlobalKey _keyOptions = GlobalKey(); 
  final GlobalKey _keyCheckButton = GlobalKey();
  final GlobalKey _keyScoreHeader = GlobalKey(); 

  @override
  void initState() {
    super.initState();
    potentialScore = widget.baseScore; 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  // --- TUTORIAL ---
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('has_shown_latihan_tutorial') ?? false;
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
      onSkip: () { _markTutorialAsShown(); return true; },
    );
  }

  Future<void> _markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_latihan_tutorial', true);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "ScoreHeader",
        keyTarget: _keyScoreHeader,
        alignSkip: Alignment.bottomLeft,
        shape: ShapeLightFocus.RRect, radius: 20,
        contents: [TargetContent(align: ContentAlign.bottom, builder: (c,d) => const Text("Poin kamu ada di sini 🏆\nAkan berkurang jika salah jawab.", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))],
      ),
      TargetFocus(
        identify: "Question",
        keyTarget: _keyQuestion,
        shape: ShapeLightFocus.RRect, radius: 15,
        contents: [TargetContent(align: ContentAlign.bottom, builder: (c,d) => const Text("Baca soal di sini 📝", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))],
      ),
      TargetFocus(
        identify: "Options",
        keyTarget: _keyOptions,
        shape: ShapeLightFocus.RRect, radius: 12,
        contents: [TargetContent(align: ContentAlign.top, builder: (c,d) => const Text("Pilih jawaban yang benar 👉", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))],
      ),
      TargetFocus(
        identify: "CheckButton",
        keyTarget: _keyCheckButton,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect, radius: 12,
        contents: [TargetContent(align: ContentAlign.top, builder: (c,d) => const Text("Cek jawabanmu di sini ✅", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))],
      ),
    ];
  }

  // --- LOGIKA UTAMA (FIX AUDIO) ---
  void checkAnswer() async {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih jawaban dulu ya!")));
      return;
    }

    // 1. Matikan BGM sebentar agar SFX terdengar jelas
    AudioManager().pauseBGM();

    bool correct = selectedIndex == widget.correctAnswerIndex;

    setState(() {
      isChecked = true;
      isCorrect = correct;
    });

    if (correct) {
      // 2. Play Audio Benar
      // Pastikan fungsi ini ada di AudioManager atau gunakan playSfx('correct.mp3')
      await AudioManager().playLatihanCorrect(); 
      
      // 3. Nyalakan lagi BGM setelah durasi SFX (misal 2.5 detik)
      Future.delayed(const Duration(milliseconds: 7000), () {
        if (mounted) AudioManager().resumeBGM();
      });

      setState(() => isSaving = true);
      
      bool success = await ProgressManager.saveLatihanScore(widget.idMateri, potentialScore);
      
      setState(() {
        isSaving = false;
        pointsAwarded = success; 
      });

      if (mounted) {
        if (success) {
          _showTotalScoreDialog(potentialScore);
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Jawaban Benar! (Poin sudah diambil sebelumnya)"), backgroundColor: Colors.green),
          );
        }
      }
    } else {
      // 2. Play Audio Salah
      await AudioManager().playWrong();
      
      // 3. Nyalakan lagi BGM setelah durasi SFX (misal 1.5 detik)
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) AudioManager().resumeBGM();
      });

      setState(() {
        int minScore = (widget.baseScore * 0.2).toInt(); 
        if (minScore < 1) minScore = 1;
        potentialScore = (potentialScore - 2).clamp(minScore, widget.baseScore);
      });
    }
  }

  void _finishExercise() async {
    // Pastikan BGM menyala saat keluar (Resume, bukan Start dari awal)
    AudioManager().resumeBGM();

    int currentTotal = ProgressManager.totalScore.value;
    if (!mounted) return;
    Navigator.pop(context, {
      'completed': true,
      'latihanScore': pointsAwarded ? potentialScore : 0, 
      'totalAccountScore': currentTotal, 
    });
  }

  void retry() {
    setState(() {
      isChecked = false;
      isCorrect = false;
      selectedIndex = null;
    });
  }

  void _showTotalScoreDialog(int earnedLatihanScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, size: 80, color: Colors.amber),
              const SizedBox(height: 10),
              const Text("Level Selesai!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const SizedBox(height: 20),
              
              _buildScoreRow("Materi Belajar", "+10"),
              const SizedBox(height: 8),
              _buildScoreRow("Latihan Soal", "+$earnedLatihanScore"),
              const Divider(thickness: 1.5, height: 30),
              _buildScoreRow("Total Didapat", "+${10 + earnedLatihanScore}", isTotal: true),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); 
                    _finishExercise(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12)
                  ),
                  child: const Text("LANJUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreRow(String label, String score, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? Colors.black87 : Colors.grey[700])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: isTotal ? Colors.green : Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(score, style: TextStyle(fontWeight: FontWeight.bold, color: isTotal ? Colors.white : Colors.blueAccent)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    if (potentialScore >= widget.baseScore * 0.8) {
      scoreColor = Colors.green;
    } else if (potentialScore >= widget.baseScore * 0.5) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return PopScope(
      canPop: !isSaving, 
      onPopInvokedWithResult: (didPop, result) {
         if (didPop) return;
         if (isSaving) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tunggu sebentar, sedang menyimpan data...")));
         }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          centerTitle: false, 
          automaticallyImplyLeading: false, 
          actions: [
            Center(
              child: Container(
                key: _keyScoreHeader,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars_rounded, size: 18, color: scoreColor),
                    const SizedBox(width: 4),
                    Text(
                      "$potentialScore", 
                      style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 14)
                    ),
                    Text(
                      " Pts", 
                      style: TextStyle(color: scoreColor, fontSize: 12)
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // --- KARTU SOAL ---
              Container(
                key: _keyQuestion, 
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]
                ),
                child: Column(
                  children: [
                    const Text("PERTANYAAN", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(widget.question, style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- OPSI JAWABAN ---
              ...List.generate(widget.options.length, (index) {
                bool isSelected = selectedIndex == index;
                Color cardColor = Colors.white;
                Color borderColor = Colors.grey[300]!;
                IconData icon = Icons.circle_outlined;
                Color iconColor = Colors.grey;

                if (isChecked) {
                  if (index == widget.correctAnswerIndex) {
                    if (isSelected) {
                        cardColor = Colors.green[50]!; borderColor = Colors.green; icon = Icons.check_circle; iconColor = Colors.green;
                    } else {
                        borderColor = Colors.green.withOpacity(0.5); 
                    }
                  } else if (isSelected && !isCorrect) {
                    cardColor = Colors.red[50]!; borderColor = Colors.red; icon = Icons.cancel; iconColor = Colors.red;
                  }
                } else if (isSelected) {
                  cardColor = Colors.blue[50]!; borderColor = Colors.blue; icon = Icons.radio_button_checked; iconColor = Colors.blue;
                }

                return GestureDetector(
                  onTap: (isChecked || isSaving) ? null : () => setState(() => selectedIndex = index),
                  child: Container(
                    key: index == 0 ? _keyOptions : null, 
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor, width: 2)),
                    child: Row(
                      children: [
                        Icon(icon, color: iconColor),
                        const SizedBox(width: 15),
                        Expanded(child: Text(widget.options[index], style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),

              // --- PENJELASAN ---
              if (isChecked && selectedIndex != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: isCorrect ? Colors.green[50] : Colors.orange[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: isCorrect ? Colors.green : Colors.orange)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(isCorrect ? Icons.lightbulb : Icons.info_outline, color: isCorrect ? Colors.green[700] : Colors.orange[800], size: 20),
                          const SizedBox(width: 8),
                          Text(isCorrect ? "Jawaban Benar!" : "Kurang Tepat", style: TextStyle(fontWeight: FontWeight.bold, color: isCorrect ? Colors.green[800] : Colors.orange[900])),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(widget.explanations[selectedIndex!], style: const TextStyle(fontSize: 14, height: 1.4)),
                    ],
                  ),
                ),

              // --- TOMBOL AKSI ---
              ElevatedButton(
                key: _keyCheckButton, 
                onPressed: isSaving ? null : () {
                  if (!isChecked) {
                    checkAnswer();
                  } else {
                    if (isCorrect) {
                      _finishExercise(); 
                    } else {
                      retry(); 
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isChecked ? Colors.blueAccent : (isCorrect ? Colors.green : Colors.orange),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
                child: isSaving 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(!isChecked ? "Cek Jawaban" : (isCorrect ? "Selesai & Kembali" : "Coba Lagi"), style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}