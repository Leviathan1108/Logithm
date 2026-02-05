import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../services/audio_manager.dart';
import '../services/progress_manager.dart';

// Enum untuk membedakan fase tampilan
enum QuizPhase { intro, active }

class DragDropQuiz extends StatefulWidget {
  final String title;
  final String instruction;
  final List<String> codeSnippet;
  final List<String> options;
  final Map<int, String> correctAnswers;
  
  // Base Score ini akan menjadi Cap Poin (15, 20, 25, 30) sesuai Level
  final int baseScore; 
  final Duration initialDuration; 

  const DragDropQuiz({
    super.key,
    required this.title,
    required this.instruction,
    required this.codeSnippet,
    required this.options,
    required this.correctAnswers,
    this.baseScore = 100, 
    this.initialDuration = const Duration(minutes: 5), 
  });

  @override
  State<DragDropQuiz> createState() => _DragDropQuizState();
}

class _DragDropQuizState extends State<DragDropQuiz> {
  // --- STATE UMUM ---
  QuizPhase _currentPhase = QuizPhase.intro;
  Map<int, String> userAnswers = {};
  bool isChecked = false;
  bool isSuccess = false;
  bool isSaving = false; 
  
  // --- STATE SCORING ---
  int _finalScore = 0;
  int _wrongAttempts = 0; 

  // --- VARIABEL TIMER ---
  Timer? _timer;
  late Duration _remainingTime;
  Duration _overtimeDuration = Duration.zero;
  late Duration _maxOvertimeLimit; 
  bool _isOvertime = false;

  // --- VARIABEL TUTORIAL ---
  late TutorialCoachMark _tutorialCoachMark;
  final GlobalKey _keyTimer = GlobalKey();
  final GlobalKey _keyCodeArea = GlobalKey();
  final GlobalKey _keyOptions = GlobalKey();
  final GlobalKey _keyButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;
    _maxOvertimeLimit = Duration(seconds: (widget.initialDuration.inSeconds / 2).floor());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- LOGIKA PERPINDAHAN FASE ---
  void _startQuiz() {
    setState(() {
      _currentPhase = QuizPhase.active;
    });
    _startTimer();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  // --- LOGIKA HITUNG SKOR ---
  void _calculateScore() {
    double currentScore = widget.baseScore.toDouble();
    int mistakePenalty = _wrongAttempts * 2;
    currentScore -= mistakePenalty;

    double timeUsedPercent = 1.0 - (_remainingTime.inSeconds / widget.initialDuration.inSeconds);
    if (_isOvertime) timeUsedPercent = 1.0; 
    
    double maxTimePenalty = widget.baseScore * 0.4; 
    double timePenalty = maxTimePenalty * timeUsedPercent;
    currentScore -= timePenalty;

    if (_isOvertime) {
      currentScore -= 2;
    }

    _finalScore = currentScore.round();
    if (_finalScore < 2) _finalScore = 2; 
  }

  // --- TUTORIAL COACH MARK ---
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('has_shown_quiz_tutorial') ?? false;

    if (!hasShown) {
      _timer?.cancel(); 
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
      onFinish: () {
        _markTutorialAsShown();
        _startTimer();
      },
      onSkip: () {
        _markTutorialAsShown();
        _startTimer();
        return true;
      },
    );
  }

  Future<void> _markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_quiz_tutorial', true);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "Timer",
        keyTarget: _keyTimer,
        alignSkip: Alignment.bottomLeft,
        shape: ShapeLightFocus.RRect,
        radius: 20, 
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => const Text("Poin berkurang jika waktu habis! ⏳", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          )
        ],
      ),
      TargetFocus(
        identify: "Kode",
        keyTarget: _keyCodeArea,
        shape: ShapeLightFocus.RRect,
        radius: 15,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => const Text("Seret jawaban ke kotak kosong di sini 🧩", style: TextStyle(color: Colors.white, fontSize: 18)),
          )
        ],
      ),
      TargetFocus(
        identify: "Opsi",
        keyTarget: _keyOptions,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => const Text("Ambil blok jawaban dari sini 👇", style: TextStyle(color: Colors.white, fontSize: 18)),
          )
        ],
      ),
    ];
  }

  // --- LOGIKA TIMER ---
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _isOvertime = true;
          _overtimeDuration += const Duration(seconds: 1);
          if (_overtimeDuration >= _maxOvertimeLimit) {
            timer.cancel(); 
            
            // [FIX AUDIO - GAME OVER]
            AudioManager().pauseBGM(); // 1. Pause BGM
            AudioManager().playGameOver(); // 2. Play SFX
            
            // 3. Resume BGM setelah 3 detik
            Future.delayed(const Duration(seconds: 5), () {
               if (mounted) AudioManager().resumeBGM();
            });

            _showTimeOutDialog(); 
          }
        }
      });
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          if (_currentPhase == QuizPhase.active)
            Container(
              key: _keyTimer, 
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: _isOvertime ? Colors.red[50] : Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _isOvertime ? Colors.red : Colors.blue),
              ),
              child: Row(
                children: [
                  Icon(_isOvertime ? Icons.warning : Icons.timer, 
                  color: _isOvertime ? Colors.red : Colors.blue, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    _isOvertime ? "+${_formatTime(_overtimeDuration)}" : _formatTime(_remainingTime),
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: _isOvertime ? Colors.red : Colors.blue,
                      fontFamily: 'monospace'
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
      body: _currentPhase == QuizPhase.intro 
          ? _buildIntroView() 
          : _buildActiveQuizView(),
    );
  }

  // --- TAMPILAN 1: INTRO ---
  Widget _buildIntroView() {
    String levelName = "Challenge";
    Color levelColor = Colors.deepPurple;
    
    if (widget.baseScore <= 15) {
      levelName = "Easy Level"; levelColor = Colors.green;
    } else if (widget.baseScore <= 20) {
      levelName = "Medium Level"; levelColor = Colors.blue;
    } else if (widget.baseScore <= 25) {
      levelName = "Hard Level"; levelColor = Colors.orange;
    } else {
      levelName = "Expert Level"; levelColor = Colors.red;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.code_rounded, size: 48, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.title, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: levelColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "$levelName (Max ${widget.baseScore} Poin)",
                      style: TextStyle(color: levelColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.instruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _startQuiz,
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                label: const Text("MULAI MENGERJAKAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- TAMPILAN 2: ACTIVE QUIZ ---
  Widget _buildActiveQuizView() {
    int blankCounter = 0; 

    return Column(
      children: [
        // KANVAS KODE (Atas)
        Expanded(
          child: Container(
            width: double.infinity,
            key: _keyCodeArea,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), 
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("// Seret jawaban ke sini", style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 12)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: widget.codeSnippet.map((part) {
                      if (part == "___") {
                        int currentId = blankCounter; 
                        blankCounter++; 

                        return DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            String? currentVal = userAnswers[currentId];
                            bool isCorrect = currentVal == widget.correctAnswers[currentId];
                            
                            Color boxColor = Colors.white.withOpacity(0.1);
                            Color borderColor = Colors.white.withOpacity(0.3);

                            if (isChecked) {
                              boxColor = isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
                              borderColor = isCorrect ? Colors.green : Colors.red;
                            } else if (currentVal != null) {
                              boxColor = Colors.blue.withOpacity(0.2);
                              borderColor = Colors.blue;
                            } else if (candidateData.isNotEmpty) {
                              boxColor = Colors.white.withOpacity(0.3);
                              borderColor = Colors.white;
                            }

                            return Container(
                              constraints: const BoxConstraints(minWidth: 70, minHeight: 35),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: boxColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: borderColor, width: 1.5)
                              ),
                              child: Text(
                                currentVal ?? "___",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: currentVal != null ? Colors.white : Colors.white24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace'
                                ),
                              ),
                            );
                          },
                          // Audio dihapus di sini, karena akan dipanggil saat tombol Cek diklik
                          onAccept: (data) {
                            if (!isChecked) {
                              setState(() {
                                userAnswers[currentId] = data;
                              });
                            }
                          },
                        );
                      } else {
                        return Text(
                          part,
                          style: TextStyle(
                            color: part.contains("//") ? Colors.greenAccent : Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 16,
                            height: 1.5
                          ),
                        );
                      }
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // OPSI & TOMBOL (Bawah)
        Container(
          key: _keyOptions,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSuccess) ...[
                const Text("PILIHAN JAWABAN:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.options.map((option) {
                      bool isUsed = userAnswers.containsValue(option);
                      return Draggable<String>(
                        data: option,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Transform.scale(
                            scale: 1.1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple, 
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)]
                              ),
                              child: Text(option, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _buildOptionBox(option, isUsed: true),
                        ),
                        child: _buildOptionBox(option, isUsed: isUsed),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Tombol
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  key: _keyButton,
                  onPressed: _handleCheckAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess ? Colors.green : Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0
                  ),
                  child: Text(
                    isSuccess ? "BERHASIL LANJUT!" : "JALANKAN KODE", 
                    style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleCheckAnswer() {
    if (userAnswers.length < widget.correctAnswers.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua kotak kosong dulu!"), behavior: SnackBarBehavior.floating, margin: EdgeInsets.all(20))
      );
      return;
    }

    bool allCorrect = true;
    widget.correctAnswers.forEach((key, value) {
      if (userAnswers[key] != value) allCorrect = false;
    });

    setState(() {
      isChecked = true;
      isSuccess = allCorrect;
    });

    if (allCorrect) {
      _timer?.cancel();
      _calculateScore();
      
      // [FIX AUDIO - CORRECT]
      AudioManager().pauseBGM(); // 1. Pause
      AudioManager().playLatihanCorrect(); // 2. Play SFX
      
      // 3. Resume BGM setelah 2 detik
      Future.delayed(const Duration(seconds: 7), () {
        if (mounted) AudioManager().resumeBGM();
      });

      _showSuccessDialog();
    } else {
      setState(() {
        _wrongAttempts++; 
      });
      
      // [FIX AUDIO - WRONG]
      AudioManager().pauseBGM(); // 1. Pause
      AudioManager().playWrong(); // 2. Play SFX
      
      // 3. Resume BGM setelah 1 detik
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) AudioManager().resumeBGM();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent, 
          content: Row(children: [Icon(Icons.error, color: Colors.white), SizedBox(width: 10), Text("Masih ada yang salah, perbaiki lagi!")]),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          duration: Duration(milliseconds: 1500),
        )
      );
      
      Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() { isChecked = false; });
      });
    }
  }

  Widget _buildOptionBox(String text, {bool isUsed = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isUsed ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isUsed ? Colors.grey : Colors.deepPurple.withOpacity(0.5)),
        boxShadow: isUsed ? [] : [BoxShadow(color: Colors.deepPurple.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
      ),
      child: Text(
        text, 
        style: TextStyle(
          color: isUsed ? Colors.grey : Colors.deepPurple, 
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace'
        )
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Misi Selesai! 🎉", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 80),
            const SizedBox(height: 10),
            Text("+$_finalScore Poin", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 5),
            Text("(Maks: ${widget.baseScore})", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  _ScoreDetailRow(label: "Sisa Waktu", value: _formatTime(_remainingTime)),
                  _ScoreDetailRow(label: "Salah Cek (-2/x)", value: "$_wrongAttempts x", isPenalty: true),
                  if (_isOvertime)
                     _ScoreDetailRow(label: "Overtime (-2)", value: "Ya", isPenalty: true),
                ],
              ),
            )
          ],
        ),
        actions: [
          // TOMBOL SIMPAN & LANJUT
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                await ProgressManager.addScore(_finalScore);
                
                // Pastikan BGM menyala saat keluar
                AudioManager().resumeBGM();
                
                if (context.mounted) {
                  Navigator.pop(ctx);
                  Navigator.pop(context, _finalScore); 
                }
              },
              child: const Text("SIMPAN & LANJUT", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  void _showTimeOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.red),
            SizedBox(width: 10),
            Text("Waktu Habis!", style: TextStyle(color: Colors.red)),
          ],
        ),
        content: const Text("Waktu Overtime telah habis. Skor kamu 0. Silakan coba lagi."),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Pastikan BGM menyala saat keluar
              AudioManager().resumeBGM();
              
              Navigator.pop(ctx); 
              Navigator.pop(context, 0); 
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Kembali ke Menu", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class _ScoreDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPenalty;
  const _ScoreDetailRow({required this.label, required this.value, this.isPenalty = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isPenalty ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}