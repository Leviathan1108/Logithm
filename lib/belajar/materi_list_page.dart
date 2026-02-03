import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/progress_manager.dart'; // Pastikan path ini benar

// Import Semua Materi 1-20 (TIDAK DIUBAH)
import 'materi/materi1.dart';
import 'materi/materi2.dart';
import 'materi/materi3.dart';
import 'materi/materi4.dart';
import 'materi/materi5.dart';
import 'materi/materi6.dart';
import 'materi/materi7.dart';
import 'materi/materi8.dart';
import 'materi/materi9.dart';
import 'materi/materi10.dart';
import 'materi/materi11.dart';
import 'materi/materi12.dart';
import 'materi/materi13.dart';
import 'materi/materi14.dart';
import 'materi/materi15.dart';
import 'materi/materi16.dart';
import 'materi/materi17.dart';
import 'materi/materi18.dart';
import 'materi/materi19.dart';
import 'materi/materi20.dart';

class MateriListPage extends StatefulWidget {
  const MateriListPage({super.key});

  @override
  State<MateriListPage> createState() => _MateriListPageState();
}

class _MateriListPageState extends State<MateriListPage> {
  // Fungsi buka materi
  void _openMateri(Widget materiPage) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => materiPage),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (result['completed'] == true) {
        if (mounted) {
          _showSummaryDialog(
            result['materiScore'] ?? 0,
            result['latihanScore'] ?? 0,
            result['totalAccountScore'] ?? 0,
          );
          setState(() {}); 
        }
      }
    }
  }

  // Fungsi Pop-up
  void _showSummaryDialog(int materiScore, int latihanScore, int totalScore) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🎉 LEVELESAI! 🎉", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 5),
              const Text("Modul ini telah tuntas.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildPointRow("📖 Baca Materi", "+$materiScore"),
                    const Divider(),
                    _buildPointRow("📝 Latihan Soal", "+$latihanScore"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("TOTAL SKOR KAMU", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.grey)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars_rounded, color: Colors.orange, size: 40),
                  const SizedBox(width: 10),
                  Text("$totalScore", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Mantap! Lanjut Belajar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointRow(String label, String point) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        Text(point, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<MateriLevel> levels = [
      // FASE 1: Dasar (Langit Biru - Cerah)
      MateriLevel(1, "Pengenalan Algoritma", Colors.cyan, const Materi1(), "Langkah penyelesaian masalah."),
      MateriLevel(2, "Input, Proses, Output", Colors.cyan, const Materi2(), "Pola pikir komputer."),
      MateriLevel(3, "Sekuensial", Colors.cyan, const Materi3(), "Urutan itu vital."),
      MateriLevel(4, "Logika If", Colors.cyan, const Materi4(), "Mengambil keputusan."),
      MateriLevel(5, "Percabangan Dua Arah", Colors.cyan, const Materi5(), "Pilihan A atau B."),
      
      // FASE 2: Logika (Sore - Ungu Tenang)
      MateriLevel(6, "Operator Pembanding", Colors.indigo, const Materi6(), "Lebih besar atau kecil?"),
      MateriLevel(7, "Percabangan Majemuk", Colors.indigo, const Materi7(), "Banyak pilihan (Else-If)."),
      MateriLevel(8, "Logika AND", Colors.indigo, const Materi8(), "Semua harus benar."),
      MateriLevel(9, "Logika OR", Colors.indigo, const Materi9(), "Salah satu benar cukup."),
      MateriLevel(10, "Nested If", Colors.indigo, const Materi10(), "Pertanyaan dalam pertanyaan."),

      // FASE 3: Looping (Senja - Oranye)
      MateriLevel(11, "Switch Case", Colors.orange, const Materi11(), "Menu pilihan langsung."),
      MateriLevel(12, "Pengenalan Loop", Colors.orange, const Materi12(), "Melakukan hal berulang."),
      MateriLevel(13, "For Loop", Colors.orange, const Materi13(), "Loop jumlah pasti."),
      MateriLevel(14, "While Loop", Colors.orange, const Materi14(), "Cek dulu baru jalan."),
      MateriLevel(15, "Do-While Loop", Colors.orange, const Materi15(), "Jalan dulu baru cek."),

      // FASE 4: Advanced (Malam - Gelap)
      MateriLevel(16, "Variabel Counter", Colors.deepPurple, const Materi16(), "Hitung jumlah putaran."),
      MateriLevel(17, "Variabel Accumulator", Colors.deepPurple, const Materi17(), "Total hasil."),
      MateriLevel(18, "Infinite Loop", Colors.deepPurple, const Materi18(), "Loop tanpa henti."),
      MateriLevel(19, "Break & Continue", Colors.deepPurple, const Materi19(), "Kontrol paksa loop."),
      MateriLevel(20, "Loop dengan If", Colors.redAccent, const Materi20(), "Filter data dalam loop."),
    ];

    return Scaffold(
      // [PERBAIKAN] Background tetap di belakang AppBar
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text("Peta Perjalanan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // AppBar Transparan agar menyatu dengan background
        backgroundColor: Colors.transparent, 
        foregroundColor: Colors.black87, // Warna ikon/teks gelap agar terbaca di area terang
        elevation: 0,
        // Background blur di belakang teks appbar agar tetap terbaca saat scroll
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.0)],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<Set<int>>(
        valueListenable: ProgressManager.completedMateri,
        builder: (context, completedIds, _) {
          
          final double nodeHeight = 140.0;
          // [PERBAIKAN] Tambahkan padding atas yang cukup besar (misal 120) pada total tinggi
          final double topPadding = 120.0; 
          final double totalScrollHeight = (levels.length * nodeHeight) + topPadding + 100;

          return Container(
            // [PERBAIKAN] Layer 1: Background Gradient yang lebih soft dan tidak "norak"
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0F7FA), // Biru Langit Sangat Muda (Start)
                  Color(0xFF80DEEA), // Cyan Lembut
                  Color(0xFF9FA8DA), // Ungu Kebiruan (Transisi)
                  Color(0xFFFFCC80), // Oranye Senja Lembut
                  Color(0xFF4527A0), // Ungu Malam (End)
                ],
                // Stops agar gradasi lebih merata
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: totalScrollHeight, 
                child: Stack(
                  children: [
                    // [PERBAIKAN] Layer 2: Jalur (Path)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SmoothPathPainter(
                          itemCount: levels.length, 
                          completedCount: completedIds.length,
                          pathColor: Colors.white.withOpacity(0.4), // Jalur lebih transparan
                          topPadding: topPadding, // Kirim padding ke painter
                          nodeHeight: nodeHeight,
                        ),
                      ),
                    ),

                    // [PERBAIKAN] Layer 3: Node Level
                    // Tidak pakai Padding widget di sini, tapi atur posisi 'top' secara manual
                    ...List.generate(levels.length, (index) {
                        final level = levels[index];
                        
                        double screenWidth = MediaQuery.of(context).size.width;
                        // Amplitudo sinus (lebar liukan)
                        double xOffset = (screenWidth / 2 - 40) + (math.sin(index * 0.55) * 100); 
                        // Posisi Y + Padding Atas agar tidak tertimpa AppBar
                        double yOffset = (index * nodeHeight) + topPadding;
                  
                        bool isUnlocked = (level.id == 1) || completedIds.contains(level.id - 1);
                        bool isCompleted = completedIds.contains(level.id);
                        bool isCurrent = isUnlocked && !isCompleted;
                  
                        return Positioned(
                          left: xOffset,
                          top: yOffset,
                          child: ModernLevelNode(
                            level: level,
                            isUnlocked: isUnlocked,
                            isCompleted: isCompleted,
                            isCurrent: isCurrent,
                            onTap: () {
                              if (isUnlocked) {
                                _showModernLevelInfo(context, level, isCompleted);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("🔒 Selesaikan Level ${level.id - 1} dulu!"),
                                    backgroundColor: Colors.black87,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showModernLevelInfo(BuildContext context, MateriLevel level, bool isCompleted) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: level.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(level.color == Colors.cyan ? Icons.code : Icons.auto_awesome, color: level.color, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("LEVEL ${level.id}", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(level.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 30),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(level.desc, style: TextStyle(color: Colors.grey[700], height: 1.5)),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _openMateri(level.page);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.blueAccent : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                isCompleted ? "ULANGI MATERI" : "MULAI BELAJAR",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// WIDGET HELPER
// ==================================================

class MateriLevel {
  final int id;
  final String title;
  final Color color;
  final Widget page;
  final String desc;

  MateriLevel(this.id, this.title, this.color, this.page, this.desc);
}

class ModernLevelNode extends StatelessWidget {
  final MateriLevel level;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback onTap;

  const ModernLevelNode({
    super.key, 
    required this.level, 
    required this.isUnlocked, 
    required this.isCompleted, 
    required this.isCurrent,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.white.withOpacity(0.6);
    List<BoxShadow> shadows = [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))];
    
    if (isCompleted) {
      bgColor = Colors.green;
      borderColor = Colors.white;
      shadows = [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))];
    } else if (isCurrent) {
      bgColor = Colors.white;
      borderColor = level.color;
      shadows = [BoxShadow(color: level.color.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 0))];
    } else if (isUnlocked) {
      bgColor = Colors.grey[100]!;
      borderColor = Colors.grey[300]!;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.all(color: borderColor, width: isCurrent ? 4 : 2),
              boxShadow: shadows,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.star, color: Colors.white, size: 40)
                  : !isUnlocked
                      ? Icon(Icons.lock, color: Colors.grey[400], size: 30)
                      : Text(
                          "${level.id}", 
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isCurrent ? level.color : Colors.grey[600]),
                        ),
            ),
          ),
          const SizedBox(height: 8),
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                level.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.8)),
              ),
            ),
        ],
      ),
    );
  }
}

// [PERBAIKAN] Painter Menggunakan Cubic Bezier untuk lengkungan halus
class SmoothPathPainter extends CustomPainter {
  final int itemCount;
  final int completedCount;
  final Color pathColor;
  final double topPadding;
  final double nodeHeight;
  
  SmoothPathPainter({
    required this.itemCount, 
    required this.completedCount, 
    required this.pathColor,
    required this.topPadding,
    required this.nodeHeight
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    
    double centerX = size.width / 2;
    Path path = Path();
    
    // Titik awal (Pusat node pertama)
    // Ingat offset X node pertama adalah: (centerX - 40) + sin(0)*100.
    // Pusat node sebenarnya = offset X + 40 (setengah lebar node).
    // Jadi visual center = centerX + sin(0)*100.
    
    double startX = centerX + (math.sin(0 * 0.55) * 100);
    double startY = topPadding + 40; // +40 adalah setengah tinggi node (80/2)

    path.moveTo(startX, startY);

    for (int i = 0; i < itemCount - 1; i++) {
      // Titik Awal Kurva (Pusat Node i)
      double currentX = centerX + (math.sin(i * 0.55) * 100);
      double currentY = (i * nodeHeight) + topPadding + 40;

      // Titik Akhir Kurva (Pusat Node i+1)
      double nextX = centerX + (math.sin((i + 1) * 0.55) * 100);
      double nextY = ((i + 1) * nodeHeight) + topPadding + 40;

      // Kontrol Point untuk Cubic Bezier (Membuat efek S yang halus)
      // Control 1: Di bawah titik awal (vertikal)
      double cp1X = currentX; 
      double cp1Y = currentY + (nodeHeight / 2);

      // Control 2: Di atas titik akhir (vertikal)
      double cp2X = nextX;
      double cp2Y = nextY - (nodeHeight / 2);

      // Gambar kurva halus
      path.cubicTo(cp1X, cp1Y, cp2X, cp2Y, nextX, nextY);
    }
    
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}