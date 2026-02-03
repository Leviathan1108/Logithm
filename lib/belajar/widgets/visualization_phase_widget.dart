import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Sesuaikan import ini dengan struktur project Anda
import '../../../core/app_export.dart'; 

class VisualizationPhaseWidget extends StatefulWidget {
  final String title;
  final String visualizationType;
  final String description;

  const VisualizationPhaseWidget({
    super.key,
    required this.title,
    required this.visualizationType,
    required this.description,
  });

  @override
  State<VisualizationPhaseWidget> createState() => _VisualizationPhaseWidgetState();
}

class _VisualizationPhaseWidgetState extends State<VisualizationPhaseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // State Interaksi
  int _activeStep = 0; 
  List<String> _codeSteps = []; 
  Timer? _autoPlayTimer;
  bool _isAutoPlaying = true;
  
  // Durasi per langkah (Default)
  final Duration _stepDuration = const Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _stepDuration, 
      vsync: this,
    );

    _initSteps(); // Inisialisasi Data Teks Langkah
    _startAutoPlay(); // Mulai Animasi
  }

  // --- LOGIKA INISIALISASI DATA LANGKAH ---
  void _initSteps() {
    String t = widget.title.toLowerCase(); 

    // 1. Alur Logika (Pengenalan Algoritma) -> Mesin Kopi
    if (t.contains("alur logika")) {
      _codeSteps = [
        "1. MULAI: Nyalakan Mesin",
        "2. INPUT: Masukkan Air & Kopi",
        "3. PROSES: Mesin Menyeduh",
        "4. OUTPUT: Kopi Mengisi Gelas",
        "5. SELESAI: Kopi Siap!"
      ];
    }
    // 2. Kotak Hitam (Input Proses Output) -> Blender
    else if (t.contains("kotak hitam")) {
      _codeSteps = [
        "1. MULAI: Siapkan Blender",
        "2. INPUT: Masukkan Jeruk",
        "3. PROSES: Blender Berputar",
        "4. OUTPUT: Tuang Jus",
        "5. SELESAI: Jus Segar!"
      ];
    }
    // 3. Garis Lurus (Sekuensial) -> Pakai Sepatu
    else if (t.contains("garis lurus")) {
      _codeSteps = [
        "1. MULAI: Siapkan Kaki",
        "2. LANGKAH A: Pasang Kaus Kaki",
        "3. LANGKAH B: Pasang Sepatu",
        "4. SELESAI: Siap Berjalan"
      ];
    }
    // 4. Cabang Satu (If Tunggal) -> Pintu Otomatis
    else if (t.contains("cabang satu")) {
      _codeSteps = [
        "1. MULAI: Orang Berjalan",
        "2. IF (Ada Orang): Cek Sensor",
        "3. THEN: Buka Pintu Otomatis",
        "4. SELESAI: Masuk Ruangan"
      ];
    }
    // 5. Cabang Dua (If-Else) -> Persimpangan Jalan
    else if (t.contains("cabang dua")) {
      _codeSteps = [
        "1. MULAI: Kendaraan Datang",
        "2. CEK: Apakah Nilai > 70?",
        "3. IF TRUE (Lulus): Ke Jalur Hijau",
        "4. ELSE (Gagal): Ke Jalur Merah"
      ];
    }
    // 6. Timbangan (Operator Pembanding) -> Ukur Tinggi
    else if (t.contains("timbangan")) {
      _codeSteps = [
        "1. MULAI: Siapkan Alat Ukur",
        "2. KASUS A (>): Lebih Berat? (TRUE)",
        "3. KASUS B (<): Lebih Ringan? (TRUE)",
        "4. KASUS C (==): Sama Berat? (TRUE)"
      ];
    }
    // 7. Tangga Keputusan (Else-If) -> Sortir Baju
    else if (t.contains("tangga keputusan")) {
      _codeSteps = [
        "1. MULAI: Baju (Size M) Datang",
        "2. IF (Size == S)? -> FALSE (Turun Tangga)",
        "3. ELSE IF (Size == M)? -> TRUE! (Ambil)",
        "4. AKSI: Masukkan ke Keranjang M"
      ];
    }
    // 8. Gerbang Seri (AND) -> Brankas 2 Kunci
    else if (t.contains("gerbang seri")) {
      _codeSteps = [
        "1. MULAI: Brankas Terkunci",
        "2. SYARAT 1: Kunci A Diputar (TRUE)",
        "3. SYARAT 2: Kunci B Diputar (TRUE)",
        "4. HASIL: Keduanya TRUE -> BUKA"
      ];
    }
    // 9. Gerbang Paralel (OR) -> 2 Pintu Masuk
    else if (t.contains("gerbang paralel")) {
      _codeSteps = [
        "1. MULAI: Dua Pintu Gerbang",
        "2. OPSI A: Lewat Kiri (TRUE) -> MASUK",
        "3. OPSI B: Lewat Kanan (TRUE) -> MASUK",
        "4. HASIL: Salah Satu Terbuka -> SUKSES"
      ];
    }
    // 10. Pohon Keputusan (Nested If) -> Keamanan Bandara
    else if (t.contains("pohon keputusan")) {
      _codeSteps = [
        "1. MULAI: Cek Tiket (Cabang Utama)",
        "2. IF (Tiket OK)? -> Lanjut ke Cabang Dalam",
        "3. CEK: Bawa Senjata? (Cabang Dalam)",
        "4. HASIL: Tidak Bawa -> LOLOS!"
      ];
    }
    // 11. Titik Distribusi (Switch Case) -> Vending Machine
    else if (t.contains("titik distribusi")) {
      _codeSteps = [
        "1. INPUT: Tekan Tombol 'A'",
        "2. CASE 'A': Cocok! Jalur Cola",
        "3. CASE 'B': Lewati Jalur Lain",
        "4. BREAK: Keluar & Berikan Minuman"
      ];
    }
    // 12. Lingkaran (Loop Intro) -> Lari Lapangan
    else if (t.contains("lingkaran")) {
      _codeSteps = [
        "1. MULAI: Siap di Garis Start",
        "2. AKSI: Lari Satu Putaran Penuh",
        "3. HITUNG: Catat Putaran (n+1)",
        "4. ULANGI: Kembali ke Start & Lari Lagi"
      ];
    }
    // 13. Counter (For Loop) -> Lari Target 3x
    else if (t.contains("counter")) { 
      _codeSteps = [
        "1. INIT: Set Hitungan = 1, Target = 3",
        "2. LOOP 1: Cek (1 <= 3) ✅ -> Jalan",
        "3. LOOP 2: Cek (2 <= 3) ✅ -> Jalan",
        "4. SELESAI: Cek (4 <= 3) ❌ -> Stop"
      ];
    }
    // 14. Siklus Cek Awal (While Loop) -> Isi Bensin
    else if (t.contains("siklus cek awal")) {
      _codeSteps = [
        "1. CEK DULU: Tangki Belum Penuh? (YA)",
        "2. LOOP: Isi Bensin... (Level Naik)",
        "3. LOOP: Isi Bensin... (Level Naik)",
        "4. CEK LAGI: Sudah Penuh? -> STOP"
      ];
    }
    // 15. Siklus Cek Akhir (Do-While) -> Masak Sup
    else if (t.contains("siklus cek akhir")) {
      _codeSteps = [
        "1. LAKUKAN (Awal): Tambah Garam & Aduk",
        "2. CEK: Kurang Asin? (YA) -> Ulangi",
        "3. LAKUKAN (Ulang): Tambah Garam & Aduk",
        "4. CEK: Pas? (YA) -> Selesai"
      ];
    }
    // 16. Tangga Naik (Basic Counter/Increment) -> Papan Tulis
    else if (t.contains("tangga naik")) {
      _codeSteps = [
        "1. INIT: Posisi = 0 (Lantai Dasar)",
        "2. STEP 1: Naik 1 Tangga (Posisi=1)",
        "3. STEP 2: Naik 1 Tangga (Posisi=2)",
        "4. STEP 3: Naik 1 Tangga (Posisi=3)"
      ];
    }
    // 17. Bola Salju (Accumulator) -> Mesin Kasir
    else if (t.contains("bola salju")) {
      _codeSteps = [
        "1. INIT: Bola Salju Kecil (Total=0)",
        "2. GULING 1: Tambah Salju (+1000)",
        "3. GULING 2: Tambah Salju (+2000)",
        "4. HASIL: Bola Menjadi Besar (Total=3000)"
      ];
    }
    // 18. Roda Hamster (Infinite Loop) -> Roda Hamster
    else if (t.contains("roda hamster")) {
      _codeSteps = [
        "1. CEK: (1 < 2)? -> SELALU BENAR",
        "2. AKSI: Lari Putaran 1...",
        "3. ULANG: Cek lagi? Masih BENAR -> Lari...",
        "4. ERROR: Tidak bisa berhenti! (CRASH)"
      ];
    }
    // 19. Pintu Keluar (Break) -> Cari Kunci
    else if (t.contains("pintu keluar")) {
      _codeSteps = [
        "1. LOOP 1: Cek Kamar 1... (KOSONG)",
        "2. LOOP 2: Cek Kamar 2... (KOSONG)",
        "3. LOOP 3: Cek Kamar 3... (ADA KUNCI!)",
        "4. KELUAR (BREAK): Stop Pencarian!"
      ];
    }
    // 20. Saringan (Loop + If / Filter) -> Sortir Sampah
    else if (t.contains("saringan")) {
      _codeSteps = [
        "1. LOOP: Ambil Item Berikutnya",
        "2. SARING 1 (Botol): Lolos Saringan? YA",
        "3. SARING 2 (Daun): Lolos Saringan? TIDAK",
        "4. SARING 3 (Kaleng): Lolos Saringan? YA"
      ];
    }
    // Fallback
    else {
      _codeSteps = ["Langkah 1", "Langkah 2", "Langkah 3"];
    }

    if (_codeSteps.isEmpty) _codeSteps = ["Error Data"];
  }

  // --- PEMILIHAN PAINTER ---
  CustomPainter _getPainter(ThemeData theme) {
    final progress = _animationController.value;
    String t = widget.title.toLowerCase();

    // Mapping Judul ke Painter
    if (t.contains("alur logika")) return CoffeeMachinePainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("kotak hitam")) return JuiceBlenderPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("garis lurus")) return WearingShoesPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("cabang satu")) return AutomaticDoorPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("cabang dua")) return IfElseRoadPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("timbangan")) return HeightMeasurementPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("tangga keputusan")) return ElseIfSortingPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("gerbang seri")) return LogicAndVaultPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("gerbang paralel")) return LogicOrGatePainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("pohon keputusan")) return NestedCheckPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("titik distribusi")) return SwitchCasePainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("lingkaran")) return LoopIntroPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("counter")) return ForLoopPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("siklus cek awal")) return WhileFuelPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("siklus cek akhir")) return DoWhileCookingPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("tangga naik")) return CounterTallyPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("bola salju")) return AccumulatorCashierPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("roda hamster")) return InfiniteLoopPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("pintu keluar")) return BreakSearchPainter(progress: progress, activeStep: _activeStep, theme: theme);
    if (t.contains("saringan")) return LoopIfFilterPainter(progress: progress, activeStep: _activeStep, theme: theme);

    return DefaultVisualizationPainter(progress: progress, theme: theme);
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _runStepAnimation(); 

    _autoPlayTimer = Timer.periodic(_stepDuration, (timer) {
      if (!mounted) return;
      setState(() {
        if (_codeSteps.isNotEmpty) {
           _activeStep = (_activeStep + 1) % _codeSteps.length;
           _runStepAnimation(); 
        }
      });
    });
  }

  void _runStepAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _onStepTapped(int index) {
    setState(() {
      _isAutoPlaying = false; 
      _autoPlayTimer?.cancel();
      _activeStep = index;
      _runStepAnimation();
    });
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
      if (_isAutoPlaying) {
        _startAutoPlay();
      } else {
        _autoPlayTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // AREA VISUALISASI (CANVAS)
        Expanded(
          flex: 6, 
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFFF5F5F5),
                // Gunakan SizedBox.expand agar CustomPaint tidak berukuran 0
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SizedBox.expand(
                      child: CustomPaint(
                        painter: _getPainter(theme),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10, right: 10,
                child: FloatingActionButton.small(
                  onPressed: _toggleAutoPlay,
                  backgroundColor: Colors.white,
                  child: Icon(_isAutoPlaying ? Icons.pause : Icons.play_arrow, color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),

        // AREA LANGKAH (TEXT)
        Expanded(
          flex: 4, 
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.code, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text("LANGKAH LOGIKA:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Expanded(
                  child: _codeSteps.isEmpty 
                    ? const Center(child: Text("Memuat data...")) 
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _codeSteps.length,
                        separatorBuilder: (c, i) => const Divider(height: 1, indent: 16, endIndent: 16),
                        itemBuilder: (context, index) {
                          final isActive = index == _activeStep;
                          // Safe parsing
                          String stepTxt = _codeSteps[index];
                          String displayTxt = stepTxt.contains(": ") ? stepTxt.split(": ")[1] : stepTxt;

                          return InkWell(
                            onTap: () => _onStepTapped(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              color: isActive ? theme.colorScheme.primaryContainer.withOpacity(0.3) : Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24, height: 24, alignment: Alignment.center,
                                    decoration: BoxDecoration(color: isActive ? theme.colorScheme.primary : Colors.grey[300], shape: BoxShape.circle),
                                    child: Text("${index + 1}", style: TextStyle(color: isActive ? Colors.white : Colors.grey[600], fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(displayTxt, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? theme.colorScheme.primary : Colors.black87)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// DAFTAR CLASS PAINTER (PASTIKAN SEMUA PAINTER DI BAWAH INI ADA DI FILE ANDA)
// =============================================================================

// Helper Bubble
void _drawBubble(Canvas c, Size s, String t, Color col) {
  final tp = TextPainter(text: TextSpan(text: t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
  final rect = Rect.fromCenter(center: Offset(s.width * 0.5, s.height * 0.15), width: tp.width + 30, height: tp.height + 20);
  c.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)), Paint()..color = col);
  tp.paint(c, Offset(rect.center.dx - tp.width/2, rect.center.dy - tp.height/2));
}

// Default
class DefaultVisualizationPainter extends CustomPainter {
  final double progress; final ThemeData theme;
  DefaultVisualizationPainter({required this.progress, required this.theme});
  @override void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width/2, size.height/2), 50, Paint()..color = Colors.grey[300]!);
    _drawBubble(canvas, size, "Visualisasi Default", Colors.grey);
  }
  @override bool shouldRepaint(covariant CustomPainter old) => true;
}

// =============================================================================
// =============================================================================
// PAINTER 1: MESIN KOPI (MATERI 1)
// =============================================================================
class CoffeeMachinePainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  CoffeeMachinePainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;

    // WARNA-WARNA
    final machineBodyColor = Colors.grey[850]!; // Badan mesin gelap
    final machineMetalColor = Colors.grey[400]!; // Logam/Group head
    final coffeeGroundsColor = const Color(0xFF4E342E); // Bubuk kopi
    final espressoColor = const Color(0xFF3E2723); // Air kopi matang
    final handleColor = Colors.black; // Gagang porta
    final glassColor = Colors.blue[50]!.withOpacity(0.5); // Gelas bening

    // --- 1. GAMBAR MESIN ESPRESSO (Static Background) ---
    // Badan Mesin
    final bodyRect = Rect.fromCenter(center: Offset(cx, cy - 20), width: 160, height: 200);
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(15)), Paint()..color = machineBodyColor);
    
    // Panel Atas (Logam)
    canvas.drawRect(Rect.fromLTWH(cx - 80, cy - 120, 160, 40), Paint()..color = machineMetalColor);
    
    // Group Head (Tempat pasang porta) - Menonjol di tengah atas
    final groupHeadRect = Rect.fromCenter(center: Offset(cx, cy - 50), width: 60, height: 30);
    canvas.drawRect(groupHeadRect, Paint()..color = machineMetalColor);
    // Baut group head
    canvas.drawCircle(Offset(cx - 20, cy - 50), 4, Paint()..color = Colors.grey[600]!);
    canvas.drawCircle(Offset(cx + 20, cy - 50), 4, Paint()..color = Colors.grey[600]!);

    // Tombol Start (Akan menyala di step 3)
    Color btnColor = Colors.red[900]!; // Mati
    bool isMachineOn = (activeStep >= 2); // Nyala di step 3 & 4
    if (isMachineOn) btnColor = Colors.greenAccent; // Nyala
    
    // Gambar Tombol
    canvas.drawCircle(Offset(cx + 60, cy - 100), 8, Paint()..color = Colors.black); // Housing tombol
    canvas.drawCircle(Offset(cx + 60, cy - 100), 5, Paint()..color = btnColor); // Lampu


    // --- 2. LOGIKA ANIMASI PER STEP ---
    String statusText = "";

    // Variabel Posisi Portafilter
    double portaX = cx;
    double portaY = cy - 35; // Posisi terpasang (default)
    double portaRotation = 0.0;
    bool showPorta = true;
    bool showGlass = false;
    bool pourCoffee = false;

    if (activeStep == 0) {
      statusText = "1. Input: Isi Bubuk Kopi";
      // Porta ada di bawah (belum terpasang)
      portaX = cx - 40;
      portaY = cy + 40;
      showGlass = false;
      
      // Animasi bubuk kopi jatuh ke porta
      _drawPortafilter(canvas, Offset(portaX, portaY), handleColor, machineMetalColor);
      
      // Bubuk jatuh
      if (progress < 0.8) {
        double dropY = (cy - 20) + (progress * 60);
        canvas.drawCircle(Offset(portaX, dropY), 5, Paint()..color = coffeeGroundsColor);
      } else {
        // Tumpukan bubuk di porta
        canvas.drawArc(Rect.fromCenter(center: Offset(portaX, portaY - 5), width: 30, height: 10), 3.14, 3.14, true, Paint()..color = coffeeGroundsColor);
      }

    } 
    else if (activeStep == 1) {
      statusText = "2. Proses: Pasang Porta";
      showGlass = false;
      
      // Animasi Gerakan Porta dari Bawah ke Group Head
      // Start: (cx - 40, cy + 40) -> End: (cx, cy - 35)
      double t = progress; // 0.0 -> 1.0
      portaX = (cx - 40) + (40 * t); // Geser ke kanan
      portaY = (cy + 40) - (75 * t); // Geser ke atas
      
      _drawPortafilter(canvas, Offset(portaX, portaY), handleColor, machineMetalColor, hasCoffee: true);
    } 
    else if (activeStep == 2) {
      statusText = "3. Proses: Pasang Gelas & Start";
      // Porta sudah terpasang diam
      portaX = cx;
      portaY = cy - 35;
      _drawPortafilter(canvas, Offset(portaX, portaY), handleColor, machineMetalColor, hasCoffee: true);

      // Animasi Gelas Masuk dari kiri
      double glassX = (cx - 100) + (progress * 100); 
      if (glassX > cx) glassX = cx; // Stop di tengah
      
      _drawGlass(canvas, Offset(glassX, cy + 60), glassColor, 0.0, espressoColor);
      
      // Efek Getar Mesin (Tanda nyala)
      if (progress > 0.5) {
        // Gambar ulang body sedikit geser biar kelihatan getar
        // (Opsional, di sini kita andalkan lampu hijau saja)
      }
    } 
    else if (activeStep == 3) {
      statusText = "4. Output: Ekstrak Espresso";
      // Porta Terpasang
      _drawPortafilter(canvas, Offset(cx, cy - 35), handleColor, machineMetalColor, hasCoffee: true);
      
      // Gelas di tempat
      double fillLevel = progress; // 0.0 -> 1.0
      _drawGlass(canvas, Offset(cx, cy + 60), glassColor, fillLevel, espressoColor);

      // Aliran Kopi (Stream)
      // Stream berhenti jika sudah penuh (progress > 0.95)
      if (progress < 0.98) {
        Paint streamPaint = Paint()..color = espressoColor..strokeWidth = 4;
        canvas.drawLine(Offset(cx, cy - 25), Offset(cx, cy + 60 - (30 * fillLevel)), streamPaint);
      }
    } 
    else {
      // SELESAI
      statusText = "Selesai: Nikmati Kopi!";
      _drawPortafilter(canvas, Offset(cx, cy - 35), handleColor, machineMetalColor, hasCoffee: true);
      _drawGlass(canvas, Offset(cx, cy + 60), glassColor, 1.0, espressoColor);
      
      // Asap panas (Opsional)
      double smokeY = cy + 20 - (progress * 10);
      Paint smokePaint = Paint()..color = Colors.white.withOpacity(0.3 - (progress * 0.3))..style = PaintingStyle.stroke..strokeWidth = 2;
      canvas.drawPath(Path()..moveTo(cx - 5, smokeY)..quadraticBezierTo(cx, smokeY - 10, cx + 5, smokeY - 20), smokePaint);
    }

    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER METHODS ---

  void _drawPortafilter(Canvas canvas, Offset center, Color handleColor, Color metalColor, {bool hasCoffee = false}) {
    // Gagang (Handle) - Miring ke kiri
    final handlePath = Path();
    handlePath.moveTo(center.dx - 20, center.dy);
    handlePath.lineTo(center.dx - 80, center.dy + 10); // Ujung gagang lebih rendah
    handlePath.lineTo(center.dx - 80, center.dy - 5);
    handlePath.lineTo(center.dx - 20, center.dy - 10);
    handlePath.close();
    canvas.drawPath(handlePath, Paint()..color = handleColor);

    // Wadah (Basket)
    canvas.drawArc(Rect.fromCenter(center: center, width: 40, height: 30), 0, 3.14, true, Paint()..color = metalColor);
    canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy-5), width: 40, height: 10), Paint()..color = metalColor);
    
    // Corong Kecil di bawah basket
    canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy + 15), width: 6, height: 8), Paint()..color = metalColor);

    if (hasCoffee) {
      // Sedikit warna gelap di atas menandakan ada isinya
      canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy - 5), width: 36, height: 4), Paint()..color = const Color(0xFF4E342E));
    }
  }

  void _drawGlass(Canvas canvas, Offset bottomCenter, Color glassColor, double fillPercent, Color liquidColor) {
    double w = 40;
    double h = 50;
    Rect glassRect = Rect.fromCenter(center: Offset(bottomCenter.dx, bottomCenter.dy - (h/2)), width: w, height: h);
    
    // Gambar Isi Kopi
    if (fillPercent > 0) {
      double liquidH = h * fillPercent;
      Rect liquidRect = Rect.fromLTWH(glassRect.left, glassRect.bottom - liquidH, w, liquidH);
      canvas.drawRect(liquidRect, Paint()..color = liquidColor);
    }

    // Gambar Gelas (Outline & Isi transparan)
    Paint glassPaint = Paint()..color = glassColor..style = PaintingStyle.fill;
    canvas.drawRect(glassRect, glassPaint);
    
    // Border Gelas
    canvas.drawRect(glassRect, Paint()..color = Colors.white.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.brown[800]!);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }
  
  @override
  bool shouldRepaint(covariant CoffeeMachinePainter old) => old.progress != progress || old.activeStep != activeStep;
}

// =============================================================================
// PAINTER 2: BLENDER JUS (MATERI 2 - INPUT PROSES OUTPUT)
// =============================================================================
class JuiceBlenderPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  JuiceBlenderPainter({
    required this.progress,
    required this.activeStep,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;
    
    // --- PALET WARNA (Lebih Soft & Modern) ---
    final machineColor = Colors.blueGrey[800]!;
    final glassColor = Colors.lightBlueAccent.withOpacity(0.15); // Kaca bening
    final glassBorder = Colors.white.withOpacity(0.6); // Pantulan cahaya
    final orangeSkin = Colors.orange[800]!;
    final orangeInside = Colors.orange[400]!;
    final juiceFluid = Colors.orangeAccent[400]!;

    // --- 1. GAMBAR MESIN (BASE) ---
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 90), width: 110, height: 70),
      const Radius.circular(15),
    );
    
    // Body Mesin
    canvas.drawRRect(baseRect, Paint()..color = machineColor);
    
    // Kaki karet (Detail kecil)
    canvas.drawRect(Rect.fromLTWH(cx - 50, cy + 125, 12, 6), Paint()..color = Colors.black87);
    canvas.drawRect(Rect.fromLTWH(cx + 38, cy + 125, 12, 6), Paint()..color = Colors.black87);
    
    // Tombol/Knob Mesin
    canvas.drawCircle(Offset(cx, cy + 90), 14, Paint()..color = Colors.white12);
    // Lampu indikator (Merah = Stop, Hijau = Jalan)
    canvas.drawCircle(Offset(cx, cy + 90), 8, Paint()..color = (activeStep == 2) ? Colors.greenAccent : Colors.redAccent);

    // --- 2. GAMBAR TABUNG BLENDER (WADAH) ---
    final pathJug = Path();
    // Menggambar bentuk trapesium melengkung (seperti blender asli)
    pathJug.moveTo(cx - 45, cy - 80); // Kiri Atas
    pathJug.quadraticBezierTo(cx - 40, cy, cx - 35, cy + 55); // Kiri Bawah (Melengkung ke dalam)
    pathJug.quadraticBezierTo(cx, cy + 65, cx + 35, cy + 55); // Dasar (Melengkung ke bawah)
    pathJug.quadraticBezierTo(cx + 40, cy, cx + 45, cy - 80); // Kanan Atas
    pathJug.close();

    // --- MASKING / CLIPPING AREA ---
    // Simpan layer canvas, lalu potong sesuai bentuk Jug.
    // Apapun yang digambar setelah ini hanya akan muncul DI DALAM Jug.
    canvas.save();
    canvas.clipPath(pathJug); 

    // Background Kaca (Isi Tabung Kosong)
    canvas.drawPaint(Paint()..color = glassColor);

    // --- LOGIKA ANIMASI (ISI TABUNG) ---
    if (activeStep == 1) { // FASE INPUT (Buah Jatuh)
      _drawFallingOranges(canvas, cx, cy, orangeSkin, orangeInside);
    } 
    else if (activeStep == 2) { // FASE PROSES (Blending)
      _drawBlendingEffect(canvas, cx, cy, juiceFluid);
    }
    else if (activeStep == 3) { // FASE OUTPUT (Menguras Isi)
       // Menggambar sisa jus yang perlahan turun levelnya
       // Rumus: (1.0 - progress) artinya level makin rendah
       double currentHeight = (cy + 60) - ((1.0 - progress) * 110);
       
       if(currentHeight < cy + 60) {
          // Gambar kotak air dari bawah ke atas
          canvas.drawRect(
            Rect.fromLTRB(cx - 50, currentHeight, cx + 50, cy + 70), 
            Paint()..color = juiceFluid
          );
       }
    }

    canvas.restore(); // SELESAI MASKING (Kembali menggambar di luar tabung)

    // --- 3. GAMBAR DETAIL KACA (OVERLAY) ---
    // Garis luar tabung (Border)
    canvas.drawPath(pathJug, Paint()..style = PaintingStyle.stroke..color = glassBorder..strokeWidth = 3);
    
    // Highlight Kaca (Kilau Putih di kiri)
    final pathHighlight = Path();
    pathHighlight.moveTo(cx - 35, cy - 60);
    pathHighlight.quadraticBezierTo(cx - 30, cy, cx - 25, cy + 40);
    canvas.drawPath(pathHighlight, Paint()..style = PaintingStyle.stroke..color = Colors.white.withOpacity(0.3)..strokeWidth = 4..strokeCap = StrokeCap.round);

    // Tutup Blender (Capsule shape)
    final lidRect = Rect.fromCenter(center: Offset(cx, cy - 85), width: 100, height: 18);
    canvas.drawRRect(RRect.fromRectAndRadius(lidRect, const Radius.circular(10)), Paint()..color = Colors.black87);

    // --- 4. LOGIKA LUAR TABUNG (GELAS & TUANG) ---
    String statusText = "";
    
    // Koordinat Gelas Hasil (Di kanan bawah)
    final cupX = cx + 90;
    final cupY = cy + 100;

    if (activeStep == 0) {
      statusText = "Siapkan Bahan";
      // Gambar 1 jeruk melayang di atas sebagai petunjuk
      _drawOrange(canvas, Offset(cx, cy - 120 - (progress * 10)), 16, orangeSkin, orangeInside);
    } 
    else if (activeStep == 1) {
      statusText = "Input Data (Jeruk)";
    } 
    else if (activeStep == 2) {
      statusText = "Proses (Algoritma)";
      // Efek getar mesin (Vibrasi)
      if ((progress * 100).toInt() % 2 == 0) {
         // Geser canvas sedikit kiri-kanan
         canvas.translate((math.Random().nextDouble() - 0.5) * 3, 0); 
      }
    } 
    else if (activeStep == 3) {
      statusText = "Output (Jus Segar)";
      _drawPouringAndCup(canvas, cx, cy, cupX, cupY, juiceFluid, progress);
    } 
    else if (activeStep == 4) { 
      statusText = "Selesai!";
      // Gelas Penuh
      _drawCup(canvas, cupX, cupY, juiceFluid, 1.0);
      // Efek bintang/kilau
      _drawSparkles(canvas, cupX, cupY - 20);
    }

    // Label Status di Atas
    _drawLabelBubble(canvas, size, statusText);
  }

  // ==========================================
  // HELPER METHODS (Untuk merapikan kode utama)
  // ==========================================

  void _drawFallingOranges(Canvas canvas, double cx, double cy, Color skin, Color inside) {
    // Simulasi Gravitasi (Accelerate): progress^2 membuat gerakan makin cepat
    double startY = cy - 160;
    double endY = cy + 40;
    double currentY = startY + (endY - startY) * (progress * progress); 

    // Gambar 3 jeruk jatuh dengan posisi sedikit menyebar
    if (currentY < endY) {
      _drawOrange(canvas, Offset(cx, currentY), 14, skin, inside);
      _drawOrange(canvas, Offset(cx - 20, currentY - 30), 12, skin, inside);
      _drawOrange(canvas, Offset(cx + 20, currentY - 40), 13, skin, inside);
    } else {
      // Jika sudah sampai dasar, gambar jeruk menumpuk
      _drawOrange(canvas, Offset(cx, endY), 14, skin, inside);
      _drawOrange(canvas, Offset(cx - 15, endY - 10), 12, skin, inside);
      _drawOrange(canvas, Offset(cx + 15, endY - 5), 13, skin, inside);
    }
  }

  void _drawOrange(Canvas canvas, Offset center, double radius, Color skin, Color inside) {
    // Kulit Luar
    canvas.drawCircle(center, radius, Paint()..color = skin);
    // Daging Buah
    canvas.drawCircle(center, radius * 0.4, Paint()..color = inside);
    // Titik Putih (Kilau)
    canvas.drawCircle(center + const Offset(-3, -3), 2, Paint()..color = Colors.white.withOpacity(0.6));
  }

  void _drawBlendingEffect(Canvas canvas, double cx, double cy, Color juiceColor) {
    final random = math.Random();
    
    // Cairan utama
    final rectLiquid = Rect.fromCenter(center: Offset(cx, cy), width: 80, height: 120);
    canvas.drawRect(rectLiquid, Paint()..color = juiceColor.withOpacity(0.9));

    // Partikel/Bulir jeruk berputar acak
    for (int i = 0; i < 15; i++) {
      double rX = cx + (random.nextDouble() - 0.5) * 60;
      double rY = cy + (random.nextDouble() - 0.5) * 80;
      double size = 2 + random.nextDouble() * 4;
      canvas.drawCircle(Offset(rX, rY), size, Paint()..color = Colors.white.withOpacity(0.5));
    }
    
    // Pusaran di tengah (Warna lebih gelap)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 20, height: 60), Paint()..color = Colors.redAccent.withOpacity(0.3));
  }

  void _drawPouringAndCup(Canvas canvas, double cx, double cy, double cupX, double cupY, Color juiceColor, double progress) {
    // 1. Gambar Gelas Dulu (Layer Belakang)
    _drawCup(canvas, cupX, cupY, juiceColor, progress);

    // 2. Aliran Air (Layer Depan)
    // Berhenti menuang jika progress sudah 95%
    if (progress < 0.95) { 
      final pathStream = Path();
      pathStream.moveTo(cx + 45, cy - 65); // Asal: Bibir blender
      
      // Membuat kurva S agar aliran terlihat cair & luwes
      pathStream.cubicTo(
        cx + 90, cy - 65, // Control point 1 (Keluar mendatar)
        cupX, cy,         // Control point 2 (Jatuh melengkung)
        cupX, cupY + 10   // Tujuan (Masuk gelas)
      );

      // Gambar aliran
      canvas.drawPath(pathStream, Paint()
        ..style = PaintingStyle.stroke
        ..color = juiceColor
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
      );
    }
  }

  void _drawCup(Canvas canvas, double x, double y, Color juiceColor, double fillPercent) {
    // Bentuk Gelas (Sedikit trapesium)
    final pathCup = Path();
    pathCup.moveTo(x - 20, y - 40);
    pathCup.lineTo(x - 15, y + 40);
    pathCup.quadraticBezierTo(x, y + 45, x + 15, y + 40); // Dasar gelas bulat
    pathCup.lineTo(x + 20, y - 40);
    pathCup.close();

    // Isi Gelas (Masking)
    canvas.save();
    canvas.clipPath(pathCup);
    
    // Air naik dari bawah ke atas
    double waterHeight = 85 * fillPercent; 
    canvas.drawRect(Rect.fromLTWH(x - 25, (y + 45) - waterHeight, 50, waterHeight), Paint()..color = juiceColor);
    
    canvas.restore();

    // Garis Gelas (Outline)
    canvas.drawPath(pathCup, Paint()..style = PaintingStyle.stroke..color = Colors.grey[400]!..strokeWidth = 2);
  }

  void _drawSparkles(Canvas canvas, double x, double y) {
    final paint = Paint()..color = Colors.amber..style = PaintingStyle.fill;
    // Tiga bintang sederhana
    final points = [
      Offset(x, y - 15), Offset(x - 15, y), Offset(x + 15, y - 5)
    ];
    for (var p in points) {
      canvas.drawCircle(p, 4, paint); // Inti bintang
      canvas.drawCircle(p, 2, Paint()..color = Colors.white); // Kilau tengah
    }
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 14,
          fontFamily: 'sans-serif' // Font standar
        )
      ), 
      textDirection: TextDirection.ltr
    )..layout();

    final bubbleCenter = Offset(size.width * 0.5, size.height * 0.15);
    final bubbleRect = Rect.fromCenter(
      center: bubbleCenter, 
      width: textPainter.width + 30, 
      height: textPainter.height + 16
    );

    // Bayangan Bubble
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect.translate(2, 2), const Radius.circular(20)), 
      Paint()..color = Colors.black26
    );
    // Body Bubble
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), 
      Paint()..color = theme.colorScheme.primary
    );

    textPainter.paint(
      canvas, 
      Offset(bubbleCenter.dx - textPainter.width / 2, bubbleCenter.dy - textPainter.height / 2)
    );
  }

  @override
  bool shouldRepaint(covariant JuiceBlenderPainter old) => 
    old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 3: MEMAKAI SEPATU (MATERI 3 - SEKUENSIAL)
// =============================================================================
class WearingShoesPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  WearingShoesPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.6; 

    // --- PALET WARNA ---
    final skinColor = const Color(0xFFFFCCAA);
    final skinShadow = const Color(0xFFEebb99);
    final sockColor = Colors.white;
    final sockDetail = Colors.grey[300]!;
    final sockStripe = Colors.redAccent;
    final shoeColor = Colors.indigo[800]!;
    final shoeSole = Colors.white;
    final shoeLace = Colors.white70;

    // --- 1. GAMBAR KAKI (BASE) ---
    // Betis (Leg)
    final pathLeg = Path();
    pathLeg.moveTo(cx - 25, cy - 150); // Atas Kiri
    pathLeg.lineTo(cx - 20, cy + 10);  // Pergelangan Kiri (Menyempit)
    pathLeg.lineTo(cx + 20, cy + 10);  // Pergelangan Kanan
    pathLeg.lineTo(cx + 25, cy - 150); // Atas Kanan
    pathLeg.close();

    // Telapak Kaki (Foot)
    final pathFoot = Path();
    pathFoot.moveTo(cx - 20, cy);       // Tumit Atas
    pathFoot.quadraticBezierTo(cx - 35, cy + 40, cx - 10, cy + 50); // Tumit Bawah Melengkung
    pathFoot.lineTo(cx + 40, cy + 50);  // Telapak Datar
    pathFoot.quadraticBezierTo(cx + 75, cy + 50, cx + 75, cy + 25); // Jari Depan
    pathFoot.quadraticBezierTo(cx + 60, cy + 10, cx + 30, cy + 5);  // Punggung Kaki
    pathFoot.lineTo(cx + 20, cy + 10);  // Sambungan ke Pergelangan
    pathFoot.close();

    // Gabungkan Kaki Utuh untuk Masking
    final pathFullLeg = Path.combine(PathOperation.union, pathLeg, pathFoot);

    // Draw Kaki Telanjang (Skin)
    canvas.drawPath(pathFullLeg, Paint()..color = skinColor);
    // Bayangan otot betis dikit
    canvas.drawPath(pathLeg, Paint()..style=PaintingStyle.stroke..color=skinShadow..strokeWidth=1);


    // --- LOGIKA ANIMASI ---
    String statusText = "";

    // A. KAUS KAKI (Step 1 & Seterusnya)
    if (activeStep >= 1) {
      statusText = "Langkah 1: Kaus Kaki";
      
      // Hitung posisi turunnya kaus kaki
      // Jika step > 1 (sudah sepatu), kaus kaki dianggap sudah terpasang penuh (progress = 1.0)
      double sockProgress = (activeStep == 1) ? progress : 1.0;
      
      double startY = cy - 160; // Mulai dari atas layar
      double endY = cy + 10;    // Sampai pergelangan kaki
      double currentY = startY + (endY - startY) * sockProgress;

      canvas.save();
      canvas.clipPath(pathFullLeg); // Kaus kaki tidak keluar dari garis kaki

      // Gambar Kaus Kaki (Kotak yang turun)
      final sockRect = Rect.fromLTRB(cx - 30, startY, cx + 30, currentY);
      canvas.drawRect(sockRect, Paint()..color = sockColor);
      
      // Detail Garis Merah di atas kaus kaki
      if (currentY > startY + 20) {
         canvas.drawRect(Rect.fromLTRB(cx - 30, currentY - 20, cx + 30, currentY - 10), Paint()..color = sockStripe);
      }

      // Bagian Telapak Kaki (Muncul setelah betis tertutup)
      if (sockProgress > 0.8) {
        double footReveal = (sockProgress - 0.8) * 5; // 0.0 -> 1.0
        // Gambar menutupi area telapak kaki
        canvas.drawPath(pathFoot, Paint()..color = sockColor.withOpacity(footReveal));
      }
      
      canvas.restore();
    }

    // B. SEPATU (Step 2 & Seterusnya)
    if (activeStep >= 2) {
      statusText = "Langkah 2: Sepatu";
      
      // Posisi Sepatu (Masuk dari Kanan)
      // Jika step > 2 (selesai), sepatu sudah di posisi akhir
      double shoeProgress = (activeStep == 2) ? progress : 1.0;
      
      double startX = cx + 150;
      double endX = cx; 
      double currentX = startX - (startX - endX) * shoeProgress; // Bergerak ke kiri

      // Gambar Sepatu (Sneakers)
      final pathShoe = Path();
      // Tumit Belakang
      pathShoe.moveTo(currentX - 38, cy + 55); 
      pathShoe.lineTo(currentX - 35, cy + 15);
      // Lidah Sepatu
      pathShoe.quadraticBezierTo(currentX, cy - 5, currentX + 30, cy + 10);
      // Ujung Depan
      pathShoe.quadraticBezierTo(currentX + 85, cy + 25, currentX + 80, cy + 50);
      pathShoe.lineTo(currentX + 80, cy + 55);
      pathShoe.close();

      // Body Sepatu
      canvas.drawPath(pathShoe, Paint()..color = shoeColor);
      
      // Sol Sepatu (Putih Tebal)
      final pathSole = Path();
      pathSole.moveTo(currentX - 38, cy + 55);
      pathSole.lineTo(currentX + 80, cy + 55);
      pathSole.lineTo(currentX + 80, cy + 65); // Tebal sol
      pathSole.lineTo(currentX - 38, cy + 65);
      pathSole.close();
      canvas.drawPath(pathSole, Paint()..color = shoeSole);

      // Detail Tali Sepatu (Laces)
      if (shoeProgress > 0.8) {
         // Gambar silang tali
         final lacePaint = Paint()..color = shoeLace..strokeWidth = 3..strokeCap = StrokeCap.round;
         canvas.drawLine(Offset(currentX + 10, cy + 10), Offset(currentX + 30, cy + 10), lacePaint);
         canvas.drawLine(Offset(currentX + 15, cy + 20), Offset(currentX + 35, cy + 20), lacePaint);
         // Simpul
         canvas.drawCircle(Offset(currentX + 25, cy + 5), 4, lacePaint..style=PaintingStyle.fill);
      }
    }

    // C. STATUS TEXT
    if (activeStep == 0) statusText = "Mulai (Kaki Kosong)";
    if (activeStep == 4) { // Finish
       statusText = "Siap Berjalan!";
       // Efek Tanah (Bayangan)
       canvas.drawOval(
         Rect.fromCenter(center: Offset(cx + 20, cy + 70), width: 140, height: 10), 
         Paint()..color = Colors.black12
       );
       // Sparkles
       _drawSparkle(canvas, cx + 90, cy + 10);
       _drawSparkle(canvas, cx - 50, cy + 40);
    }

    _drawLabelBubble(canvas, size, statusText);
  }

  void _drawSparkle(Canvas canvas, double x, double y) {
    final paint = Paint()..color = Colors.amber..strokeWidth = 2;
    canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), paint);
    canvas.drawLine(Offset(x, y - 5), Offset(x, y + 5), paint);
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 14,
          fontFamily: 'sans-serif'
        )
      ), 
      textDirection: TextDirection.ltr
    )..layout();

    final bubbleRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.15), 
      width: textPainter.width + 30, 
      height: textPainter.height + 16
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), 
      Paint()..color = Colors.teal
    );
    
    textPainter.paint(
      canvas, 
      Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2)
    );
  }

  @override
  bool shouldRepaint(covariant WearingShoesPainter old) => 
    old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 4: PINTU OTOMATIS (MATERI 4 - IF TUNGGAL)
// =============================================================================
class AutomaticDoorPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  AutomaticDoorPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;

    // --- WARNA ---
    final wallColor = Colors.grey[300]!;
    final floorColor = Colors.grey[400]!;
    final glassColor = Colors.blueAccent.withOpacity(0.3); // Lebih transparan
    final frameColor = Colors.blueGrey[800]!;
    final sensorColor = Colors.black87;
    final sensorActive = Colors.greenAccent[400]!;
    final sensorIdle = Colors.redAccent;
    
    // Warna Orang
    final headColor = const Color(0xFFFFCCAA);
    final bodyColor = Colors.indigo[600]!;
    final pantsColor = Colors.black87;

    // --- 1. GAMBAR RUANGAN (PERSPEKTIF) ---
    // Lantai (Trapesium)
    final pathFloor = Path();
    pathFloor.moveTo(0, size.height);
    pathFloor.lineTo(size.width, size.height);
    pathFloor.lineTo(size.width, cy - 20); // Horizon line
    pathFloor.lineTo(0, cy - 20);
    pathFloor.close();
    canvas.drawPath(pathFloor, Paint()..color = floorColor);

    // Dinding Belakang (Pintu Masuk)
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, cy + 120), Paint()..color = wallColor);
    
    // Bingkai Pintu Besar (Kusen)
    final doorFrameRect = Rect.fromCenter(center: Offset(cx, cy + 20), width: 220, height: 260);
    canvas.drawRect(doorFrameRect, Paint()..color = frameColor);
    
    // Bagian dalam Pintu (Lubang) - Gelap karena dalam ruangan
    final doorHoleRect = Rect.fromCenter(center: Offset(cx, cy + 20), width: 200, height: 240);
    canvas.drawRect(doorHoleRect, Paint()..color = Colors.blueGrey[900]!);

    // Sensor Box
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - 120), width: 80, height: 25), Paint()..color = sensorColor);


    // --- 2. LOGIKA ANIMASI & VARIABLE ---
    double personY = 0.0;
    double personScale = 1.0;
    double doorOpenWidth = 0.0; // 0 sampai 100
    Color currentSensorColor = sensorIdle;
    String statusText = "";
    bool personIsInside = false; // Penanda orang sudah di dalam

    if (activeStep == 0) { // DATANG
      statusText = "Orang Datang...";
      // Jalan dari bawah (depan layar) ke tengah
      personY = size.height + 50 - (progress * 150); 
      personScale = 1.3 - (progress * 0.3); // Mengecil menjauh
    } 
    else if (activeStep == 1) { // SENSOR DETEKSI
      statusText = "IF (Sensor == TRUE)";
      personY = size.height - 100; // Berdiri di depan pintu
      personScale = 1.0;
      
      // Animasi Sensor Berkedip/Scan
      currentSensorColor = sensorActive;
      // Gambar Sinar Sensor (Cone)
      final beamPath = Path();
      beamPath.moveTo(cx, cy - 110);
      beamPath.lineTo(cx - (60 * progress), cy + 80);
      beamPath.lineTo(cx + (60 * progress), cy + 80);
      beamPath.close();
      canvas.drawPath(beamPath, Paint()..color = sensorActive.withOpacity(0.3 * (1-progress)));
    } 
    else if (activeStep == 2) { // BUKA PINTU
      statusText = "THEN: Buka Pintu";
      personY = size.height - 100;
      personScale = 1.0;
      currentSensorColor = sensorActive;
      
      // Pintu membuka
      doorOpenWidth = 90.0 * progress;
    } 
    else { // MASUK
      statusText = "Selesai (Masuk)";
      doorOpenWidth = 90.0;
      currentSensorColor = sensorActive;
      personIsInside = true; 

      // Jalan masuk ke dalam (naik ke atas, mengecil, meredup)
      personY = (size.height - 100) - (progress * 120);
      personScale = 1.0 - (progress * 0.4); 
    }

    // --- 3. GAMBAR ORANG (LAYER BELAKANG - JIKA SUDAH MASUK) ---
    // Jika orang sudah masuk (Step 3), gambar dia DULUAN agar tertutup pintu kaca nanti
    if (personIsInside) {
       _drawPerson(canvas, Offset(cx, personY), personScale, headColor, bodyColor, pantsColor, isDark: true);
    }

    // --- 4. GAMBAR PINTU KACA (GESER) ---
    // Pintu Kiri (Geser ke kiri)
    _drawGlassDoor(canvas, Offset(cx - 50 - doorOpenWidth, cy + 20), glassColor, frameColor);
    // Pintu Kanan (Geser ke kanan)
    _drawGlassDoor(canvas, Offset(cx + 50 + doorOpenWidth, cy + 20), glassColor, frameColor);

    // Lampu Sensor
    canvas.drawCircle(Offset(cx, cy - 120), 6, Paint()..color = currentSensorColor);

    // --- 5. GAMBAR ORANG (LAYER DEPAN - JIKA BELUM MASUK) ---
    // Jika masih di luar (Step 0, 1, 2), gambar dia TERAKHIR agar menutupi pintu/lantai
    if (!personIsInside) {
       _drawPerson(canvas, Offset(cx, personY), personScale, headColor, bodyColor, pantsColor);
    }

    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER METHODS ---

  void _drawGlassDoor(Canvas canvas, Offset center, Color glass, Color frame) {
    // Daun Pintu
    final rect = Rect.fromCenter(center: center, width: 100, height: 240);
    
    // Kaca Transparan
    canvas.drawRect(rect, Paint()..color = glass);
    // Frame Aluminium
    canvas.drawRect(rect, Paint()..style = PaintingStyle.stroke..color = Colors.grey[400]!..strokeWidth = 6);
    // Gagang Vertikal
    canvas.drawRect(
      Rect.fromCenter(center: Offset(center.dx + (center.dx < 0 ? 35 : -35), center.dy), width: 6, height: 60),
      Paint()..color = Colors.grey[300]!
    );
    // Kilau Kaca (Garis diagonal)
    final shinePath = Path();
    shinePath.moveTo(rect.left + 10, rect.top + 20);
    shinePath.lineTo(rect.right - 40, rect.bottom - 20);
    canvas.drawPath(shinePath, Paint()..style=PaintingStyle.stroke..color=Colors.white.withOpacity(0.3)..strokeWidth=15);
  }

  void _drawPerson(Canvas canvas, Offset footPos, double scale, Color head, Color body, Color pants, {bool isDark = false}) {
    // Pusat koordinat orang ada di kaki (footPos)
    // Tinggi total orang sekitar 160 * scale
    
    // Jika masuk ruangan gelap, warna jadi lebih gelap
    final darken = isDark ? Colors.black54 : Colors.transparent;

    // Kaki/Celana
    final pantsRect = Rect.fromCenter(
      center: Offset(footPos.dx, footPos.dy - (40 * scale)), 
      width: 30 * scale, 
      height: 80 * scale
    );
    canvas.drawRect(pantsRect, Paint()..color = pants);
    
    // Badan/Baju
    final bodyRect = Rect.fromCenter(
      center: Offset(footPos.dx, footPos.dy - (100 * scale)), 
      width: 40 * scale, 
      height: 70 * scale
    );
    // Baju (Curve bahu)
    final bodyPath = Path();
    bodyPath.addRRect(RRect.fromRectAndRadius(bodyRect, Radius.circular(10 * scale)));
    canvas.drawPath(bodyPath, Paint()..color = body);

    // Kepala
    canvas.drawCircle(Offset(footPos.dx, footPos.dy - (145 * scale)), 18 * scale, Paint()..color = head);

    // Overlay Gelap (Shadow jika masuk ruangan)
    if (isDark) {
       canvas.drawPath(bodyPath, Paint()..color = darken);
       canvas.drawRect(pantsRect, Paint()..color = darken);
       canvas.drawCircle(Offset(footPos.dx, footPos.dy - (145 * scale)), 18 * scale, Paint()..color = darken);
    }
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 14,
          fontFamily: 'sans-serif'
        )
      ), 
      textDirection: TextDirection.ltr
    )..layout();

    final bubbleRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.15), 
      width: textPainter.width + 30, 
      height: textPainter.height + 16
    );

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect.translate(2, 2), const Radius.circular(20)), 
      Paint()..color = Colors.black26
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), 
      Paint()..color = Colors.indigo
    );
    
    textPainter.paint(
      canvas, 
      Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2)
    );
  }

  @override
  bool shouldRepaint(covariant AutomaticDoorPainter old) => 
    old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 5: PERSIMPANGAN JALAN (MATERI 5 - IF ELSE)
// =============================================================================
class IfElseRoadPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  IfElseRoadPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.75; // Titik percabangan (Split Point)

    // --- WARNA ---
    final roadColor = Colors.grey[800]!;
    final roadBorder = Colors.grey[900]!;
    final grassColor = Colors.green[100]!; // Background rumput
    final laneColor = Colors.white;
    final carColor = Colors.orangeAccent[400]!;
    
    // Background Rumput
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = grassColor);

    // --- 1. MEMBUAT PATH JALAN (Y-SHAPE) ---
    // Kita buat 3 segmen jalan terpisah untuk memudahkan penggambaran marka
    
    // Lebar jalan
    const double roadW = 80.0;
    const double halfRoad = roadW / 2;

    // A. Jalan Utama (Bawah)
    final pathMain = Path();
    pathMain.moveTo(cx - halfRoad, size.height);
    pathMain.lineTo(cx - halfRoad, cy + 20); // Sedikit overlap ke atas
    pathMain.lineTo(cx + halfRoad, cy + 20);
    pathMain.lineTo(cx + halfRoad, size.height);
    pathMain.close();

    // B. Jalan Kiri (IF - LULUS)
    final pathLeft = Path();
    pathLeft.moveTo(cx - halfRoad, cy + 25);
    // Kurva Luar Kiri
    pathLeft.cubicTo(
      cx - halfRoad, cy - 100, // Control Point 1
      cx - 120, cy - 150,      // Control Point 2
      cx - 120, cy - 250       // End Point
    );
    pathLeft.lineTo(cx - 120 + roadW, cy - 250); // Lebar jalan di ujung
    // Kurva Dalam Kiri
    pathLeft.cubicTo(
      cx - 120 + roadW, cy - 150, 
      cx + halfRoad, cy - 100, 
      cx + halfRoad, cy + 25
    );
    pathLeft.close();

    // C. Jalan Kanan (ELSE - REMIDI)
    final pathRight = Path();
    pathRight.moveTo(cx + halfRoad, cy + 25);
    // Kurva Luar Kanan
    pathRight.cubicTo(
      cx + halfRoad, cy - 100,
      cx + 120, cy - 150,
      cx + 120, cy - 250
    );
    pathRight.lineTo(cx + 120 - roadW, cy - 250);
    // Kurva Dalam Kanan
    pathRight.cubicTo(
      cx + 120 - roadW, cy - 150,
      cx - halfRoad, cy - 100,
      cx - halfRoad, cy + 25
    );
    pathRight.close();

    // --- GAMBAR JALAN ---
    final roadPaint = Paint()..color = roadColor;
    final borderPaint = Paint()..color = roadBorder..style=PaintingStyle.stroke..strokeWidth=4;

    // Gambar Kiri & Kanan dulu (Layer bawah)
    canvas.drawPath(pathLeft, roadPaint);
    canvas.drawPath(pathLeft, borderPaint);
    canvas.drawPath(pathRight, roadPaint);
    canvas.drawPath(pathRight, borderPaint);
    
    // Penutup persimpangan (Layer atas agar rapi)
    // Gambar segitiga kecil di tengah percabangan untuk menutup celah
    final intersectionPath = Path();
    intersectionPath.moveTo(cx, cy - 50);
    intersectionPath.lineTo(cx - 10, cy + 30);
    intersectionPath.lineTo(cx + 10, cy + 30);
    intersectionPath.close();
    canvas.drawPath(intersectionPath, roadPaint);

    // Gambar Jalan Utama
    canvas.drawPath(pathMain, roadPaint);
    canvas.drawPath(pathMain, borderPaint);

    // --- MARKA JALAN (PUTUS-PUTUS) ---
    final dashPaint = Paint()..color = laneColor..style=PaintingStyle.stroke..strokeWidth=2;
    // Main Lane
    _drawDashedLine(canvas, Offset(cx, size.height), Offset(cx, cy + 20), dashPaint);
    // Left Lane (Kurva)
    _drawCurvedDashedLine(canvas, cx, cy, true, dashPaint);
    // Right Lane (Kurva)
    _drawCurvedDashedLine(canvas, cx, cy, false, dashPaint);

    // Rambu Jalan
    _drawRoadSign(canvas, Offset(cx - 120 + 40, cy - 220), "LULUS", Colors.green);
    _drawRoadSign(canvas, Offset(cx + 120 - 40, cy - 220), "REMIDI", Colors.red);


    // --- 2. LOGIKA ANIMASI MOBIL ---
    String statusText = "";
    double carX = cx;
    double carY = size.height + 50; // Mulai di luar layar bawah
    double carAngle = 0;

    if (activeStep == 0) { // DATANG
      statusText = "Mobil Datang";
      // Interpolasi Linear: Bawah -> Tengah
      double startY = size.height + 40;
      double endY = cy + 40;
      carY = startY - ((startY - endY) * progress);
    } 
    else if (activeStep == 1) { // MIKIR
      statusText = "Cek Kondisi (Nilai > 70?)";
      carY = cy + 40;
      
      // Animasi Bubble
      double scale = 0.8 + (0.2 * (progress * 5).toInt() % 2); // Kedip
      _drawThoughtBubble(canvas, Offset(cx + 30, cy - 20), "?", scale);
    } 
    else if (activeStep == 2) { // KIRI (LULUS)
      statusText = "TRUE: Belok Kiri";
      // Bezier Curve Logic
      // P0 = (cx, cy+40)
      // P1 = (cx, cy-100) -- Control point lurus dulu baru belok
      // P2 = (cx-120+40, cy-150)
      // P3 = (cx-80, cy-250)
      
      // Simplifikasi Cubic Bezier
      double t = progress;
      double p0x = cx; double p0y = cy + 40;
      double p1x = cx; double p1y = cy - 80; // Tarik ke atas dulu
      double p2x = cx - 80; double p2y = cy - 150;
      double p3x = cx - 80; double p3y = cy - 250;

      // Rumus Cubic Bezier
      carX = _cubic(t, p0x, p1x, p2x, p3x);
      carY = _cubic(t, p0y, p1y, p2y, p3y);
      
      // Hitung sudut rotasi (turunan pertama / tangen)
      double dx = _cubicDerivative(t, p0x, p1x, p2x, p3x);
      double dy = _cubicDerivative(t, p0y, p1y, p2y, p3y);
      carAngle = dx != 0 ? (dy/dx) : 0; 
      // Koreksi sudut atan manual sederhana
      carAngle = -0.5 * t; // Rotasi manual agar mulus ke kiri
    } 
    else { // KANAN (REMIDI)
      statusText = "FALSE: Belok Kanan";
      double t = progress;
      double p0x = cx; double p0y = cy + 40;
      double p1x = cx; double p1y = cy - 80; 
      double p2x = cx + 80; double p2y = cy - 150;
      double p3x = cx + 80; double p3y = cy - 250;

      carX = _cubic(t, p0x, p1x, p2x, p3x);
      carY = _cubic(t, p0y, p1y, p2y, p3y);
      
      carAngle = 0.5 * t; // Rotasi manual ke kanan
    }

    // --- 3. GAMBAR MOBIL ---
    canvas.save();
    canvas.translate(carX, carY);
    canvas.rotate(carAngle);
    _drawCar(canvas, carColor);
    canvas.restore();

    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER MATH ---
  // Cubic Bezier Formula: (1-t)^3*P0 + 3(1-t)^2*t*P1 + 3(1-t)t^2*P2 + t^3*P3
  double _cubic(double t, double p0, double p1, double p2, double p3) {
    double u = 1 - t;
    return (u*u*u*p0) + (3*u*u*t*p1) + (3*u*t*t*p2) + (t*t*t*p3);
  }
  
  // Turunan untuk hitung sudut (opsional, dipakai manual rotation di atas biar simpel)
  double _cubicDerivative(double t, double p0, double p1, double p2, double p3) {
    double u = 1 - t;
    return 3*u*u*(p1-p0) + 6*u*t*(p2-p1) + 3*t*t*(p3-p2);
  }

  // --- HELPER DRAWING ---

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    // Gambar manual putus-putus
    double dashWidth = 10;
    double dashSpace = 10;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;
    double currentDist = 0;
    while (currentDist < distance) {
      canvas.drawLine(
        Offset(p1.dx + dx * currentDist, p1.dy + dy * currentDist),
        Offset(p1.dx + dx * (currentDist + dashWidth), p1.dy + dy * (currentDist + dashWidth)),
        paint
      );
      currentDist += dashWidth + dashSpace;
    }
  }

  void _drawCurvedDashedLine(Canvas canvas, double cx, double cy, bool isLeft, Paint paint) {
    final path = Path();
    path.moveTo(cx, cy + 20);
    // Kurva tengah jalan (median)
    if (isLeft) {
      path.cubicTo(cx, cy - 80, cx - 80, cy - 150, cx - 80, cy - 250);
    } else {
      path.cubicTo(cx, cy - 80, cx + 80, cy - 150, cx + 80, cy - 250);
    }

    // Menggambar path putus-putus (Sederhana: gambar titik-titik di sepanjang path)
    // Karena PathMetric butuh 'dart:ui' yang kadang ribet di beberapa setup tanpa import,
    // kita pakai garis solid tipis saja untuk marka lengkung di versi ini agar aman.
    canvas.drawPath(path, paint..style=PaintingStyle.stroke..strokeWidth=1); 
  }

  void _drawCar(Canvas canvas, Color color) {
    // Bayangan Mobil
    canvas.drawOval(Rect.fromCenter(center: const Offset(0, 5), width: 35, height: 55), Paint()..color = Colors.black26);

    // Body
    final rect = Rect.fromCenter(center: Offset.zero, width: 30, height: 50);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), Paint()..color = color);
    
    // Kaca Depan (Gradient effect)
    final glassRect = Rect.fromCenter(center: const Offset(0, -10), width: 24, height: 12);
    canvas.drawRRect(RRect.fromRectAndRadius(glassRect, const Radius.circular(3)), Paint()..color = Colors.lightBlueAccent);
    
    // Kaca Belakang
    canvas.drawRect(Rect.fromCenter(center: const Offset(0, 15), width: 22, height: 8), Paint()..color = Colors.black87);

    // Atap
    canvas.drawRect(Rect.fromCenter(center: const Offset(0, 5), width: 24, height: 18), Paint()..color = color.withOpacity(0.5));
    
    // Lampu Depan
    canvas.drawCircle(const Offset(-10, -22), 4, Paint()..color = Colors.yellow);
    canvas.drawCircle(const Offset(10, -22), 4, Paint()..color = Colors.yellow);
    
    // Lampu Rem
    canvas.drawCircle(const Offset(-10, 22), 3, Paint()..color = Colors.red);
    canvas.drawCircle(const Offset(10, 22), 3, Paint()..color = Colors.red);
  }

  void _drawRoadSign(Canvas canvas, Offset pos, String text, Color color) {
    // Tiang
    canvas.drawLine(Offset(pos.dx, pos.dy + 15), Offset(pos.dx, pos.dy + 50), Paint()..color = Colors.grey[600]!..strokeWidth=4);
    // Papan Rambu
    final rect = Rect.fromCenter(center: pos, width: 70, height: 30);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), Paint()..color = color);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), Paint()..color = Colors.white..style=PaintingStyle.stroke..strokeWidth=2);
    
    // Teks
    final tp = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width/2, pos.dy - tp.height/2));
  }

  void _drawThoughtBubble(Canvas canvas, Offset pos, String text, double scale) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.scale(scale);
    
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final border = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth=2;
    
    // Bubble Oval
    final bubbleRect = Rect.fromCenter(center: Offset.zero, width: 40, height: 30);
    canvas.drawOval(bubbleRect, paint);
    canvas.drawOval(bubbleRect, border);
    
    // Ekor Bubble (Titik-titik)
    canvas.drawCircle(const Offset(-15, 15), 4, paint);
    canvas.drawCircle(const Offset(-15, 15), 4, border);
    canvas.drawCircle(const Offset(-20, 20), 2, paint);
    canvas.drawCircle(const Offset(-20, 20), 2, border);

    final tp = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(-tp.width/2, -tp.height/2));
    
    canvas.restore();
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'sans-serif')
      ), 
      textDirection: TextDirection.ltr
    )..layout();

    final bubbleRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.15), 
      width: textPainter.width + 30, 
      height: textPainter.height + 16
    );

    // Shadow
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect.translate(2, 2), const Radius.circular(20)), Paint()..color = Colors.black26);
    // Body
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant IfElseRoadPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 6: PENGUKUR TINGGI (MATERI 6 - OPERATOR PEMBANDING)
// =============================================================================
class HeightMeasurementPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  HeightMeasurementPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55; // Geser sedikit ke bawah

    // --- WARNA ---
    final rulerColor = Colors.grey[400]!;
    final floorColor = Colors.grey[800]!;
    final limitColor = Colors.redAccent;
    final actualHeightColor = Colors.blueAccent;
    
    // Warna Karakter
    final headColor = const Color(0xFFFFCCAA);
    final bodyColor = Colors.orangeAccent[400]!;
    
    // Dasar Lantai
    canvas.drawLine(Offset(0, cy + 100), Offset(size.width, cy + 100), Paint()..color = floorColor..strokeWidth = 4);

    // --- 1. GAMBAR ALAT UKUR ---
    final rulerX = cx + 80;
    final rulerBottom = cy + 100;
    final rulerTop = cy - 120;
    
    // Tiang Vertikal
    canvas.drawLine(Offset(rulerX, rulerTop), Offset(rulerX, rulerBottom), Paint()..color = rulerColor..strokeWidth = 6..strokeCap = StrokeCap.round);
    
    // Garis-garis Sentimeter (Skala)
    final markPaint = Paint()..color = Colors.grey[600]!..strokeWidth = 2;
    for (int i = 0; i <= 10; i++) {
      double y = rulerBottom - (i * 20);
      double width = (i % 5 == 0) ? 15.0 : 8.0; // Garis kelipatan 5 lebih panjang
      canvas.drawLine(Offset(rulerX - width, y), Offset(rulerX, y), markPaint);
      
      // Label Angka (100cm - 200cm)
      if (i % 5 == 0) {
        _drawText(canvas, Offset(rulerX + 25, y), "${100 + (i * 10)}", Colors.grey[700]!, 10);
      }
    }

    // --- 2. LOGIKA ANIMASI & VARIABEL ---
    String statusText = "";
    String logicText = "";
    Color logicColor = Colors.grey;
    
    double personHeightCm = 0; // Tinggi dalam CM (visual)
    double limitCm = 150;      // Batas 150cm
    
    // Konversi CM ke Pixel (20 pixel = 10cm -> 2 pixel = 1cm)
    double pxPerCm = 2.0; 
    
    // Posisi Y untuk batas 150cm (Start dari 100cm di bawah)
    // Ruler bottom = 100cm.
    double limitY = rulerBottom - ((limitCm - 100) * pxPerCm);

    if (activeStep == 0) { // SIAP
      statusText = "Siapkan Alat Ukur";
      personHeightCm = 0; // Orang belum masuk
      
      // Animasi Slider turun dari atas ke batas limit
      double startY = rulerTop;
      double currentSliderY = startY + (progress * (limitY - startY));
      _drawHeightSlider(canvas, rulerX, currentSliderY, limitColor, "Batas: 150");
    } 
    else if (activeStep == 1) { // TINGGI > BATAS
      statusText = "Lebih Besar (>)";
      logicText = "180 > 150 ✅";
      logicColor = Colors.green;
      
      // Animasi Tumbuh: 100cm -> 180cm
      double targetCm = 180;
      personHeightCm = 100 + (progress * (targetCm - 100));
      
      _drawHeightSlider(canvas, rulerX, limitY, limitColor, "Batas: 150");
    } 
    else if (activeStep == 2) { // TINGGI < BATAS
      statusText = "Kurang Dari (<)";
      logicText = "130 < 150 ✅";
      logicColor = Colors.blue;
      
      // Animasi Menyusut: 180cm -> 130cm
      double startCm = 180;
      double targetCm = 130;
      personHeightCm = startCm - (progress * (startCm - targetCm));
      
      _drawHeightSlider(canvas, rulerX, limitY, limitColor, "Batas: 150");
    } 
    else { // TINGGI == BATAS
      statusText = "Sama Dengan (==)";
      logicText = "150 == 150 ✅";
      logicColor = Colors.purple;
      
      // Animasi Naik: 130cm -> 150cm
      double startCm = 130;
      double targetCm = 150;
      personHeightCm = startCm + (progress * (targetCm - startCm));
      
      _drawHeightSlider(canvas, rulerX, limitY, limitColor, "Batas: 150");
    }

    // --- 3. GAMBAR ORANG (STICKMAN PROPORSIONAL) ---
    if (activeStep > 0) {
      double personPixelHeight = (personHeightCm - 100) * pxPerCm; // Tinggi visual relatif thd ruler
      // Agar terlihat natural, kita tambah offset base tinggi badan (misal kaki sampai pinggang 100cm visual)
      // Total tinggi pixel dari lantai
      double totalHeadToToe = 100.0 + personPixelHeight; 
      
      _drawStickman(canvas, Offset(cx - 30, rulerBottom), totalHeadToToe, headColor, bodyColor);

      // Garis Penanda Tinggi Orang (Putus-putus Biru)
      double headTopY = rulerBottom - totalHeadToToe;
      _drawDashedLine(canvas, Offset(cx - 30, headTopY), Offset(rulerX, headTopY), actualHeightColor);
      
      // Label Tinggi Orang
      _drawText(canvas, Offset(cx - 30, headTopY - 15), "${personHeightCm.toInt()} cm", actualHeightColor, 12, bold: true);
    }

    // --- 4. POPUP LOGIKA ---
    if (activeStep > 0) {
      _drawLogicBox(canvas, Offset(cx, cy - 140), logicText, logicColor);
    }

    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER METHODS ---

  void _drawStickman(Canvas canvas, Offset footPos, double height, Color headColor, Color bodyColor) {
    // Proporsi Sederhana:
    // Kepala = 1/8 tinggi
    // Badan = 3/8 tinggi
    // Kaki = 4/8 tinggi
    
    double headSize = height * 0.15; // Sedikit diperbesar biar lucu
    if (headSize < 15) headSize = 15;
    
    double bodyLen = height * 0.35;
    double legLen = height * 0.45;
    
    // Titik-titik sendi
    Offset headCenter = Offset(footPos.dx, footPos.dy - height + (headSize/2));
    Offset neck = Offset(footPos.dx, footPos.dy - height + headSize);
    Offset hip = Offset(footPos.dx, footPos.dy - legLen);
    
    Paint stickPaint = Paint()..color = bodyColor..strokeWidth = 4..strokeCap = StrokeCap.round;
    
    // Badan
    canvas.drawLine(neck, hip, stickPaint);
    
    // Kaki (Sedikit terbuka)
    canvas.drawLine(hip, Offset(footPos.dx - 10, footPos.dy), stickPaint);
    canvas.drawLine(hip, Offset(footPos.dx + 10, footPos.dy), stickPaint);
    
    // Tangan (Lurus ke bawah)
    canvas.drawLine(Offset(neck.dx, neck.dy + 5), Offset(footPos.dx - 15, neck.dy + bodyLen * 0.6), stickPaint);
    canvas.drawLine(Offset(neck.dx, neck.dy + 5), Offset(footPos.dx + 15, neck.dy + bodyLen * 0.6), stickPaint);

    // Kepala
    canvas.drawCircle(headCenter, headSize / 2, Paint()..color = headColor);
  }

  void _drawHeightSlider(Canvas canvas, double x, double y, Color color, String label) {
    final paint = Paint()..color = color..strokeWidth = 3;
    // Garis Horizontal Panjang (Limit Line)
    canvas.drawLine(Offset(x - 100, y), Offset(x + 10, y), paint);
    
    // Segitiga Slider pada Penggaris
    final path = Path();
    path.moveTo(x, y);
    path.lineTo(x + 15, y - 8);
    path.lineTo(x + 15, y + 8);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    
    // Label Limit
    _drawText(canvas, Offset(x + 35, y), label, color, 10, bold: true);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke;
    double dashWidth = 5;
    double dashSpace = 5;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;
    double currentDist = 0;
    while (currentDist < distance) {
      canvas.drawLine(
        Offset(p1.dx + dx * currentDist, p1.dy + dy * currentDist),
        Offset(p1.dx + dx * (currentDist + dashWidth), p1.dy + dy * (currentDist + dashWidth)),
        paint
      );
      currentDist += dashWidth + dashSpace;
    }
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr
    )..layout();
    
    final rect = Rect.fromCenter(center: center, width: tp.width + 30, height: tp.height + 20);
    
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), Paint()..color = Colors.white..style=PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), Paint()..color = color..style=PaintingStyle.stroke..strokeWidth=2);
    
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double size, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 16);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant HeightMeasurementPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 7: SORTIR BAJU (MATERI 7 - ELSE IF)
// =============================================================================
class ElseIfSortingPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  ElseIfSortingPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.45; // Posisi Belt

    // Konfigurasi Posisi
    // Posisi X untuk Sensor S, M, dan L
    final xS = cx - 100;
    final xM = cx;
    final xL = cx + 100;
    
    // Posisi Bins (Keranjang)
    final binY = cy + 120;

    // --- WARNA ---
    final beltColor = Colors.blueGrey[900]!;
    final binColor = Colors.brown[400]!;
    final shirtColor = Colors.blueAccent;
    final scannerBeamColor = Colors.redAccent.withOpacity(0.5);
    final indicatorSuccess = Colors.green;
    final indicatorFail = Colors.red;

    // --- 1. GAMBAR CONVEYOR BELT ---
    // Body Belt
    final beltRect = Rect.fromCenter(center: Offset(cx, cy), width: size.width, height: 20);
    canvas.drawRRect(RRect.fromRectAndRadius(beltRect, const Radius.circular(5)), Paint()..color = beltColor);
    
    // Roda/Gear Conveyor (Animasi Putar)
    // Pola garis pada belt yang bergerak ke kanan
    // activeStep + progress memberikan nilai waktu yang terus bertambah
    double moveOffset = ((activeStep + progress) * 50) % 20; 
    for (double i = -20; i < size.width + 20; i += 20) {
      double xPos = i + moveOffset;
      if (xPos > 0 && xPos < size.width) {
         canvas.drawLine(Offset(xPos, cy - 8), Offset(xPos, cy + 8), Paint()..color = Colors.white10..strokeWidth = 2);
      }
    }

    // --- 2. GAMBAR KERANJANG (BINS) ---
    _drawBin(canvas, Offset(xS, binY), "S", binColor);
    _drawBin(canvas, Offset(xM, binY), "M", binColor); // Target Bin
    _drawBin(canvas, Offset(xL, binY), "L", binColor);

    // --- 3. GAMBAR SENSOR/GATE ---
    _drawSensorGate(canvas, Offset(xS, cy - 20), "Size == S?");
    _drawSensorGate(canvas, Offset(xM, cy - 20), "Size == M?");
    _drawSensorGate(canvas, Offset(xL, cy - 20), "Size == L?");


    // --- 4. LOGIKA ANIMASI & POSISI BAJU ---
    String statusText = "";
    double shirtX = -50;
    double shirtY = cy - 45; // Di atas belt
    double shirtScale = 1.0;
    
    // Variable untuk efek scanner
    bool isScanning = false;
    Offset scanPos = Offset.zero;
    Color? indicatorColor;
    String indicatorIcon = "";

    if (activeStep == 0) { // MASUK -> MENUJU SENSOR S
      statusText = "Baju (Size M) Masuk";
      double startX = -60;
      double endX = xS;
      shirtX = startX + (progress * (endX - startX));
    } 
    else if (activeStep == 1) { // CEK SENSOR S (FALSE) -> MENUJU M
      statusText = "Cek: Size S? (FALSE)";
      // Gerak S -> M
      double startX = xS;
      double endX = xM;
      shirtX = startX + (progress * (endX - startX));
      
      // Di awal fase (0.0 - 0.3), tampilkan efek scan merah di S
      if (progress < 0.3) {
        shirtX = xS; // Tahan sebentar
        isScanning = true;
        scanPos = Offset(xS, cy - 60);
        indicatorColor = indicatorFail;
        indicatorIcon = "❌";
      }
    } 
    else if (activeStep == 2) { // CEK SENSOR M (TRUE) -> DIAM
      statusText = "Cek: Size M? (TRUE!)";
      shirtX = xM; // Berhenti di M
      
      // Tampilkan efek scan hijau
      isScanning = true;
      scanPos = Offset(xM, cy - 60);
      indicatorColor = indicatorSuccess;
      indicatorIcon = "✅";
      
      // Efek 'Jump' kegirangan karena cocok
      shirtY -= (math.sin(progress * math.pi) * 10).abs();
    } 
    else { // ACTION (JATUH KE BIN M)
      statusText = "Masuk Keranjang M";
      shirtX = xM;
      
      // Jatuh parabolik ke dalam bin
      double t = progress;
      shirtY = (cy - 45) + (t * (binY - (cy - 45))); // Linear Y
      // Sedikit geser X random biar natural (opsional), kita lurus aja biar rapi.
      
      // Scale down (masuk kedalam)
      shirtScale = 1.0 - (t * 0.5);
      
      // Fade out di akhir
      if (t > 0.8) {
         // Kita bisa mainkan opacity di method draw nanti
      }
    }

    // --- 5. RENDER OBJEK DINAMIS ---
    
    // A. Efek Scanner Laser (Jika sedang scan)
    if (isScanning) {
       // Sinar Laser (Segitiga terbalik transparan)
       final pathBeam = Path();
       pathBeam.moveTo(scanPos.dx, scanPos.dy); // Sumber sensor
       pathBeam.lineTo(scanPos.dx - 20, shirtY + 30); // Lebar bawah kiri
       pathBeam.lineTo(scanPos.dx + 20, shirtY + 30); // Lebar bawah kanan
       pathBeam.close();
       canvas.drawPath(pathBeam, Paint()..color = scannerBeamColor);
       
       // Indikator Icon (Centang/Silang)
       _drawIndicatorBubble(canvas, Offset(scanPos.dx, scanPos.dy - 30), indicatorIcon, indicatorColor!);
    }

    // B. Gambar Baju
    // Gunakan clipRect untuk menyembunyikan baju saat masuk bin (biar seolah masuk ke dalam)
    canvas.save();
    // Clip area di bawah binY agar baju 'hilang' saat masuk
    if (activeStep == 3) {
       canvas.clipRect(Rect.fromLTWH(0, 0, size.width, binY + 10)); 
    }
    
    canvas.translate(shirtX, shirtY);
    canvas.scale(shirtScale);
    _drawTShirt(canvas, shirtColor, "M");
    canvas.restore();

    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER DRAWING ---

  void _drawBin(Canvas canvas, Offset bottomCenter, String label, Color color) {
    // Gambar Bin (Trapesium terbalik)
    final pathBin = Path();
    double wTop = 70;
    double wBottom = 50;
    double h = 60;
    
    pathBin.moveTo(bottomCenter.dx - wTop/2, bottomCenter.dy - h); // Kiri Atas
    pathBin.lineTo(bottomCenter.dx + wTop/2, bottomCenter.dy - h); // Kanan Atas
    pathBin.lineTo(bottomCenter.dx + wBottom/2, bottomCenter.dy);  // Kanan Bawah
    pathBin.lineTo(bottomCenter.dx - wBottom/2, bottomCenter.dy);  // Kiri Bawah
    pathBin.close();

    canvas.drawPath(pathBin, Paint()..color = color);
    // Label Bin
    _drawText(canvas, Offset(bottomCenter.dx, bottomCenter.dy - h/2), label, Colors.white, 20, bold: true);
  }

  void _drawSensorGate(Canvas canvas, Offset pos, String label) {
    // Tiang Gantung
    canvas.drawLine(Offset(pos.dx, pos.dy - 60), Offset(pos.dx, pos.dy - 30), Paint()..color = Colors.grey[700]!..strokeWidth = 3);
    
    // Box Sensor
    final rectBox = Rect.fromCenter(center: Offset(pos.dx, pos.dy - 30), width: 40, height: 20);
    canvas.drawRRect(RRect.fromRectAndRadius(rectBox, const Radius.circular(4)), Paint()..color = Colors.black87);
    
    // Lensa Kamera
    canvas.drawCircle(Offset(pos.dx, pos.dy - 25), 4, Paint()..color = Colors.redAccent); // Mata merah standby

    // Label Kecil di atas sensor (Opsional, agar user tau ini gate apa)
    _drawText(canvas, Offset(pos.dx, pos.dy - 70), label, Colors.grey[600]!, 10);
  }

  void _drawTShirt(Canvas canvas, Color color, String sizeLabel) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    
    // Pola Kaos (Centered at 0,0)
    path.moveTo(-20, -25); // Bahu Kiri
    path.quadraticBezierTo(0, -15, 20, -25); // Leher
    path.lineTo(35, -15); // Lengan Kanan Atas
    path.lineTo(25, 0);   // Lengan Kanan Bawah
    path.lineTo(25, 30);  // Badan Kanan Bawah
    path.lineTo(-25, 30); // Badan Kiri Bawah
    path.lineTo(-25, 0);  // Lengan Kiri Bawah
    path.lineTo(-35, -15); // Lengan Kiri Atas
    path.close();

    // Shadow Kaos
    canvas.drawPath(path.shift(const Offset(2, 2)), Paint()..color = Colors.black26);
    // Body Kaos
    canvas.drawPath(path, paint);
    
    // Label Ukuran
    _drawText(canvas, const Offset(0, 0), sizeLabel, Colors.white, 16, bold: true);
  }

  void _drawIndicatorBubble(Canvas canvas, Offset center, String icon, Color color) {
    // Bubble Putih
    canvas.drawCircle(center, 14, Paint()..color = Colors.white);
    // Border Warna Status
    canvas.drawCircle(center, 14, Paint()..color = color..style=PaintingStyle.stroke..strokeWidth=2);
    // Icon Text
    _drawText(canvas, center, icon, Colors.black, 14);
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double fontSize, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 16);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant ElseIfSortingPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 8: BRANKAS BANK (MATERI 8 - LOGIKA AND)
// =============================================================================
class LogicAndVaultPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  LogicAndVaultPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55; // Posisikan brankas di tengah agak bawah

    // --- WARNA ---
    final metalDark = Colors.blueGrey[900]!;
    final metalLight = Colors.blueGrey[200]!;
    final metalMid = Colors.blueGrey[600]!;
    final ledOn = Colors.greenAccent[400]!;
    final ledOff = Colors.red[900]!;
    final goldBar = Colors.amber[700]!;
    final goldLight = Colors.amber[300]!;

    // --- 1. ISI BRANKAS (BACKGROUND) ---
    // Digambar paling bawah agar tertutup pintu nanti
    final safeSize = 220.0;
    
    // Ruang dalam brankas (Gelap)
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: safeSize - 20, height: safeSize - 20), Paint()..color = Colors.black);
    
    // Tumpukan Emas (Digambar jika pintu mulai terbuka di step 3)
    if (activeStep == 3) {
       _drawGoldBars(canvas, cx, cy + 40, 1.0); // Full visible
    }

    // --- 2. BINGKAI BRANKAS (FRAME LUAR) ---
    // Bingkai tebal
    final frameRect = Rect.fromCenter(center: Offset(cx, cy), width: safeSize, height: safeSize);
    canvas.drawRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(10)), Paint()..color = metalMid);
    // Detail baut di 4 sudut
    _drawBolts(canvas, frameRect);


    // --- 3. PINTU BRANKAS (ANIMASI BUKA) ---
    double openAngle = 0.0;
    double doorWidth = safeSize - 20;
    double doorX = cx;
    
    if (activeStep == 3) {
      // Animasi Pintu Membuka (Efek perspektif sederhana: lebar mengecil dan geser ke kiri)
      double t = progress; 
      doorWidth = (safeSize - 20) * (1.0 - (t * 0.8)); // Mengecil lebar
      // Geser pusat pintu ke kiri agar seolah berengsel di kiri
      double shift = ((safeSize - 20) - doorWidth) / 2;
      doorX = cx - shift;
    }

    if (doorWidth > 5) {
      // Daun Pintu
      final doorRect = Rect.fromCenter(center: Offset(doorX, cy), width: doorWidth, height: safeSize - 20);
      
      // Efek Metalic Gradient (Simulasi manual)
      final doorPaint = Paint()..shader = LinearGradient(
        colors: [metalLight, metalMid, metalDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(doorRect);
      
      canvas.drawRect(doorRect, doorPaint);
      
      // Garis detail pintu
      canvas.drawRect(
        Rect.fromCenter(center: doorRect.center, width: doorWidth * 0.8, height: (safeSize - 20) * 0.8),
        Paint()..style = PaintingStyle.stroke..color = Colors.black12..strokeWidth = 2
      );

      // --- 4. KOMPONEN PINTU (HANDLE & KUNCI) ---
      // Posisi komponen ikut bergeser dengan pintu
      double scaleX = doorWidth / (safeSize - 20); // Skala horizontal pintu
      
      // Handle Putar (Wheel)
      canvas.save();
      canvas.translate(doorX, cy + 20);
      canvas.scale(scaleX, 1.0); // Pipihkan sesuai perspektif pintu
      
      double spin = (activeStep == 3) ? (progress * math.pi) : 0; // Putar handle saat buka
      canvas.rotate(spin);
      _drawWheelHandle(canvas, 40, metalDark);
      canvas.restore();

      // Panel Kunci (Keypads)
      // Kunci A (Kiri Atas)
      _drawKeyPanel(canvas, Offset(doorX - (50 * scaleX), cy - 60), scaleX, "A", (activeStep >= 1), ledOn, ledOff);
      // Kunci B (Kanan Atas)
      _drawKeyPanel(canvas, Offset(doorX + (50 * scaleX), cy - 60), scaleX, "B", (activeStep >= 2), ledOn, ledOff);
    }

    // --- 5. ANIMASI KUNCI FISIK (INTERAKSI USER) ---
    // Menampilkan kunci melayang yang masuk ke lubang
    if (activeStep == 1 || activeStep == 2) {
       double keyProgress = progress;
       double targetX = (activeStep == 1) ? (cx - 50) : (cx + 50); // Posisi lubang A atau B
       // Jika pintu belum terbuka (doorWidth max), posisi target akurat.
       
       if (keyProgress < 1.0) {
          _drawFloatingKey(canvas, Offset(targetX, cy - 60), keyProgress);
       }
    }

    // --- 6. LOGIKA & STATUS ---
    String statusText = "";
    String logicText = "";
    
    if (activeStep == 0) {
      statusText = "Brankas Terkunci";
      logicText = "A (FALSE) && B (FALSE) = 🔒";
    } 
    else if (activeStep == 1) {
      statusText = "Kunci A Diputar";
      logicText = "A (TRUE) && B (FALSE) = 🔒";
    } 
    else if (activeStep == 2) {
      statusText = "Kunci B Diputar";
      logicText = "A (TRUE) && B (TRUE) = 🔓";
    } 
    else {
      statusText = "Akses Diterima!";
      logicText = "RESULT: TRUE -> OPEN";
    }

    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx, size.height - 40), logicText);
  }

  // --- HELPER DRAWING ---

  void _drawBolts(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Colors.blueGrey[800]!;
    double r = 4;
    double offset = 8;
    canvas.drawCircle(rect.topLeft + Offset(offset, offset), r, paint);
    canvas.drawCircle(rect.topRight + Offset(-offset, offset), r, paint);
    canvas.drawCircle(rect.bottomLeft + Offset(offset, -offset), r, paint);
    canvas.drawCircle(rect.bottomRight + Offset(-offset, -offset), r, paint);
  }

  void _drawWheelHandle(Canvas canvas, double radius, Color color) {
    // Lingkaran Luar
    canvas.drawCircle(Offset.zero, radius, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 8);
    // Jeruji (Spokes) - Cross shape
    canvas.drawLine(Offset(0, -radius), Offset(0, radius), Paint()..color = color..strokeWidth = 6..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset(-radius, 0), Offset(radius, 0), Paint()..color = color..strokeWidth = 6..strokeCap = StrokeCap.round);
    // Pusat
    canvas.drawCircle(Offset.zero, radius * 0.3, Paint()..color = color);
  }

  void _drawKeyPanel(Canvas canvas, Offset center, double scaleX, String label, bool isActive, Color onColor, Color offColor) {
    // Lampu LED
    canvas.drawCircle(
      Offset(center.dx, center.dy - 15), 
      5 * scaleX, 
      Paint()..color = isActive ? onColor : offColor
    );
    
    // Lubang Kunci
    canvas.drawCircle(center, 12 * scaleX, Paint()..color = Colors.black54);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 4 * scaleX, height: 14), 
      Paint()..color = Colors.black
    );

    // Label Huruf
    if (scaleX > 0.5) {
      TextPainter(
        text: TextSpan(text: label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14 * scaleX)),
        textDirection: TextDirection.ltr
      )..layout()..paint(canvas, Offset(center.dx + (15 * scaleX), center.dy - 7));
    }
  }

  void _drawFloatingKey(Canvas canvas, Offset targetPos, double progress) {
    // Animasi: Kunci muncul, masuk lubang, lalu putar
    double t = progress;
    // Posisi: dari bawah (target + 40) ke target
    double dy = targetPos.dy + (40 * (1 - t)); 
    if (t > 0.5) dy = targetPos.dy; // Sudah masuk lubang

    double rotation = 0;
    if (t > 0.5) {
       // Putar 90 derajat setelah masuk
       rotation = (t - 0.5) * 2 * (math.pi / 2);
    }

    canvas.save();
    canvas.translate(targetPos.dx, dy);
    canvas.rotate(rotation);

    // Gambar Kunci Gold
    final keyPaint = Paint()..color = Colors.amber;
    // Kepala Kunci
    canvas.drawCircle(Offset(0, 15), 10, keyPaint);
    // Batang Kunci
    canvas.drawRect(Rect.fromCenter(center: Offset(0, 0), width: 6, height: 20), keyPaint);
    // Gigi Kunci
    canvas.drawRect(Rect.fromLTWH(3, -5, 4, 4), keyPaint);
    canvas.drawRect(Rect.fromLTWH(3, 2, 4, 4), keyPaint);

    canvas.restore();
  }

  void _drawGoldBars(Canvas canvas, double cx, double cy, double opacity) {
    final barPaint = Paint()..color = Colors.amber[700]!.withOpacity(opacity);
    final shinePaint = Paint()..color = Colors.amber[300]!.withOpacity(opacity);

    // Gambar piramida emas (3 bawah, 2 tengah, 1 atas)
    double w = 40; double h = 15;
    
    // Baris Bawah
    _drawSingleBar(canvas, Offset(cx - 30, cy), w, h, barPaint, shinePaint);
    _drawSingleBar(canvas, Offset(cx + 30, cy), w, h, barPaint, shinePaint);
    _drawSingleBar(canvas, Offset(cx, cy), w, h, barPaint, shinePaint); // Tengah depan

    // Baris Tengah
    _drawSingleBar(canvas, Offset(cx - 15, cy - 15), w, h, barPaint, shinePaint);
    _drawSingleBar(canvas, Offset(cx + 15, cy - 15), w, h, barPaint, shinePaint);

    // Puncak
    _drawSingleBar(canvas, Offset(cx, cy - 30), w, h, barPaint, shinePaint);
    
    // Sparkles
    TextPainter(
      text: const TextSpan(text: "✨", style: TextStyle(fontSize: 24)), 
      textDirection: TextDirection.ltr
    )..layout()..paint(canvas, Offset(cx + 40, cy - 50));
  }

  void _drawSingleBar(Canvas canvas, Offset center, double w, double h, Paint base, Paint shine) {
    // Batang Emas Trapesium
    final path = Path();
    path.moveTo(center.dx - w/2 + 5, center.dy - h/2); // TopLeft
    path.lineTo(center.dx + w/2 - 5, center.dy - h/2); // TopRight
    path.lineTo(center.dx + w/2, center.dy + h/2);     // BotRight
    path.lineTo(center.dx - w/2, center.dy + h/2);     // BotLeft
    path.close();
    canvas.drawPath(path, base);
    // Kilau atas
    canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy - h/2 + 3), width: w - 15, height: 2), shine);
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white..style=PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.blueGrey..style=PaintingStyle.stroke..strokeWidth=2);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant LogicAndVaultPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 9: GERBANG PARALEL (MATERI 9 - LOGIKA OR)
// =============================================================================
class LogicOrGatePainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  LogicOrGatePainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;

    // --- WARNA ---
    final grassColor = Colors.green[200]!;
    final pathColor = Colors.brown[300]!; // Jalan tanah/paving
    final waterColor = Colors.blue[300]!;
    final wallColor = Colors.grey[800]!;
    final gateColor = Colors.brown[700]!;
    final pillarColor = Colors.grey[400]!;
    final personColor = Colors.indigo;

    // --- 1. GAMBAR LINGKUNGAN (TAMAN) ---
    // Rumput
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = grassColor);
    
    // Kolam Air di tengah (Pemisah jalur A dan B)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 50), width: 80, height: 60), Paint()..color = waterColor);

    // Jalan Setapak (Bercabang Y)
    final pathRoad = Path();
    // Start Bawah
    pathRoad.moveTo(cx - 30, size.height); 
    pathRoad.lineTo(cx + 30, size.height);
    // Pertigaan
    pathRoad.lineTo(cx + 30, cy + 120); 
    
    // Cabang Kanan (B)
    pathRoad.quadraticBezierTo(cx + 100, cy + 100, cx + 100, cy); // Outer Curve
    pathRoad.lineTo(cx + 60, cy); // Lebar jalan di gerbang
    pathRoad.quadraticBezierTo(cx + 60, cy + 80, cx, cy + 100); // Inner Curve
    
    // Cabang Kiri (A)
    pathRoad.lineTo(cx - 60, cy);
    pathRoad.quadraticBezierTo(cx - 60, cy + 80, cx - 30, cy + 120); // Inner Curve
    
    // Tutup jalan bawah
    pathRoad.close();
    
    canvas.drawPath(pathRoad, Paint()..color = pathColor);
    
    // Jalan di balik gerbang (Tujuan)
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, cy), Paint()..color = Colors.green[100]!); // Area dalam lebih terang


    // --- 2. GAMBAR TEMBOK & GERBANG ---
    // Tembok Besar Memanjang
    canvas.drawRect(Rect.fromLTWH(0, cy - 10, size.width, 20), Paint()..color = wallColor);

    // Gerbang A (Kiri)
    _drawGateStructure(canvas, Offset(cx - 80, cy), "Jalur A", (activeStep == 1 || activeStep == 3), gateColor, pillarColor);
    
    // Gerbang B (Kanan)
    _drawGateStructure(canvas, Offset(cx + 80, cy), "Jalur B", (activeStep == 2 || activeStep == 3), gateColor, pillarColor);


    // --- 3. LOGIKA ANIMASI ORANG ---
    String statusText = "";
    String logicText = "";
    Offset personPos = Offset(cx, size.height + 20); // Mulai di luar layar bawah
    double personScale = 1.0;

    if (activeStep == 0) { // PILIH JALUR
      statusText = "Pilih Jalur A atau B";
      logicText = "A || B (Disjunction)";
      // Orang jalan masuk ke pertigaan
      double startY = size.height + 20;
      double endY = cy + 140;
      personPos = Offset(cx, startY - (progress * (startY - endY)));
    } 
    else if (activeStep == 1) { // LEWAT KIRI (A)
      statusText = "Lewat Jalur A";
      logicText = "A (TRUE) || B (FALSE) -> TRUE";
      
      // Kurva Bezier untuk jalan ke kiri
      double t = progress;
      // P0 = Pertigaan (cx, cy+140)
      // P1 = Control Point (cx-80, cy+100)
      // P2 = Gerbang A (cx-80, cy)
      // P3 = Dalam (cx-80, cy-50)
      
      double p0x = cx; double p0y = cy + 140;
      double p1x = cx - 80; double p1y = cy + 80;
      double p2x = cx - 80; double p2y = cy;
      
      // Interpolasi Bezier Quadratic (Sampai gerbang)
      double bx = (1-t)*(1-t)*p0x + 2*(1-t)*t*p1x + t*t*p2x;
      double by = (1-t)*(1-t)*p0y + 2*(1-t)*t*p1y + t*t*p2y;
      
      // Jika progress > 0.8 (sudah dekat gerbang), jalan lurus masuk
      if (t > 0.8) {
         by -= (t - 0.8) * 100; // Masuk ke dalam
         personScale = 1.0 - ((t - 0.8) * 2); // Mengecil masuk
      }
      personPos = Offset(bx, by);
    } 
    else if (activeStep == 2) { // LEWAT KANAN (B)
      statusText = "Lewat Jalur B";
      logicText = "A (FALSE) || B (TRUE) -> TRUE";
      
      double t = progress;
      double p0x = cx; double p0y = cy + 140;
      double p1x = cx + 80; double p1y = cy + 80;
      double p2x = cx + 80; double p2y = cy;
      
      double bx = (1-t)*(1-t)*p0x + 2*(1-t)*t*p1x + t*t*p2x;
      double by = (1-t)*(1-t)*p0y + 2*(1-t)*t*p1y + t*t*p2y;
      
      if (t > 0.8) {
         by -= (t - 0.8) * 100; 
         personScale = 1.0 - ((t - 0.8) * 2); 
      }
      personPos = Offset(bx, by);
    } 
    else { // SUKSES (DI DALAM)
      statusText = "Berhasil Masuk!";
      logicText = "Salah satu terbuka = SUKSES";
      // Orang di tengah dalam (happy)
      personPos = Offset(cx, cy - 80);
      personScale = 0.8;
      // Lompat kegirangan
      double jump = (math.sin(progress * 15).abs() * 10);
      personPos = Offset(personPos.dx, personPos.dy - jump);
    }

    // Gambar Orang (Stickman)
    if (personScale > 0.1) {
       _drawStickman(canvas, personPos, personScale, personColor);
    }

    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx, size.height - 40), logicText);
  }

  // --- HELPER DRAWING ---

  void _drawGateStructure(Canvas canvas, Offset center, String label, bool isOpen, Color gateColor, Color pillarColor) {
    double w = 60; // Lebar total gerbang
    double h = 60; // Tinggi gerbang
    
    // Pilar Kiri & Kanan
    canvas.drawRect(Rect.fromCenter(center: Offset(center.dx - w/2 - 5, center.dy - h/2), width: 10, height: h + 10), Paint()..color = pillarColor);
    canvas.drawRect(Rect.fromCenter(center: Offset(center.dx + w/2 + 5, center.dy - h/2), width: 10, height: h + 10), Paint()..color = pillarColor);
    // Atap Pilar (Bola hiasan)
    canvas.drawCircle(Offset(center.dx - w/2 - 5, center.dy - h - 5), 8, Paint()..color = pillarColor);
    canvas.drawCircle(Offset(center.dx + w/2 + 5, center.dy - h - 5), 8, Paint()..color = pillarColor);

    // Daun Pintu
    if (!isOpen) {
      // Pintu Tertutup (Kayu solid)
      canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy - h/2), width: w, height: h), Paint()..color = gateColor);
      // Detail garis kayu
      for(double i = -w/2 + 10; i < w/2; i+=10) {
         canvas.drawLine(Offset(center.dx + i, center.dy), Offset(center.dx + i, center.dy - h), Paint()..color = Colors.black12);
      }
      // Gembok Merah
      canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy - h/2), width: 10, height: 14), Paint()..color = Colors.red);
    } else {
      // Pintu Terbuka (Mengecil di samping seolah membuka ke dalam)
      // Kiri
      canvas.drawRect(Rect.fromLTWH(center.dx - w/2, center.dy - h, 10, h), Paint()..color = gateColor);
      // Kanan
      canvas.drawRect(Rect.fromLTWH(center.dx + w/2 - 10, center.dy - h, 10, h), Paint()..color = gateColor);
    }

    // Label
    _drawText(canvas, Offset(center.dx, center.dy + 20), label, Colors.black87, 12, bold: true);
  }

  void _drawStickman(Canvas canvas, Offset pos, double scale, Color color) {
    final paint = Paint()..color = color..strokeWidth = 3 * scale..strokeCap = StrokeCap.round;
    
    // Kaki (Pusat pos di kaki)
    canvas.drawLine(pos, Offset(pos.dx - 5 * scale, pos.dy - 15 * scale), paint); // Kiri
    canvas.drawLine(pos, Offset(pos.dx + 5 * scale, pos.dy - 15 * scale), paint); // Kanan
    
    // Badan
    canvas.drawLine(Offset(pos.dx, pos.dy - 15 * scale), Offset(pos.dx, pos.dy - 35 * scale), paint);
    
    // Tangan
    canvas.drawLine(Offset(pos.dx, pos.dy - 30 * scale), Offset(pos.dx - 10 * scale, pos.dy - 20 * scale), paint);
    canvas.drawLine(Offset(pos.dx, pos.dy - 30 * scale), Offset(pos.dx + 10 * scale, pos.dy - 20 * scale), paint);
    
    // Kepala
    canvas.drawCircle(Offset(pos.dx, pos.dy - 40 * scale), 6 * scale, Paint()..color = color);
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white..style=PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.blueGrey..style=PaintingStyle.stroke..strokeWidth=2);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double fontSize, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant LogicOrGatePainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 10: PEMERIKSAAN BERTINGKAT (MATERI 10 - NESTED IF)
// =============================================================================
class NestedCheckPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  NestedCheckPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    
    // --- KONFIGURASI POSISI (PERSPEKTIF) ---
    // Gate 1 (Outer) - Paling Dekat
    final yGate1 = size.height * 0.75; 
    // Gate 2 (Inner) - Lebih Jauh
    final yGate2 = size.height * 0.45; 
    // Pesawat (Goal) - Paling Jauh
    final yPlane = size.height * 0.15; 

    // Warna
    final floorColor = Colors.blueGrey[50]!;
    final wallColor = Colors.blueGrey[100]!;
    final gate1Color = Colors.indigo[400]!;
    final gate2Color = Colors.purple[400]!;
    final personColor = Colors.orange[800]!;
    final scannerBeamColor = Colors.redAccent.withOpacity(0.4);

    // --- 1. GAMBAR LINGKUNGAN (KORIDOR BANDARA) ---
    // Dinding Kiri & Kanan (Trapesium Perspektif)
    final pathWalls = Path();
    pathWalls.moveTo(0, size.height); // Kiri Bawah
    pathWalls.lineTo(cx - 40, yPlane); // Kiri Atas (Horizon)
    pathWalls.lineTo(cx + 40, yPlane); // Kanan Atas
    pathWalls.lineTo(size.width, size.height); // Kanan Bawah
    pathWalls.close();
    canvas.drawPath(pathWalls, Paint()..color = wallColor);

    // Lantai (Trapesium Tengah)
    final pathFloor = Path();
    pathFloor.moveTo(0, size.height);
    pathFloor.lineTo(size.width, size.height);
    pathFloor.lineTo(cx + 40, yPlane); // Horizon Kanan
    pathFloor.lineTo(cx - 40, yPlane); // Horizon Kiri
    pathFloor.close();
    canvas.drawPath(pathFloor, Paint()..color = floorColor);
    
    // Garis Panduan Lantai (Perspektif)
    canvas.drawLine(Offset(cx, size.height), Offset(cx, yPlane), Paint()..color = Colors.white30..strokeWidth = 2);

    // Zona Tujuan (Jendela Pesawat)
    // Gambar Jendela Besar di ujung
    final windowRect = Rect.fromCenter(center: Offset(cx, yPlane - 20), width: 120, height: 80);
    canvas.drawRRect(RRect.fromRectAndRadius(windowRect, const Radius.circular(10)), Paint()..color = Colors.lightBlueAccent);
    // Awan
    _drawCloud(canvas, Offset(cx - 20, yPlane - 30));
    _drawCloud(canvas, Offset(cx + 30, yPlane - 10));


    // --- 2. LOGIKA ANIMASI ORANG ---
    String statusText = "";
    String logicText = "";
    
    double gate1Open = 0.0;
    double gate2Open = 0.0;
    
    // Posisi Orang
    double personY = size.height + 50; // Mulai di luar layar bawah
    double personScale = 1.0; // Skala normal
    
    // Scanner Effect
    bool isScanning = false;
    double scanLineY = 0;

    if (activeStep == 0) { // DATANG KE GATE 1
      statusText = "Cek Tiket (Outer IF)";
      logicText = "Tiket Valid?";
      // Jalan mendekati Gate 1
      double startY = size.height + 40;
      double endY = yGate1 + 40;
      personY = startY - (progress * (startY - endY));
      personScale = 1.2 - (progress * 0.2); // Mengecil sedikit
    } 
    else if (activeStep == 1) { // LEWAT GATE 1 -> MENUJU GATE 2
      statusText = "Tiket OK -> Masuk Inner";
      logicText = "TRUE: Lanjut ke X-Ray";
      gate1Open = 1.0; 
      
      // Jalan dari Gate 1 ke Gate 2
      double startY = yGate1 + 40;
      double endY = yGate2 + 30; // Berhenti di depan gate 2
      personY = startY - (progress * (startY - endY));
      personScale = 1.0 - (progress * 0.3); // Mengecil perspektif
    } 
    else if (activeStep == 2) { // DI GATE 2 (SCANNING)
      statusText = "Cek Keamanan (Inner IF)";
      logicText = "Aman? (Scanning...)";
      gate1Open = 1.0; // Gate 1 tetap buka
      personY = yGate2 + 30;
      personScale = 0.7; // Ukuran kecil karena jauh
      
      // Efek Scanner
      isScanning = true;
      // Scan line bergerak naik turun di sekitar orang
      scanLineY = (personY - 40) + (progress * 80); 
      if (scanLineY > personY + 10) scanLineY = personY - 40; // Loop sederhana
    } 
    else { // LOLOS -> KE PESAWAT
      statusText = "Lolos Semua! Terbang ✈️";
      logicText = "Sukses Masuk Pesawat";
      gate1Open = 1.0;
      gate2Open = 1.0;
      
      // Jalan dari Gate 2 ke Pesawat
      double startY = yGate2 + 30;
      double endY = yPlane;
      personY = startY - (progress * (startY - endY));
      personScale = 0.7 - (progress * 0.4); // Mengecil drastis (jauh)
      
      // Pesawat terbang di jendela (Animasi tambahan)
      if (progress > 0.5) {
         _drawPlaneIcon(canvas, Offset(cx + (progress * 100) - 50, yPlane - 20));
      }
    }

    // --- 3. GAMBAR GERBANG (LAYERED) ---
    // Gambar dari yang terjauh (Gate 2) ke terdekat (Gate 1) agar tumpukan benar
    
    // GAMBAR GATE 2 (INNER - XRAY)
    _drawGateStructure(canvas, Offset(cx, yGate2), "X-RAY", gate2Color, gate2Open, 0.7);

    // GAMBAR ORANG (Tergantung posisi Z)
    // Jika orang sudah melewati Gate 1 (Step > 0), gambar orang DI ANTARA Gate 1 dan 2
    // Atau jika Step > 2, gambar orang di belakang Gate 2.
    // Untuk simplifikasi 2D Painter, kita gambar orang di sini jika dia BERADA DI BELAKANG Gate 1
    
    // Scanner Effect (Di depan Gate 2, di belakang Gate 1)
    if (isScanning) {
       // Sinar Scanner (Segitiga terbalik dari atas gate)
       final beamPath = Path();
       beamPath.moveTo(cx, yGate2 - 60); // Sumber sinar di atap gate
       beamPath.lineTo(cx - 30, personY + 10);
       beamPath.lineTo(cx + 30, personY + 10);
       beamPath.close();
       canvas.drawPath(beamPath, Paint()..color = scannerBeamColor);
       
       // Garis Scan
       canvas.drawLine(Offset(cx - 25, scanLineY), Offset(cx + 25, scanLineY), Paint()..color = Colors.red..strokeWidth = 2);
    }

    // Gambar Orang
    _drawStickman(canvas, Offset(cx, personY), personScale, personColor);

    // GAMBAR GATE 1 (OUTER - TIKET) - Paling Depan
    // Kita gambar ini terakhir agar menutupi objek di belakangnya
    _drawGateStructure(canvas, Offset(cx, yGate1), "TIKET", gate1Color, gate1Open, 1.0);


    // --- 4. LABEL & STATUS ---
    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx, size.height - 40), logicText);
  }

  // --- HELPER DRAWING ---

  void _drawGateStructure(Canvas canvas, Offset center, String label, Color color, double openFactor, double scale) {
    // Ukuran dasar gerbang (sebelum diskala)
    double w = 140 * scale;
    double h = 100 * scale;
    double pillarW = 15 * scale;
    
    // Pilar Kiri & Kanan
    final pLeft = Rect.fromCenter(center: Offset(center.dx - w/2, center.dy - h/2), width: pillarW, height: h);
    final pRight = Rect.fromCenter(center: Offset(center.dx + w/2, center.dy - h/2), width: pillarW, height: h);
    
    // Atap Gerbang (Box Sensor)
    final pTop = Rect.fromCenter(center: Offset(center.dx, center.dy - h), width: w + pillarW, height: 20 * scale);

    Paint paintStructure = Paint()..color = Colors.grey[800]!;
    canvas.drawRect(pLeft, paintStructure);
    canvas.drawRect(pRight, paintStructure);
    canvas.drawRect(pTop, paintStructure);

    // Pintu Geser Kaca
    // openFactor 0 = Tertutup, 1 = Terbuka
    double doorW = (w / 2) - (5 * scale); // Lebar satu daun pintu
    double slide = doorW * openFactor; // Pergeseran
    
    final paintGlass = Paint()..color = color.withOpacity(0.5);
    final paintFrame = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2 * scale;

    // Pintu Kiri (Geser ke kiri)
    Rect dLeft = Rect.fromLTWH(center.dx - doorW - slide, center.dy - h, doorW, h);
    canvas.drawRect(dLeft, paintGlass);
    canvas.drawRect(dLeft, paintFrame);

    // Pintu Kanan (Geser ke kanan)
    Rect dRight = Rect.fromLTWH(center.dx + slide, center.dy - h, doorW, h);
    canvas.drawRect(dRight, paintGlass);
    canvas.drawRect(dRight, paintFrame);

    // Lampu Indikator
    Color ledColor = (openFactor > 0.5) ? Colors.greenAccent : Colors.redAccent;
    canvas.drawCircle(Offset(center.dx, center.dy - h), 4 * scale, Paint()..color = ledColor);

    // Label di Atap
    _drawText(canvas, Offset(center.dx, center.dy - h - (15 * scale)), label, Colors.grey[700]!, 12 * scale, bold: true);
  }

  void _drawStickman(Canvas canvas, Offset footPos, double scale, Color color) {
    if (scale < 0.1) return;
    final paint = Paint()..color = color..strokeWidth = 3 * scale..strokeCap = StrokeCap.round;
    
    // Tinggi badan relatif
    double legLen = 20 * scale;
    double bodyLen = 25 * scale;
    double headSize = 8 * scale;

    // Kaki
    canvas.drawLine(footPos, Offset(footPos.dx - 5 * scale, footPos.dy - legLen), paint); // Kiri
    canvas.drawLine(footPos, Offset(footPos.dx + 5 * scale, footPos.dy - legLen), paint); // Kanan
    
    // Badan (Hip to Neck)
    Offset hip = Offset(footPos.dx, footPos.dy - legLen);
    Offset neck = Offset(footPos.dx, footPos.dy - legLen - bodyLen);
    canvas.drawLine(hip, neck, paint);
    
    // Tangan
    canvas.drawLine(Offset(neck.dx, neck.dy + 5 * scale), Offset(footPos.dx - 10 * scale, neck.dy + 15 * scale), paint);
    canvas.drawLine(Offset(neck.dx, neck.dy + 5 * scale), Offset(footPos.dx + 10 * scale, neck.dy + 15 * scale), paint);
    
    // Kepala
    canvas.drawCircle(Offset(neck.dx, neck.dy - headSize), headSize, paint);
  }

  void _drawCloud(Canvas canvas, Offset center) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);
    canvas.drawCircle(center, 10, paint);
    canvas.drawCircle(Offset(center.dx - 8, center.dy + 2), 8, paint);
    canvas.drawCircle(Offset(center.dx + 8, center.dy + 2), 8, paint);
  }

  void _drawPlaneIcon(Canvas canvas, Offset center) {
    final paint = Paint()..color = Colors.white;
    // Gambar pesawat sederhana
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx - 10, center.dy + 5); // Sayap kiri
    path.lineTo(center.dx + 15, center.dy);     // Moncong
    path.lineTo(center.dx - 10, center.dy - 5); // Sayap kanan
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white..style=PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.blueGrey..style=PaintingStyle.stroke..strokeWidth=2);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double fontSize, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant NestedCheckPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 11: KONSEP LOOP (MATERI 11 - PENGENALAN)
// =============================================================================
class LoopIntroPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  LoopIntroPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.6; // Pusat lintasan

    // --- WARNA ---
    final grassColor = Colors.green[300]!;
    final trackColor = Colors.red[800]!; // Warna lintasan lari merah bata
    final trackLineColor = Colors.white.withOpacity(0.5);
    final runnerColor = Colors.orange[800]!;
    final finishLineColor = Colors.white;
    
    // --- 1. GAMBAR STADION / LINTASAN ---
    final trackRect = Rect.fromCenter(center: Offset(cx, cy), width: 280, height: 160);
    final grassRect = Rect.fromCenter(center: Offset(cx, cy), width: 180, height: 60);

    // Lapisan Rumput Luar (Background)
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.green[100]!);

    // Lintasan Lari (Stadium Shape / Rounded Rect)
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(80)), 
      Paint()..color = trackColor
    );
    
    // Garis Jalur (Lanes)
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect.deflate(25), const Radius.circular(55)), 
      Paint()..style=PaintingStyle.stroke..color=trackLineColor..strokeWidth=2
    );

    // Rumput Tengah
    canvas.drawRRect(
      RRect.fromRectAndRadius(grassRect, const Radius.circular(30)), 
      Paint()..color = grassColor
    );

    // Garis Finish (Di sisi kanan)
    final finishX = cx + 90; // Posisi X garis finish (di bagian lurus atau kurva)
    // Agar rapi, garis finish di bagian kurva kanan tengah
    canvas.drawLine(Offset(finishX + 35, cy), Offset(finishX + 50 + 35, cy), Paint()..color = finishLineColor..strokeWidth = 6);
    // Pola kotak-kotak finish line (Checkerboard simple)
    _drawCheckerboard(canvas, Offset(finishX + 42, cy), 15, 40);


    // --- 2. LOGIKA ANIMASI PELARI ---
    String statusText = "";
    double angle = 0.0; 
    
    // Path untuk pergerakan pelari (Mengikuti garis tengah lintasan)
    final pathRun = Path();
    pathRun.addRRect(RRect.fromRectAndRadius(trackRect.deflate(25), const Radius.circular(55)));
    
    // Hitung posisi pelari berdasarkan progress
    // Kita gunakan PathMetric untuk mendapatkan koordinat X,Y dan Rotasi yang akurat di sepanjang jalur oval
    // Namun, untuk simplifikasi tanpa import dart:ui (sesuai request), kita pakai rumus parametrik Oval/RoundedRect manual.
    // ATAU: Kita gunakan elips sederhana untuk gerakan pelari agar kode lebih ringkas.
    
    // Aproksimasi gerakan: Oval
    double runW = 230.0 / 2; // Radius X
    double runH = 110.0 / 2; // Radius Y
    
    double runnerX = 0;
    double runnerY = 0;
    double runnerAngle = 0;

    if (activeStep == 0) { // SIAP
      statusText = "Siap Lari (Lap: 0)";
      // Posisi di garis finish (Kanan, 0 derajat)
      runnerX = cx + runW;
      runnerY = cy;
      runnerAngle = math.pi / 2; // Menghadap bawah
    } 
    else if (activeStep == 1) { // LARI
      statusText = "Sedang Berlari...";
      // Sudut putaran (Mulai dari 0 di kanan, bergerak searah jarum jam)
      double t = progress * 2 * math.pi; // 0 to 2PI
      
      runnerX = cx + runW * math.cos(t);
      runnerY = cy + runH * math.sin(t);
      
      // Hitung orientasi (tangen)
      // dx = -sin(t), dy = cos(t) -> atan2(dy, dx)
      runnerAngle = math.atan2(runH * math.cos(t), -runW * math.sin(t));
    } 
    else if (activeStep == 2) { // SELESAI SATU PUTARAN
      statusText = "Satu Putaran Selesai!";
      runnerX = cx + runW;
      runnerY = cy;
      runnerAngle = math.pi / 2;
    } 
    else { // ULANGI
      statusText = "Ulangi Lagi? (YA)";
      runnerX = cx + runW;
      runnerY = cy;
      runnerAngle = math.pi / 2;
      
      // Animasi Simbol Loop
      _drawLoopSymbol(canvas, Offset(cx, cy), progress);
    }

    // --- 3. GAMBAR PELARI (TOP DOWN VIEW) ---
    _drawRunner(canvas, Offset(runnerX, runnerY), runnerAngle, runnerColor);

    // --- 4. PAPAN SKOR ---
    _drawScoreboard(canvas, Offset(cx, cy - 120), activeStep, progress);

    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER DRAWING ---

  void _drawRunner(Canvas canvas, Offset pos, double angle, Color color) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle); // Putar sesuai arah lari

    // Kepala
    canvas.drawCircle(Offset.zero, 8, Paint()..color = color);
    // Bahu
    canvas.drawOval(Rect.fromCenter(center: const Offset(0, 0), width: 22, height: 10), Paint()..color = color);
    // Tangan (Ayun)
    canvas.drawCircle(const Offset(-10, 5), 4, Paint()..color = Colors.black26);
    canvas.drawCircle(const Offset(10, -5), 4, Paint()..color = Colors.black26);

    canvas.restore();
  }

  void _drawCheckerboard(Canvas canvas, Offset center, double w, double h) {
    // Gambar pola kotak hitam putih kecil
    double boxSize = 5;
    for (double i = -w/2; i < w/2; i+=boxSize) {
      for (double j = -h/2; j < h/2; j+=boxSize) {
        if (((i/boxSize).round() + (j/boxSize).round()) % 2 == 0) {
           canvas.drawRect(Rect.fromLTWH(center.dx + i, center.dy + j, boxSize, boxSize), Paint()..color = Colors.black);
        } else {
           canvas.drawRect(Rect.fromLTWH(center.dx + i, center.dy + j, boxSize, boxSize), Paint()..color = Colors.white);
        }
      }
    }
  }

  void _drawScoreboard(Canvas canvas, Offset center, int step, double progress) {
    // Frame Papan
    final rect = Rect.fromCenter(center: center, width: 120, height: 50);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), Paint()..color = Colors.black87);
    canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(2), const Radius.circular(6)), Paint()..color = Colors.grey[800]!);

    // Angka Digital
    String score = "00";
    Color digitColor = Colors.redAccent;
    
    if (step >= 2) {
      score = "01"; 
      digitColor = Colors.greenAccent;
      // Efek Blink saat nambah
      if (step == 2 && (progress * 10).toInt() % 2 == 0) {
         digitColor = Colors.white;
      }
    }

    final tp = TextPainter(
      text: TextSpan(text: score, style: TextStyle(color: digitColor, fontSize: 30, fontFamily: 'monospace', fontWeight: FontWeight.bold)), 
      textDirection: TextDirection.ltr
    )..layout();
    
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
    
    // Label "LAP"
    final tpLabel = TextPainter(text: const TextSpan(text: "LAP", style: TextStyle(color: Colors.grey, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tpLabel.paint(canvas, Offset(center.dx - tpLabel.width/2, center.dy - 20));
  }

  void _drawLoopSymbol(Canvas canvas, Offset center, double progress) {
    // Ikon Panah Berputar di tengah lapangan
    final paint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 5..strokeCap = StrokeCap.round;
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * -2 * math.pi); // Putar berlawanan arah jarum jam (Reset)

    // Panah Atas
    canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: 20), 0, 1.5 * math.pi, false, paint);
    canvas.drawLine(const Offset(20, 0), const Offset(15, 10), paint); // Arrowhead
    canvas.drawLine(const Offset(20, 0), const Offset(25, 10), paint);

    canvas.restore();
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    
    // Shadow
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect.translate(2, 2), const Radius.circular(20)), Paint()..color = Colors.black26);
    // Body
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.orange[800]!);
    
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant LoopIntroPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 12: FOR LOOP (MATERI 12 - PENGULANGAN TERHITUNG)
// =============================================================================
class ForLoopPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  ForLoopPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.6; // Pusat lintasan
    
    // --- UKURAN & WARNA ---
    final radiusX = 130.0;
    final radiusY = 80.0;
    
    final trackColor = Colors.grey[800]!;
    final trackFill = Colors.grey[300]!;
    
    // [PERBAIKAN] Nama variabel disamakan
    final activeTrackColor = Colors.orangeAccent; 
    
    final runnerColor = Colors.blue[600]!;
    
    // --- 1. GAMBAR LINTASAN (BASE) ---
    final trackRect = Rect.fromCenter(center: Offset(cx, cy), width: radiusX * 2, height: radiusY * 2);
    
    // Background Rumput
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.green[50]!);

    // Lintasan (Stroke Tebal)
    canvas.drawOval(trackRect, Paint()..color = trackFill..style = PaintingStyle.stroke..strokeWidth = 35);
    // Garis Pinggir Lintasan
    canvas.drawOval(trackRect.inflate(18), Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawOval(trackRect.deflate(18), Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = 2);

    // Garis Finish (Di Kanan, 0 derajat)
    final finishX = cx + radiusX;
    _drawCheckerboard(canvas, Offset(finishX, cy), 20, 35);
    _drawText(canvas, Offset(finishX, cy + 30), "START/FINISH", Colors.grey[600]!, 10, bold: true);


    // --- 2. LOGIKA LOOP & ANIMASI ---
    String statusText = "";
    int iVal = 1;
    String conditionText = "";
    double runnerAngle = 0.0; // 0 radian = Kanan
    bool isRunning = false;
    String lapText = "";

    // Step 0: Init (i=1)
    if (activeStep == 0) {
      statusText = "Inisialisasi: int i = 1";
      iVal = 1;
      conditionText = "Siap...";
      runnerAngle = 0;
    } 
    // Step 1: Loop 1 (i=1)
    else if (activeStep == 1) {
      statusText = "Loop Pertama (i=1)";
      iVal = 1;
      conditionText = "1 <= 3 ? TRUE";
      isRunning = true;
      lapText = "Putaran 1";
      // Bergerak 0 -> 2PI
      runnerAngle = progress * 2 * math.pi;
    } 
    // Step 2: Loop 2 (i=2)
    else if (activeStep == 2) {
      statusText = "Loop Kedua (i=2)";
      iVal = 2;
      conditionText = "2 <= 3 ? TRUE";
      isRunning = true;
      lapText = "Putaran 2";
      runnerAngle = progress * 2 * math.pi;
    } 
    // Step 3: Loop 3 (i=3)
    else if (activeStep == 3) {
      statusText = "Loop Ketiga (i=3)";
      iVal = 3;
      conditionText = "3 <= 3 ? TRUE";
      isRunning = true;
      lapText = "Putaran 3";
      runnerAngle = progress * 2 * math.pi;
    } 
    // Step 4: Selesai (i=4)
    else {
      statusText = "Loop Berhenti!";
      iVal = 4;
      conditionText = "4 <= 3 ? FALSE";
      isRunning = false;
      lapText = "Selesai";
      runnerAngle = 0; // Berhenti di garis finish
    }

    // --- 3. GAMBAR JEJAK (TRAIL) ---
    if (isRunning) {
      // Menggambar busur (arc) sepanjang progress lari
      canvas.save();
      canvas.translate(cx, cy);
      canvas.scale(1.0, radiusY / radiusX); // Pipihkan Y agar jadi oval
      
      // Rect untuk arc lingkaran (radius = radiusX)
      Rect circleRect = Rect.fromCircle(center: Offset.zero, radius: radiusX);
      
      // [PERBAIKAN] Menggunakan variabel yang sudah benar
      canvas.drawArc(circleRect, 0, runnerAngle, false, Paint()..color = activeTrackColor.withOpacity(0.5)..style=PaintingStyle.stroke..strokeWidth=35);
      
      canvas.restore();
    }

    // --- 4. GAMBAR PELARI ---
    // Hitung posisi pelari di lintasan oval: x = a cos t, y = b sin t
    double rX = cx + radiusX * math.cos(runnerAngle);
    double rY = cy + radiusY * math.sin(runnerAngle);

    _drawRunner(canvas, Offset(rX, rY), runnerColor, isRunning, progress);

    // Label Lap di Tengah Lapangan
    if (lapText.isNotEmpty) {
       _drawText(canvas, Offset(cx, cy), lapText, Colors.black26, 24, bold: true);
    }


    // --- 5. DASHBOARD VARIABEL ---
    _drawDashboard(canvas, Offset(cx, size.height * 0.15), iVal, conditionText, (activeStep == 4));

    // Label Status Bawah
    _drawLabelBubble(canvas, Offset(cx, size.height - 40), statusText);
  }

  // --- HELPER DRAWING ---

  void _drawRunner(Canvas canvas, Offset pos, Color color, bool isRunning, double progress) {
    // Bayangan
    canvas.drawOval(Rect.fromCenter(center: pos + const Offset(0, 10), width: 20, height: 10), Paint()..color = Colors.black26);

    // Kaki (Gerak naik turun)
    double bounce = isRunning ? (math.sin(progress * 20 * math.pi).abs() * 5) : 0;
    
    // Kepala
    canvas.drawCircle(Offset(pos.dx, pos.dy - 15 - bounce), 8, Paint()..color = color);
    // Badan
    canvas.drawRect(Rect.fromCenter(center: Offset(pos.dx, pos.dy - bounce), width: 12, height: 16), Paint()..color = color);
    
    // Tangan (Simple)
    canvas.drawCircle(Offset(pos.dx - 8, pos.dy - 5 - bounce), 3, Paint()..color = Colors.black38);
    canvas.drawCircle(Offset(pos.dx + 8, pos.dy - 5 - bounce), 3, Paint()..color = Colors.black38);
  }

  void _drawDashboard(Canvas canvas, Offset center, int iVal, String condition, bool isStop) {
    double w = 240;
    double h = 80;
    
    // Panel Background
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(15)), Paint()..color = Colors.blueGrey[900]!);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(15)), Paint()..color = Colors.white24..style=PaintingStyle.stroke..strokeWidth=2);

    // Kotak Nilai i (Kiri)
    _drawVarBox(canvas, Offset(center.dx - 60, center.dy), "i", "$iVal", Colors.amberAccent);
    
    // Pemisah Vertikal
    canvas.drawLine(Offset(center.dx, center.dy - 30), Offset(center.dx, center.dy + 30), Paint()..color = Colors.white24);

    // Kondisi (Kanan)
    Color condColor = isStop ? Colors.redAccent : Colors.greenAccent;
    String condLabel = isStop ? "FALSE" : "TRUE";
    
    // Teks Kondisi
    _drawText(canvas, Offset(center.dx + 60, center.dy - 10), condition, Colors.white, 14);
    // Hasil TRUE/FALSE
    _drawText(canvas, Offset(center.dx + 60, center.dy + 15), condLabel, condColor, 18, bold: true);
  }

  void _drawVarBox(Canvas canvas, Offset center, String label, String val, Color color) {
    _drawText(canvas, Offset(center.dx - 20, center.dy), "$label =", Colors.white, 20, bold: true);
    // Kotak Angka
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(center.dx + 25, center.dy), width: 40, height: 40), const Radius.circular(8)), 
      Paint()..color = Colors.white10
    );
    _drawText(canvas, Offset(center.dx + 25, center.dy), val, color, 24, bold: true);
  }

  void _drawCheckerboard(Canvas canvas, Offset center, double w, double h) {
    double boxSize = 5;
    for (double i = -w/2; i < w/2; i+=boxSize) {
      for (double j = -h/2; j < h/2; j+=boxSize) {
        if (((i/boxSize).round() + (j/boxSize).round()) % 2 == 0) {
           canvas.drawRect(Rect.fromLTWH(center.dx + i, center.dy + j, boxSize, boxSize), Paint()..color = Colors.black);
        } else {
           canvas.drawRect(Rect.fromLTWH(center.dx + i, center.dy + j, boxSize, boxSize), Paint()..color = Colors.white);
        }
      }
    }
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double size, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontFamily: 'monospace')),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  void _drawLabelBubble(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), 
      textDirection: TextDirection.ltr
    )..layout();
    
    final bubbleRect = Rect.fromCenter(center: center, width: textPainter.width + 30, height: textPainter.height + 16);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.blue[800]!);
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant ForLoopPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 13: ISI BENSIN (MATERI 13 - WHILE LOOP)
// =============================================================================
class WhileFuelPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  WhileFuelPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;

    // --- WARNA & GRADASI ---
    final tankBorder = Colors.grey[700]!;
    final glassColor = Colors.lightBlueAccent.withOpacity(0.1);
    final glassHighlight = Colors.white.withOpacity(0.4);
    
    // Gradasi Bensin (Kuning ke Oranye)
    final fuelGradient = LinearGradient(
      colors: [Colors.orange[300]!, Colors.orange[800]!],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    
    final nozzleColor = Colors.black87;
    final hoseColor = Colors.grey[900]!;

    // --- 1. KONFIGURASI TANGKI ---
    final double tankW = 160;
    final double tankH = 220;
    final tankRect = Rect.fromCenter(center: Offset(cx, cy), width: tankW, height: tankH);
    final tankRRect = RRect.fromRectAndRadius(tankRect, const Radius.circular(20));

    // --- 2. HITUNG LEVEL BENSIN ---
    // Logika interpolasi level berdasarkan step
    double currentLevel = 0.0;
    
    if (activeStep == 0) { // KOSONG (Sisa dikit)
      currentLevel = 0.1; 
    } else if (activeStep == 1) { // ISI TAHAP 1 (10% -> 40%)
      currentLevel = 0.1 + (progress * 0.3);
    } else if (activeStep == 2) { // ISI TAHAP 2 (40% -> 70%)
      currentLevel = 0.4 + (progress * 0.3);
    } else if (activeStep == 3) { // ISI TAHAP 3 (70% -> 100%)
      currentLevel = 0.7 + (progress * 0.3);
    } else { // PENUH
      currentLevel = 1.0;
    }
    
    // Clamp agar tidak lewat batas
    if (currentLevel > 1.0) currentLevel = 1.0;


    // --- 3. GAMBAR ISI TANGKI (MASKING) ---
    canvas.save();
    canvas.clipRRect(tankRRect); // Agar bensin tidak keluar garis tangki

    // Background Kaca (Isi kosong)
    canvas.drawPaint(Paint()..color = glassColor);

    // Tinggi Cairan dalam Pixel
    double liquidHeight = tankH * currentLevel;
    double surfaceY = tankRect.bottom - liquidHeight;

    // Gambar Gelombang (Wave) di permukaan
    final wavePath = Path();
    wavePath.moveTo(tankRect.left, tankRect.bottom);
    wavePath.lineTo(tankRect.left, surfaceY);
    
    // Sinus Wave Logic
    // Amplitude mengecil jika penuh agar tidak terlihat aneh di atap
    double amplitude = (activeStep < 4) ? 5.0 : 2.0; 
    double frequency = 0.05;
    double phase = progress * 10; // Gerakan ombak

    for (double x = 0; x <= tankW; x++) {
      double y = surfaceY + math.sin((x * frequency) + phase) * amplitude;
      wavePath.lineTo(tankRect.left + x, y);
    }
    
    wavePath.lineTo(tankRect.right, tankRect.bottom);
    wavePath.close();

    // Gambar Cairan dengan Gradasi
    final fuelPaint = Paint()..shader = fuelGradient.createShader(tankRect);
    canvas.drawPath(wavePath, fuelPaint);

    // Gambar Gelembung (Bubbles) jika sedang mengisi
    if (activeStep > 0 && activeStep < 4) {
      _drawBubbles(canvas, cx, tankRect.bottom, liquidHeight, progress);
    }

    canvas.restore(); // Selesai Masking


    // --- 4. GAMBAR DETAIL TANGKI (OVERLAY) ---
    // Bingkai Tangki
    canvas.drawRRect(tankRRect, Paint()..color = tankBorder..style = PaintingStyle.stroke..strokeWidth = 5);
    
    // Highlight Kaca (Kilau Putih di Kiri)
    final highlightPath = Path();
    highlightPath.moveTo(tankRect.left + 10, tankRect.top + 20);
    highlightPath.quadraticBezierTo(tankRect.left + 15, tankRect.bottom - 40, tankRect.left + 30, tankRect.bottom - 20);
    canvas.drawPath(highlightPath, Paint()..color = glassHighlight..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap=StrokeCap.round);

    // Garis Ukuran (E, 1/2, F)
    _drawGaugeMarks(canvas, tankRect);


    // --- 5. GAMBAR NOZZLE & ALIRAN ---
    final nozzleTip = Offset(tankRect.left + 20, tankRect.top - 10);
    
    // Aliran Bensin (Stream)
    if (activeStep > 0 && activeStep < 4) {
      // Garis jatuh
      canvas.drawLine(
        nozzleTip, 
        Offset(nozzleTip.dx, surfaceY + 10), // Masuk sedikit ke cairan
        Paint()..color = Colors.orange[300]!..strokeWidth = 6..strokeCap = StrokeCap.round
      );
      
      // Cipratan di permukaan
      canvas.drawCircle(Offset(nozzleTip.dx, surfaceY), 4 + (math.sin(progress * 20).abs() * 2), Paint()..color = Colors.orange[100]!);
    }

    // Gambar Gagang Nozzle
    _drawNozzle(canvas, nozzleTip, nozzleColor, hoseColor);


    // --- 6. TEKS & LOGIKA ---
    // Teks Persentase Besar
    _drawText(
      canvas, 
      Offset(cx, cy), 
      "${(currentLevel * 100).toInt()}%", 
      Colors.white.withOpacity(0.9), 
      40, 
      bold: true,
      shadow: true
    );

    // Status & Logic Text
    String statusText = "";
    String logicText = "";
    Color logicBoxColor = Colors.grey;

    if (activeStep == 0) { 
      statusText = "Tangki Kosong";
      logicText = "WHILE (Isi < 100)? TRUE";
      logicBoxColor = Colors.green;
    } 
    else if (activeStep < 4) { 
      statusText = "Mengisi Bensin...";
      logicText = "WHILE (< 100) ... LOOPING";
      logicBoxColor = Colors.blue;
    } 
    else { 
      statusText = "Tangki Penuh!";
      logicText = "WHILE (< 100)? FALSE -> STOP";
      logicBoxColor = Colors.redAccent;
    }

    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx, size.height - 40), logicText, logicBoxColor);
  }

  // --- HELPER DRAWING ---

  void _drawNozzle(Canvas canvas, Offset tip, Color color, Color hoseColor) {
    final path = Path();
    // Bentuk pistol nozzle sederhana
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx - 10, tip.dy - 10);
    path.lineTo(tip.dx - 40, tip.dy - 10); // Laras
    path.lineTo(tip.dx - 40, tip.dy + 30); // Gagang bawah
    path.lineTo(tip.dx - 20, tip.dy + 30);
    path.lineTo(tip.dx - 20, tip.dy); // Trigger area
    path.close();

    // Selang (Hose) melengkung ke atas luar layar
    final hosePath = Path();
    hosePath.moveTo(tip.dx - 40, tip.dy + 30);
    hosePath.quadraticBezierTo(tip.dx - 60, tip.dy + 80, tip.dx - 100, tip.dy - 100);
    
    canvas.drawPath(hosePath, Paint()..color = hoseColor..style = PaintingStyle.stroke..strokeWidth = 12);
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawGaugeMarks(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Colors.black54..strokeWidth = 2;
    final textP = Paint()..color = Colors.black;

    // Posisi X di kanan tangki
    double x = rect.right;
    
    // E (Empty)
    canvas.drawLine(Offset(x, rect.bottom - 20), Offset(x - 15, rect.bottom - 20), paint);
    _drawText(canvas, Offset(x - 25, rect.bottom - 20), "E", Colors.black, 12, bold: true);

    // F (Full)
    canvas.drawLine(Offset(x, rect.top + 20), Offset(x - 15, rect.top + 20), paint);
    _drawText(canvas, Offset(x - 25, rect.top + 20), "F", Colors.black, 12, bold: true);
    
    // Mid
    canvas.drawLine(Offset(x, rect.center.dy), Offset(x - 10, rect.center.dy), paint);
  }

  void _drawBubbles(Canvas canvas, double cx, double bottomY, double height, double progress) {
    final bubblePaint = Paint()..color = Colors.white.withOpacity(0.4);
    final rand = math.Random(42); // Seed tetap agar posisi konsisten per frame tapi bergerak

    for (int i = 0; i < 8; i++) {
      // Posisi X random
      double x = cx + (rand.nextDouble() - 0.5) * 100;
      // Posisi Y bergerak naik berdasarkan progress
      // (rand.nextDouble() * height) memberikan posisi awal acak
      double yOffset = (progress * 200 + (rand.nextDouble() * 200)) % height;
      double y = bottomY - yOffset;

      double size = 3 + rand.nextDouble() * 4;
      
      if (y > bottomY - height + 10) { // Hanya gambar jika di dalam cairan
         canvas.drawCircle(Offset(x, y), size, bubblePaint);
      }
    }
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double size, {bool bold = false, bool shadow = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text, 
        style: TextStyle(
          color: color, 
          fontSize: size, 
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          shadows: shadow ? [const Shadow(color: Colors.black38, offset: Offset(2, 2), blurRadius: 4)] : null
        )
      ),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), 
      textDirection: TextDirection.ltr
    )..layout();
    
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 16);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')), 
      textDirection: TextDirection.ltr
    )..layout();
    
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.black87);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = color..style=PaintingStyle.stroke..strokeWidth=1);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant WhileFuelPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 14: MASAK SUP (MATERI 14 - DO WHILE LOOP)
// =============================================================================
class DoWhileCookingPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  DoWhileCookingPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.6;

    // --- WARNA ---
    final potColor = Colors.redAccent[700]!;
    final potRimColor = Colors.red[900]!;
    final soupColor = Colors.orange[400]!;
    final stoveColor = Colors.grey[850]!;
    final metalColor = Colors.blueGrey[200]!;
    
    // --- 1. GAMBAR KOMPOR (BASE) ---
    final stoveRect = Rect.fromCenter(center: Offset(cx, cy + 110), width: 180, height: 50);
    final stoveRRect = RRect.fromRectAndRadius(stoveRect, const Radius.circular(10));
    canvas.drawRRect(stoveRRect, Paint()..color = stoveColor);
    
    // Kisi-kisi Kompor
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 90), width: 140, height: 40), Paint()..color = Colors.black54);
    
    // Api (Animated)
    _drawFire(canvas, cx, cy + 90, progress);


    // --- 2. GAMBAR PANCI (3D CYLINDER EFFECT) ---
    double potW = 200;
    double potH = 130;
    double potTopY = cy - 40;
    double potBotY = cy + 70;

    // Badan Panci
    final pathPot = Path();
    pathPot.moveTo(cx - potW/2, potTopY);
    pathPot.lineTo(cx - potW/2, potBotY);
    pathPot.quadraticBezierTo(cx, potBotY + 40, cx + potW/2, potBotY); // Dasar melengkung
    pathPot.lineTo(cx + potW/2, potTopY);
    pathPot.close();
    canvas.drawPath(pathPot, Paint()..color = potColor);

    // Bibir Panci (Oval Belakang - Bagian dalam)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, potTopY), width: potW, height: 50), Paint()..color = potRimColor);

    // --- 3. ISI SUP & EFEK MENDIDIH ---
    // Sup (Oval lebih kecil dari bibir)
    final soupRect = Rect.fromCenter(center: Offset(cx, potTopY + 5), width: potW - 20, height: 40);
    canvas.drawOval(soupRect, Paint()..color = soupColor);
    
    // Gelembung Mendidih (Bubbles)
    _drawBoilingBubbles(canvas, cx, potTopY + 5, progress);

    // Bibir Panci (Arc Depan - Menutup Sup)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, potTopY), width: potW, height: 50), 
      0, 3.14, false, 
      Paint()..color = potColor..style=PaintingStyle.stroke..strokeWidth=2
    );

    // Gagang Panci (Kiri Kanan)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 110, potTopY), width: 30, height: 10), const Radius.circular(5)), 
      Paint()..color = Colors.black87
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 110, potTopY), width: 30, height: 10), const Radius.circular(5)), 
      Paint()..color = Colors.black87
    );

    // Uap Panas (Steam)
    _drawSteam(canvas, cx, potTopY - 20, progress);


    // --- 4. LOGIKA FLOWCHART & ANIMASI ALAT ---
    String statusText = "";
    String logicText = "";
    bool showAction = false;
    bool showCheck = false;

    if (activeStep == 0) {
      statusText = "DO { Tambah Garam }";
      logicText = "Jalan minimal 1x";
      showAction = true;
    } 
    else if (activeStep == 1) {
      statusText = "WHILE (Kurang Asin?)";
      logicText = "TRUE -> Ulangi Loop";
      showCheck = true;
    } 
    else if (activeStep == 2) {
      statusText = "DO { Tambah Lagi }";
      logicText = "Looping...";
      showAction = true;
    } 
    else {
      statusText = "WHILE (Kurang Asin?)";
      logicText = "FALSE -> Selesai";
      TextPainter(text: const TextSpan(text: "👨‍🍳", style: TextStyle(fontSize: 60)), textDirection: TextDirection.ltr)..layout()..paint(canvas, Offset(cx - 30, cy - 200));
    }

    if (showAction) {
       _drawSaltShaker(canvas, Offset(cx + 50, cy - 150), progress);
    }

    if (showCheck) {
       _drawTastingSpoon(canvas, Offset(cx, cy - 50), soupColor, metalColor, progress);
    }

    // --- 5. UI LABEL ---
    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx, size.height * 0.9), logicText);
  }

  // --- HELPER METHODS ---

  void _drawSaltShaker(Canvas canvas, Offset pos, double progress) {
    // [PERBAIKAN] Menggunakan math.sin dan math.cos
    double shakeX = math.sin(progress * 20) * 5;
    double shakeY = math.cos(progress * 20) * 5;
    
    Offset shakerPos = pos + Offset(shakeX, shakeY);

    final paintBody = Paint()..color = Colors.grey[300]!;
    final paintCap = Paint()..color = Colors.grey[600]!;
    
    canvas.save();
    canvas.translate(shakerPos.dx, shakerPos.dy);
    canvas.rotate(-0.5); 

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: const Offset(0, 0), width: 30, height: 50), const Radius.circular(4)), paintBody);
    canvas.drawRect(Rect.fromCenter(center: const Offset(0, 25), width: 32, height: 10), paintCap); 

    canvas.restore();

    final saltPaint = Paint()..color = Colors.white..strokeWidth = 2;
    for (int i = 0; i < 8; i++) {
      double fallDist = (progress * 150 + (i * 20)) % 120;
      double spread = (i % 3 - 1) * 10.0; 
      
      if (fallDist > 10) { 
         canvas.drawCircle(Offset(shakerPos.dx - 20 + spread, shakerPos.dy + 20 + fallDist), 2, saltPaint);
      }
    }
  }

  void _drawTastingSpoon(Canvas canvas, Offset targetPos, Color soupColor, Color metalColor, double progress) {
    // [PERBAIKAN] Menggunakan math.sin dan math.pi
    double yOffset = math.sin(progress * math.pi) * 60; 
    Offset spoonPos = targetPos + Offset(0, 40 - yOffset); 

    canvas.drawLine(spoonPos, Offset(spoonPos.dx + 40, spoonPos.dy - 80), Paint()..color = metalColor..strokeWidth = 6..strokeCap = StrokeCap.round);
    canvas.drawOval(Rect.fromCenter(center: spoonPos, width: 35, height: 25), Paint()..color = Colors.grey[400]!);
    
    if (progress > 0.2) {
       canvas.drawCircle(spoonPos, 8, Paint()..color = soupColor);
       if (progress > 0.5) {
          canvas.drawCircle(spoonPos + const Offset(0, -15), 3, Paint()..color = Colors.white30);
       }
    }

    if (progress > 0.6) {
       _drawText(canvas, spoonPos + const Offset(0, -50), "🤔", Colors.black, 30);
    }
  }

  void _drawFire(Canvas canvas, double cx, double cy, double progress) {
    final firePaint = Paint()..color = Colors.orangeAccent;
    for (int i = -1; i <= 1; i++) {
      // [PERBAIKAN] Menggunakan math.sin dan .abs()
      double h = 20 + (math.sin((progress * 30) + i) * 10).abs();
      
      Path firePath = Path();
      firePath.moveTo(cx + (i * 25) - 10, cy);
      firePath.quadraticBezierTo(cx + (i * 25), cy - h, cx + (i * 25) + 10, cy);
      firePath.close();
      canvas.drawPath(firePath, firePaint);
    }
  }

  void _drawBoilingBubbles(Canvas canvas, double cx, double cy, double progress) {
    final bubblePaint = Paint()..color = Colors.white.withOpacity(0.4);
    for (int i = 0; i < 5; i++) {
      // [PERBAIKAN] Menggunakan math.sin
      double dx = (i * 30.0) - 60 + (math.sin(progress * i) * 10);
      double dy = (progress * 100 * (i+1)) % 40; 
      double size = 8.0 * (1 - (dy/40)); 
      
      canvas.drawCircle(Offset(cx + dx, cy + 10 - dy), size, bubblePaint);
    }
  }

  void _drawSteam(Canvas canvas, double cx, double cy, double progress) {
    final steamPaint = Paint()..color = Colors.white.withOpacity(0.2)..style=PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
       double y = cy - ((progress * 100 + (i * 50)) % 150);
       // [PERBAIKAN] Menggunakan math.sin dan math.abs
       double x = cx + (math.sin(y / 20) * 15); 
       double size = 10 + ((cy - y).abs() / 10); 
       
       if (y < cy) { 
         canvas.drawCircle(Offset(x, y), size, steamPaint);
       }
    }
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.orange[800]!);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white.withOpacity(0.8));
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.black87..style=PaintingStyle.stroke..strokeWidth=1);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant DoWhileCookingPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 11: VENDING MACHINE (MATERI 11 - SWITCH CASE)
// =============================================================================
class SwitchCasePainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  SwitchCasePainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;

    // --- WARNA ---
    final machineBody = Colors.red[800]!;
    final machineDark = Colors.red[900]!;
    final glassColor = Colors.lightBlueAccent.withOpacity(0.2);
    final glassBorder = Colors.grey[400]!;
    final panelColor = Colors.grey[850]!;
    
    // Warna Kaleng
    final canA = Colors.redAccent;
    final canB = Colors.blueAccent;
    final canC = Colors.orangeAccent;
    final canD = Colors.greenAccent;

    // --- 1. GAMBAR MESIN VENDING (BASE) ---
    final bodyRect = Rect.fromCenter(center: Offset(cx, cy), width: 220, height: 320);
    // Body Luar
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(10)), Paint()..color = machineBody);
    
    // Header Mesin (Logo)
    canvas.drawRect(Rect.fromLTWH(bodyRect.left + 10, bodyRect.top + 10, bodyRect.width - 20, 40), Paint()..color = Colors.white);
    _drawText(canvas, Offset(cx, bodyRect.top + 30), "VENDING++", Colors.red[800]!, 20, bold: true);

    // Kaca Display (Window)
    final glassRect = Rect.fromLTWH(bodyRect.left + 15, bodyRect.top + 60, 140, 160);
    canvas.drawRect(glassRect, Paint()..color = Colors.black87); // Gelap dalam

    // Panel Kontrol (Kanan)
    final panelRect = Rect.fromLTWH(glassRect.right + 10, glassRect.top, 40, 160);
    canvas.drawRect(panelRect, Paint()..color = panelColor);
    // Tombol-tombol Panel
    _drawPanelButtons(canvas, panelRect);

    // Slot Keluar (Output)
    final outputRect = Rect.fromLTWH(bodyRect.left + 15, bodyRect.bottom - 70, 190, 50);
    canvas.drawRRect(RRect.fromRectAndRadius(outputRect, const Radius.circular(5)), Paint()..color = Colors.black);
    // Pintu flap output
    canvas.drawRect(Rect.fromLTWH(outputRect.left + 10, outputRect.top + 5, outputRect.width - 20, outputRect.height - 20), Paint()..color = Colors.grey[800]!);


    // --- 2. POSISI KALENG DI RAK ---
    final posA = Offset(glassRect.left + 35, glassRect.top + 40);
    final posB = Offset(glassRect.right - 35, glassRect.top + 40);
    final posC = Offset(glassRect.left + 35, glassRect.bottom - 40);
    final posD = Offset(glassRect.right - 35, glassRect.bottom - 40);

    // --- 3. LOGIKA ANIMASI & STATE ---
    String statusText = "";
    String logicText = "";
    
    bool highlightA = false;
    bool highlightB = false;
    bool dropA = false;
    
    // STEP 0: INPUT (Tekan Tombol A)
    if (activeStep == 0) {
      statusText = "Input: Pilih 'A'";
      logicText = "switch(choice) ...";
      // Efek Tombol A ditekan
      _drawButtonPress(canvas, panelRect.topCenter + const Offset(0, 30), progress);
    } 
    // STEP 1: CASE A MATCH
    else if (activeStep == 1) {
      statusText = "Case 'A': MATCH!";
      logicText = "case 'A': // Eksekusi";
      highlightA = true; // Kotak hijau di A
    } 
    // STEP 2: CASE B SKIP (Logic Check)
    else if (activeStep == 2) {
      statusText = "Cek Lainnya? SKIP";
      logicText = "break; // Stop cek B,C,D";
      highlightA = true; // Masih di A
      highlightB = false; // B dilewati (Gelap)
    } 
    // STEP 3: OUTPUT (Jatuh)
    else {
      statusText = "Output: Cola Keluar";
      logicText = "Dispense Item A";
      dropA = true;
    }

    // --- 4. GAMBAR KALENG (DI RAK) ---
    // Gambar Rak
    canvas.drawLine(Offset(glassRect.left, glassRect.top + 80), Offset(glassRect.right, glassRect.top + 80), Paint()..color = Colors.grey..strokeWidth=2);

    // Kaleng A (Jika drop, gambar animasi jatuh nanti)
    if (!dropA) _drawCan(canvas, posA, canA, "A");
    _drawCan(canvas, posB, canB, "B");
    _drawCan(canvas, posC, canC, "C");
    _drawCan(canvas, posD, canD, "D");

    // Efek Highlight (Selection Box)
    if (highlightA) _drawSelectionBox(canvas, posA, (progress * 10).toInt() % 2 == 0);
    if (highlightB) _drawSelectionBox(canvas, posB, true, isError: true); // Merah jika salah (opsional)

    // Tutup Kaca (Glass Overlay)
    canvas.drawRect(glassRect, Paint()..color = glassColor);
    // Kilau Kaca
    final shinePath = Path();
    shinePath.moveTo(glassRect.left, glassRect.bottom);
    shinePath.lineTo(glassRect.left + 40, glassRect.top);
    shinePath.lineTo(glassRect.left + 70, glassRect.top);
    shinePath.lineTo(glassRect.left + 30, glassRect.bottom);
    canvas.drawPath(shinePath, Paint()..color = Colors.white.withOpacity(0.1));


    // --- 5. ANIMASI JATUH (DROP) ---
    if (dropA) {
      // Lintasan Jatuh: Dari Pos A -> Bawah Kaca -> Masuk Output
      double t = progress;
      double startX = posA.dx;
      double startY = posA.dy;
      
      double endX = cx; // Tengah lubang
      double endY = outputRect.center.dy;
      
      double curX = startX + (t * (endX - startX));
      // Jatuh dipercepat (Gravity parabola sederhana)
      double curY = startY + (t * t * (endY - startY)); 
      
      // Rotasi saat jatuh
      double rotation = t * math.pi * 2;

      // Masking: Agar saat lewat di belakang panel bawah tidak terlihat aneh
      // Tapi karena ini di layer paling atas (overlay), kita biarkan terlihat "tembus" kaca sampai masuk lubang
      
      if (curY < outputRect.top + 10) { // Masih di area kaca/jatuh
         canvas.save();
         canvas.translate(curX, curY);
         canvas.rotate(rotation);
         _drawCan(canvas, Offset.zero, canA, "A");
         canvas.restore();
      } else {
         // Sudah mendarat di slot (Diam)
         _drawCan(canvas, Offset(endX, endY), canA, "A");
      }
    }

    // --- 6. LABEL ---
    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx, size.height - 30), logicText);
  }

  // --- HELPER DRAWING ---

  void _drawCan(Canvas canvas, Offset center, Color color, String label) {
    // Body Kaleng
    final rect = Rect.fromCenter(center: center, width: 24, height: 36);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = color);
    
    // Tutup Atas/Bawah Silver
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, 4), Paint()..color = Colors.grey[300]!);
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.bottom - 4, rect.width, 4), Paint()..color = Colors.grey[300]!);
    
    // Label
    _drawText(canvas, center, label, Colors.white, 14, bold: true);
  }

  void _drawSelectionBox(Canvas canvas, Offset center, bool visible, {bool isError = false}) {
    if (!visible) return;
    final rect = Rect.fromCenter(center: center, width: 34, height: 46);
    final paint = Paint()
      ..color = isError ? Colors.redAccent : Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);
  }

  void _drawPanelButtons(Canvas canvas, Rect panelRect) {
    final paint = Paint()..color = Colors.grey[600]!;
    double startY = panelRect.top + 20;
    // Gambar 3 tombol
    for(int i=0; i<3; i++) {
       canvas.drawCircle(Offset(panelRect.center.dx, startY + (i * 25)), 6, paint);
    }
    // Slot Koin
    canvas.drawRect(Rect.fromCenter(center: Offset(panelRect.center.dx, startY + 100), width: 4, height: 20), Paint()..color = Colors.black);
  }

  void _drawButtonPress(Canvas canvas, Offset pos, double progress) {
    // Efek Ripple/Tekan
    double size = 6 + (math.sin(progress * 10).abs() * 4);
    canvas.drawCircle(pos, size, Paint()..color = Colors.greenAccent.withOpacity(0.6));
    canvas.drawCircle(pos, 6, Paint()..color = Colors.green); // Tombol jadi hijau
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white.withOpacity(0.9));
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.black87..style=PaintingStyle.stroke..strokeWidth=1);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double size, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant SwitchCasePainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 16: TURUS PENGHITUNG (MATERI 16 - COUNTER)
// =============================================================================
class CounterTallyPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  CounterTallyPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;

    // --- WARNA ---
    final boardColor = const Color(0xFF1B5E20); // Hijau Tua
    final frameColor = const Color(0xFF5D4037); // Coklat Kayu
    final chalkColor = Colors.white.withOpacity(0.9);
    final chalkDust = Colors.white.withOpacity(0.1);

    // --- 1. GAMBAR PAPAN TULIS (CHALKBOARD) ---
    final boardW = 280.0;
    final boardH = 180.0;
    final boardRect = Rect.fromCenter(center: Offset(cx, cy), width: boardW, height: boardH);
    
    // Bingkai Kayu (Frame)
    canvas.drawRect(boardRect.inflate(15), Paint()..color = frameColor);
    // Detail serat kayu sederhana (garis-garis tipis)
    final woodPaint = Paint()..color = Colors.black12..strokeWidth = 2;
    for(double i=boardRect.top-15; i<boardRect.bottom+15; i+=5) {
       // Hanya gambar di frame
       if (i < boardRect.top || i > boardRect.bottom) {
          canvas.drawLine(Offset(boardRect.left-15, i), Offset(boardRect.right+15, i), woodPaint);
       }
    }

    // Papan Hijau
    canvas.drawRect(boardRect, Paint()..color = boardColor);
    
    // Tekstur Debu Kapur (Smudges)
    _drawChalkSmudges(canvas, boardRect, chalkDust);

    // Penghapus & Kapur di bawah papan
    _drawEraserAndChalk(canvas, Offset(cx, cy + boardH/2 + 15));


    // --- 2. LOGIKA COUNTER & POSISI ---
    String statusText = "";
    int count = 0;
    
    // Tentukan jumlah turus yang harus digambar
    if (activeStep == 0) {
      statusText = "Mulai: Counter = 0";
      count = 0;
    } else if (activeStep == 1) {
      statusText = "Loop 1: Tambah 1";
      count = 1;
    } else if (activeStep == 2) {
      statusText = "Loop 2: Tambah 1";
      count = 2;
    } else {
      statusText = "Loop 3: Tambah 1";
      count = 3;
    }

    // Posisi awal turus
    double startX = cx - 40;
    double startY = cy - 40;
    double gap = 40; 
    double lineHeight = 80;

    // --- 3. GAMBAR TURUS (TALLY MARKS) ---
    final chalkPaint = Paint()
      ..color = chalkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // A. Gambar Turus Statis (Langkah sebelumnya)
    for (int i = 1; i < count; i++) {
       // Turus Tegak
       double x = startX + (i-1)*gap;
       _drawRoughLine(canvas, Offset(x, startY), Offset(x, startY + lineHeight), chalkPaint);
    }

    // B. Gambar Turus Animasi (Langkah saat ini)
    if (count > 0) {
      double currentX = startX + (count-1)*gap;
      
      // Animasi menggambar garis dari atas ke bawah
      double drawProgress = (activeStep == count) ? progress : 1.0; 
      
      double p1y = startY;
      double p2y = startY + (drawProgress * lineHeight);
      
      // Gambar garis yang sedang dibuat
      _drawRoughLine(canvas, Offset(currentX, p1y), Offset(currentX, p2y), chalkPaint);
      
      // Tangan Penulis (Hanya muncul jika sedang animasi)
      if (activeStep == count && drawProgress < 1.0) {
        _drawHandWriting(canvas, Offset(currentX + 15, p2y + 15));
      }
    }

    // --- 4. DISPLAY VARIABEL ---
    _drawVarDisplay(canvas, Offset(cx, cy + 150), "Counter", "$count");
    _drawLabelBubble(canvas, size, statusText);
  }

  // --- HELPER METHODS ---

  void _drawChalkSmudges(Canvas canvas, Rect rect, Color color) {
    final paint = Paint()..color = color;
    // Gambar beberapa oval acak sebagai bekas hapusan
    canvas.drawOval(Rect.fromCenter(center: rect.center, width: 200, height: 100), paint);
    canvas.drawOval(Rect.fromCenter(center: rect.topLeft + const Offset(50, 50), width: 80, height: 60), paint);
    canvas.drawOval(Rect.fromCenter(center: rect.bottomRight - const Offset(50, 50), width: 100, height: 70), paint);
  }

  void _drawRoughLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    // Membuat garis sedikit tidak rata agar terlihat seperti kapur
    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    // Sedikit getaran random di tengah garis (simulasi tekstur)
    path.quadraticBezierTo(p1.dx + 2, (p1.dy + p2.dy)/2, p2.dx, p2.dy);
    canvas.drawPath(path, paint);
  }

  void _drawHandWriting(Canvas canvas, Offset pos) {
    // Kapur Batangan
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(-0.5); // Miring posisi menulis
    
    // Batang Kapur
    canvas.drawRect(Rect.fromLTWH(-5, -25, 10, 25), Paint()..color = Colors.white);
    
    // Jari Telunjuk & Jempol
    canvas.drawCircle(const Offset(5, -10), 12, Paint()..color = const Color(0xFFFFCCAA)); // Jempol
    canvas.drawCircle(const Offset(-5, -15), 12, Paint()..color = const Color(0xFFFFCCAA)); // Telunjuk
    
    // Punggung Tangan
    canvas.drawCircle(const Offset(0, -30), 20, Paint()..color = const Color(0xFFFFCCAA));
    
    // Lengan Baju
    canvas.drawRect(Rect.fromLTWH(-15, -60, 30, 30), Paint()..color = Colors.blue[800]!);

    canvas.restore();
  }

  void _drawEraserAndChalk(Canvas canvas, Offset center) {
    // Penghapus (Balok Hitam + Felt Putih)
    canvas.drawRect(Rect.fromCenter(center: center + const Offset(-40, 0), width: 40, height: 15), Paint()..color = Colors.white70); // Felt
    canvas.drawRect(Rect.fromCenter(center: center + const Offset(-40, -5), width: 40, height: 10), Paint()..color = Colors.black87); // Grip
    
    // Batang Kapur Cadangan
    canvas.drawRect(Rect.fromCenter(center: center + const Offset(40, 0), width: 30, height: 8), Paint()..color = Colors.white);
  }

  void _drawVarDisplay(Canvas canvas, Offset center, String label, String value) {
    final tp = TextPainter(
      text: TextSpan(text: "$label = $value", style: TextStyle(color: Colors.blueGrey[800], fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace')), 
      textDirection: TextDirection.ltr
    )..layout();
    
    final rect = Rect.fromCenter(center: center, width: tp.width + 40, height: 50);
    // Style Sticker Kertas
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), Paint()..color = Colors.yellow[100]!);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), Paint()..color = Colors.grey..style=PaintingStyle.stroke..strokeWidth=1);
    
    // Efek selotip di atas
    canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, rect.top), width: 40, height: 10), Paint()..color = Colors.white.withOpacity(0.5));

    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.green[800]!);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant CounterTallyPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 17: MESIN KASIR (MATERI 17 - ACCUMULATOR)
// =============================================================================
class AccumulatorCashierPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  AccumulatorCashierPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.6;

    // --- WARNA ---
    final machineBody = Colors.blueGrey[800]!;
    final machineLight = Colors.blueGrey[600]!;
    final screenBg = Colors.black;
    final screenText = Colors.greenAccent[400]!;
    final receiptPaper = Colors.white;
    
    // --- 1. GAMBAR MESIN KASIR ---
    final bodyRect = Rect.fromCenter(center: Offset(cx, cy), width: 220, height: 160);
    
    // Body Utama (Trapesium - atas lebih kecil)
    final pathBody = Path();
    pathBody.moveTo(cx - 90, cy - 80); // Kiri Atas
    pathBody.lineTo(cx + 90, cy - 80); // Kanan Atas
    pathBody.lineTo(cx + 110, cy + 80); // Kanan Bawah
    pathBody.lineTo(cx - 110, cy + 80); // Kiri Bawah
    pathBody.close();
    canvas.drawPath(pathBody, Paint()..color = machineBody);
    
    // Layar LCD (Monitor)
    final screenFrame = Rect.fromCenter(center: Offset(cx, cy - 110), width: 160, height: 70);
    // Tiang Layar
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - 80), width: 40, height: 40), Paint()..color = machineLight);
    // Frame Layar
    canvas.drawRRect(RRect.fromRectAndRadius(screenFrame, const Radius.circular(8)), Paint()..color = machineLight);
    // LCD Panel
    final lcdRect = screenFrame.deflate(10);
    canvas.drawRect(lcdRect, Paint()..color = screenBg);
    
    // Tombol-tombol Keypad
    _drawKeypad(canvas, Offset(cx - 50, cy + 20));
    
    // Laci Uang (Drawer)
    final drawerRect = Rect.fromCenter(center: Offset(cx, cy + 100), width: 230, height: 40);
    canvas.drawRRect(RRect.fromRectAndRadius(drawerRect, const Radius.circular(5)), Paint()..color = machineLight);
    canvas.drawRect(Rect.fromCenter(center: drawerRect.center, width: 60, height: 10), Paint()..color = Colors.black12); // Handle


    // --- 2. LOGIKA ANIMASI & VARIABEL ---
    String statusText = "";
    int currentTotal = 0;
    String itemText = "";
    Color itemColor = Colors.transparent;
    
    // Posisi Item Jatuh (Dari atas layar ke laci)
    double itemY = -50; 
    double itemOpacity = 0.0;

    // Variabel Struk
    double receiptLength = 0.0;

    if (activeStep == 0) { // START
      statusText = "Total = 0";
      currentTotal = 0;
    } 
    else if (activeStep == 1) { // BELI PERMEN (1000)
      statusText = "Add Permen (+1000)";
      itemText = "🍬";
      itemColor = Colors.pinkAccent;
      
      // Animasi jatuh
      double startY = cy - 200;
      double endY = cy + 50; // Masuk ke laci
      itemY = startY + (progress * (endY - startY));
      itemOpacity = (progress > 0.8) ? 0.0 : 1.0; // Hilang saat masuk
      
      // Update Total saat item masuk (progress > 0.8)
      currentTotal = (progress > 0.8) ? 1000 : 0;
    } 
    else if (activeStep == 2) { // BELI ROTI (2000)
      statusText = "Add Roti (+2000)";
      itemText = "🍞";
      itemColor = Colors.orangeAccent;
      
      itemY = (cy - 200) + (progress * 250);
      itemOpacity = (progress > 0.8) ? 0.0 : 1.0;
      
      currentTotal = (progress > 0.8) ? 3000 : 1000;
    } 
    else { // TOTAL
      statusText = "Total Akhir: 3000";
      currentTotal = 3000;
      
      // Struk Keluar
      receiptLength = 60 * progress;
    }

    // --- 3. GAMBAR STRUK (RECEIPT) ---
    // Digambar di sisi kiri mesin
    if (receiptLength > 0 || activeStep > 0) {
       // Kertas Struk (Muncul dari celah printer di kiri mesin)
       double printerX = cx - 70;
       double printerY = cy - 60;
       
       // Panjang struk bertambah tiap langkah (akumulatif visual)
       double baseLen = (activeStep * 15.0); 
       double animLen = (activeStep == 3) ? receiptLength : 0;
       double totalLen = baseLen + animLen;
       
       if (totalLen > 0) {
          canvas.drawRect(Rect.fromLTWH(printerX, printerY - totalLen, 40, totalLen), Paint()..color = receiptPaper);
          // Garis-garis teks struk
          for (double i = 5; i < totalLen; i += 8) {
             canvas.drawLine(Offset(printerX + 5, printerY - i), Offset(printerX + 35, printerY - i), Paint()..color = Colors.black26..strokeWidth=1);
          }
       }
    }

    // --- 4. GAMBAR ITEM JATUH ---
    if (itemOpacity > 0 && activeStep < 3 && activeStep > 0) {
       // Masking: Item muncul di depan layar tapi masuk ke dalam mesin
       // Kita gambar itemnya
       _drawItemIcon(canvas, Offset(cx, itemY), itemText, itemColor);
       // Label Harga melayang
       _drawText(canvas, Offset(cx + 40, itemY), "+${(activeStep==1)?1000:2000}", Colors.green, 14, bold: true);
    }

    // --- 5. TAMPILAN LAYAR ---
    // Teks "TOTAL" kecil
    _drawText(canvas, Offset(cx - 40, cy - 130), "TOTAL", screenText.withOpacity(0.7), 10);
    // Angka Besar (Digital Font Style)
    _drawText(canvas, Offset(cx + 20, cy - 110), "$currentTotal", screenText, 30, bold: true, fontFamily: 'monospace');


    // --- 6. INFO LABEL & RUMUS ---
    _drawLabelBubble(canvas, size, statusText);
    
    // Box Rumus Akumulator
    String formula = "sum = sum + harga";
    if (activeStep == 1) formula = "0 + 1000 = 1000";
    if (activeStep == 2) formula = "1000 + 2000 = 3000";
    
    _drawLogicBox(canvas, Offset(cx, size.height * 0.9), formula);
  }

  // --- HELPER DRAWING ---

  void _drawKeypad(Canvas canvas, Offset startPos) {
    final paintKey = Paint()..color = Colors.black87;
    double size = 12;
    double gap = 18;
    
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 3; col++) {
        // Tombol persegi kecil
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(startPos.dx + (col * gap), startPos.dy + (row * gap), 14, 10), const Radius.circular(2)), 
          paintKey
        );
      }
    }
    // Tombol Enter Besar di kanan
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(startPos.dx + (3 * gap), startPos.dy, 14, (3 * gap) + 10), const Radius.circular(2)), 
      Paint()..color = Colors.green[700]!
    );
  }

  void _drawItemIcon(Canvas canvas, Offset center, String text, Color color) {
    // Background lingkaran item
    canvas.drawCircle(center, 20, Paint()..color = Colors.white);
    canvas.drawCircle(center, 20, Paint()..color = color.withOpacity(0.3)..style=PaintingStyle.stroke..strokeWidth=2);
    
    // Emoji Text
    TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 24)), 
      textDirection: TextDirection.ltr
    )..layout()..paint(canvas, Offset(center.dx - 12, center.dy - 12));
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.blueGrey..style=PaintingStyle.stroke..strokeWidth=2);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color, double size, {bool bold = false, String? fontFamily}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontFamily: fontFamily)),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant AccumulatorCashierPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 18: RODA HAMSTER (MATERI 18 - INFINITE LOOP)
// =============================================================================
class InfiniteLoopPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  InfiniteLoopPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;
    final wheelRadius = 90.0;

    // --- EFEK GETAR (SCREEN SHAKE) SAAT CRASH ---
    if (activeStep == 3) {
      double shakeX = (math.Random().nextDouble() - 0.5) * 10;
      double shakeY = (math.Random().nextDouble() - 0.5) * 10;
      canvas.translate(shakeX, shakeY);
      
      // Background Merah Berkedip
      double alarm = math.sin(progress * 20).abs();
      canvas.drawRect(
        Rect.fromLTWH(-50, -50, size.width + 100, size.height + 100), 
        Paint()..color = Colors.red.withOpacity(0.1 + (alarm * 0.2))
      );
    }

    // --- 1. GAMBAR PENYANGGA RODA ---
    final standPath = Path();
    standPath.moveTo(cx, cy);
    standPath.lineTo(cx - 50, cy + 120);
    standPath.lineTo(cx + 50, cy + 120);
    standPath.close();
    canvas.drawPath(standPath, Paint()..color = Colors.blueGrey[800]!);


    // --- 2. GAMBAR RODA BERPUTAR ---
    double speedMultiplier = 0.0;
    if (activeStep == 1) speedMultiplier = 5.0; // Normal
    if (activeStep == 2) speedMultiplier = 15.0; // Cepat
    if (activeStep == 3) speedMultiplier = 30.0; // Sangat Cepat

    double rotation = (activeStep > 0) ? (progress * speedMultiplier * math.pi) : 0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation);

    // Rim Roda
    final wheelPaint = Paint()..color = Colors.grey[400]!..style = PaintingStyle.stroke..strokeWidth = 8;
    canvas.drawCircle(Offset.zero, wheelRadius, wheelPaint);
    
    // Jeruji (Spokes)
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * (math.pi / 180);
      canvas.drawLine(
        Offset(math.cos(angle) * 10, math.sin(angle) * 10), 
        Offset(math.cos(angle) * wheelRadius, math.sin(angle) * wheelRadius), 
        Paint()..color = Colors.grey[500]!..strokeWidth = 3
      );
    }
    // Poros
    canvas.drawCircle(Offset.zero, 12, Paint()..color = Colors.black87..style=PaintingStyle.fill);
    
    canvas.restore();


    // --- 3. GAMBAR HAMSTER ---
    // Posisi dasar di bawah roda
    double hx = cx;
    double hy = cy + wheelRadius - 25;
    
    // Logika Animasi Hamster
    bool isRunning = (activeStep == 1 || activeStep == 2);
    bool isDead = (activeStep == 3);
    
    // Bounce saat lari
    if (isRunning) {
      hy += math.sin(progress * speedMultiplier * 2) * 3;
    }
    
    // Jika mati, terlempar sedikit/miring
    double hamsterRot = 0;
    if (isDead) {
       hamsterRot = math.pi / 4; // Miring 45 derajat
       hy += 20; // Jatuh
       hx += 10;
    }

    canvas.save();
    canvas.translate(hx, hy);
    canvas.rotate(hamsterRot);
    _drawHamster(canvas, isRunning, isDead, activeStep == 2);
    canvas.restore();


    // --- 4. EFEK ASAP (JIKA STEP 2 ATAU 3) ---
    if (activeStep >= 2) {
       _drawSmoke(canvas, cx, cy - wheelRadius, progress);
    }


    // --- 5. LOGIKA & CPU BAR ---
    String statusText = "";
    String logicText = "";
    double cpuHeat = 0.1;

    if (activeStep == 0) {
      statusText = "Cek Kondisi: TRUE";
      logicText = "while(true) { ... }";
      cpuHeat = 0.1;
    } 
    else if (activeStep == 1) {
      statusText = "Looping...";
      logicText = "Tidak ada 'break'!";
      cpuHeat = 0.4;
    } 
    else if (activeStep == 2) {
      statusText = "Panas!!";
      logicText = "Memory Leak...";
      cpuHeat = 0.8;
    } 
    else {
      statusText = "CRASH!!!";
      logicText = "APP NOT RESPONDING";
      cpuHeat = 1.0;
    }

    _drawHeatBar(canvas, Offset(cx + 120, cy), cpuHeat);
    _drawLabelBubble(canvas, size, statusText, isError: isDead);
    _drawText(canvas, Offset(cx, size.height - 40), logicText, (activeStep == 3) ? Colors.red : Colors.black87);
  }

  // --- HELPER DRAWING ---

  void _drawHamster(Canvas canvas, bool isRunning, bool isDead, bool isPanic) {
    final bodyColor = Colors.orange[300]!;
    
    // Badan
    canvas.drawOval(Rect.fromCenter(center: const Offset(0, 0), width: 50, height: 40), Paint()..color = bodyColor);
    
    // Mata
    if (isDead) {
      // Mata X X
      _drawXEye(canvas, const Offset(10, -10));
      _drawXEye(canvas, const Offset(25, -10));
    } else {
      // Mata Bulat
      double eyeSize = isPanic ? 5 : 3; // Mata melotot jika panik
      canvas.drawCircle(const Offset(15, -12), eyeSize, Paint()..color = Colors.black);
      canvas.drawCircle(const Offset(25, -12), eyeSize, Paint()..color = Colors.black);
    }

    // Telinga
    canvas.drawCircle(const Offset(10, -20), 6, Paint()..color = bodyColor);
    canvas.drawCircle(const Offset(30, -20), 6, Paint()..color = bodyColor);

    // Kaki (Gerak jika lari)
    final legPaint = Paint()..color = Colors.brown[600]!..strokeWidth = 3..strokeCap = StrokeCap.round;
    if (isRunning) {
       // Kaki berayun acak
       canvas.drawLine(const Offset(10, 15), const Offset(5, 25), legPaint);
       canvas.drawLine(const Offset(30, 15), const Offset(35, 25), legPaint);
    } else {
       canvas.drawLine(const Offset(10, 15), const Offset(10, 25), legPaint);
       canvas.drawLine(const Offset(30, 15), const Offset(30, 25), legPaint);
    }
    
    // Keringat (Jika Panic)
    if (isPanic && !isDead) {
       canvas.drawCircle(const Offset(-5, -20), 3, Paint()..color = Colors.lightBlueAccent);
       canvas.drawCircle(const Offset(0, -25), 2, Paint()..color = Colors.lightBlueAccent);
    }
  }

  void _drawXEye(Canvas canvas, Offset center) {
    final p = Paint()..color = Colors.black..strokeWidth = 2;
    canvas.drawLine(center + const Offset(-3, -3), center + const Offset(3, 3), p);
    canvas.drawLine(center + const Offset(3, -3), center + const Offset(-3, 3), p);
  }

  void _drawHeatBar(Canvas canvas, Offset pos, double level) {
    // Background Bar
    final barRect = Rect.fromLTWH(pos.dx, pos.dy - 60, 20, 120);
    canvas.drawRect(barRect, Paint()..color = Colors.grey[300]!);
    canvas.drawRect(barRect, Paint()..color = Colors.black..style=PaintingStyle.stroke..strokeWidth=2);
    
    // Isi Bar (Gradient)
    double fillH = 120 * level;
    Color color = Color.lerp(Colors.green, Colors.red, level)!;
    
    canvas.drawRect(
      Rect.fromLTWH(pos.dx, (pos.dy + 60) - fillH, 20, fillH), 
      Paint()..color = color
    );

    // Label CPU
    TextPainter(text: const TextSpan(text: "CPU", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)
      ..layout()..paint(canvas, Offset(pos.dx, pos.dy + 65));
      
    // Ikon Api jika Penuh
    if (level >= 0.8) {
       TextPainter(text: const TextSpan(text: "🔥", style: TextStyle(fontSize: 20)), textDirection: TextDirection.ltr)
         ..layout()..paint(canvas, Offset(pos.dx - 2, pos.dy - 90));
    }
  }

  void _drawSmoke(Canvas canvas, double cx, double topY, double progress) {
    final smokePaint = Paint()..color = Colors.grey.withOpacity(0.5);
    for (int i = 0; i < 3; i++) {
       double y = topY - ((progress * 100 + (i * 30)) % 80);
       double x = cx + (math.sin(y/10) * 10);
       double s = 5 + (80 - (topY - y))/10;
       if (y < topY) canvas.drawCircle(Offset(x, y), s, smokePaint);
    }
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text, {bool isError = false}) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = isError ? Colors.red[800]! : Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawText(Canvas canvas, Offset center, String text, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant InfiniteLoopPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 19: CARI KUNCI (MATERI 19 - BREAK)
// =============================================================================
class BreakSearchPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  BreakSearchPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;

    // --- WARNA ---
    final cabinetColor = const Color(0xFF5D4037); // Coklat Tua
    final drawerColor = const Color(0xFF8D6E63);  // Coklat Muda
    final innerColor = const Color(0xFF3E2723);   // Gelap (Dalam laci)
    final handleColor = const Color(0xFFD7CCC8);  // Silver/Putih Tulang
    final goldColor = const Color(0xFFFFD54F);

    // Konfigurasi
    final int totalDrawers = 5;
    final double drawerH = 45.0;
    final double drawerW = 180.0;
    final double gap = 12.0;
    final double startY = cy - 100;
    final int targetIndex = 2; // Kunci ada di laci ke-3 (index 2)

    // --- 1. GAMBAR LEMARI (CABINET) ---
    final cabinetRect = Rect.fromCenter(center: Offset(cx, cy + 20), width: 220, height: 320);
    
    // Body Lemari
    canvas.drawRRect(RRect.fromRectAndRadius(cabinetRect, const Radius.circular(8)), Paint()..color = cabinetColor);
    
    // Tekstur Kayu (Garis-garis tipis)
    final woodPaint = Paint()..color = Colors.black12..strokeWidth = 2;
    for (double i = cabinetRect.top + 20; i < cabinetRect.bottom; i += 40) {
       canvas.drawLine(Offset(cabinetRect.left + 10, i), Offset(cabinetRect.right - 10, i + 10), woodPaint);
    }


    // --- 2. LOGIKA STATE ---
    String statusText = "";
    String logicText = "";
    bool isBreak = (activeStep == 3);

    if (activeStep == 0) {
      statusText = "i=0: Cek Laci...";
      logicText = "if (laci[0] == KUNCI) ... FALSE";
    } else if (activeStep == 1) {
      statusText = "i=1: Cek Laci...";
      logicText = "if (laci[1] == KUNCI) ... FALSE";
    } else if (activeStep == 2) {
      statusText = "i=2: KETEMU!";
      logicText = "Found = TRUE -> Siap Break";
    } else {
      statusText = "BREAK EXECUTED";
      logicText = "Stop Loop! (Skip i=3, i=4)";
    }

    // --- 3. GAMBAR LACI-LACI ---
    for (int i = 0; i < totalDrawers; i++) {
      double dy = startY + (i * (drawerH + gap));
      
      // Hitung posisi buka laci
      double slideX = 0.0;
      
      // Jika laci ini sedang dicek
      if (activeStep == i && !isBreak) {
         // Animasi maju mundur (Cek)
         slideX = 50 * math.sin(progress * math.pi); 
      }
      // Jika laci ini adalah target dan sudah ketemu (atau step break)
      else if (i == targetIndex && activeStep >= targetIndex) {
         slideX = 60.0; // Terbuka penuh
      }

      // Tentukan apakah laci ini di-skip (kena efek break)
      bool isSkipped = isBreak && i > targetIndex;

      _drawDrawer(
        canvas: canvas,
        center: Offset(cx, dy),
        width: drawerW,
        height: drawerH,
        slideOffset: slideX,
        color: isSkipped ? Colors.grey[800]! : drawerColor, // Gelap jika skipped
        handleColor: handleColor,
        innerColor: innerColor,
        isSkipped: isSkipped,
        index: i
      );

      // --- GAMBAR ISI LACI (JIKA TERBUKA) ---
      if (slideX > 15) {
        // Posisi isi laci (di dalam area gelap)
        Offset contentPos = Offset(cx + slideX - 20, dy); 
        
        if (i == targetIndex) {
           // KUNCI
           _drawKey(canvas, contentPos, goldColor, (activeStep >= 2) ? progress : 0);
        } else {
           // KOSONG (Debu / Silang)
           _drawEmptyMark(canvas, contentPos);
        }
      }
    }

    // --- 4. INDIKATOR BREAK ---
    if (isBreak) {
       _drawBreakOverlay(canvas, Offset(cx, cy + 100), progress);
    }

    // --- 5. UI LABEL ---
    _drawLabelBubble(canvas, size, statusText, isBreak);
    _drawLogicBox(canvas, Offset(cx, size.height * 0.9), logicText);
  }

  // --- HELPER METHODS ---

  void _drawDrawer({
    required Canvas canvas,
    required Offset center,
    required double width,
    required double height,
    required double slideOffset,
    required Color color,
    required Color handleColor,
    required Color innerColor,
    required bool isSkipped,
    required int index,
  }) {
    // 1. Gambar Area Dalam (Lubang Hitam) - Hanya jika terbuka
    if (slideOffset > 0) {
      final innerRect = Rect.fromCenter(center: center, width: width - 10, height: height - 6);
      canvas.drawRect(innerRect, Paint()..color = innerColor);
    }

    // 2. Gambar Wajah Laci (Bergeser ke kanan)
    final faceRect = Rect.fromCenter(center: Offset(center.dx + slideOffset, center.dy), width: width, height: height);
    
    // Shadow di bawah laci
    canvas.drawRect(
      Rect.fromLTWH(faceRect.left + 5, faceRect.bottom, faceRect.width - 10, 4), 
      Paint()..color = Colors.black26
    );

    // Wajah Laci
    final paint = Paint()..color = color;
    canvas.drawRRect(RRect.fromRectAndRadius(faceRect, const Radius.circular(4)), paint);
    
    // Border Laci
    canvas.drawRRect(RRect.fromRectAndRadius(faceRect, const Radius.circular(4)), Paint()..color = Colors.black38..style=PaintingStyle.stroke..strokeWidth=1);

    // Gagang Laci
    final handleRect = Rect.fromCenter(center: faceRect.center, width: 40, height: 6);
    canvas.drawRRect(RRect.fromRectAndRadius(handleRect, const Radius.circular(3)), Paint()..color = handleColor);
    
    // Label Index (i=0, i=1...)
    TextPainter(
      text: TextSpan(text: "i=$index", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)), 
      textDirection: TextDirection.ltr
    )..layout()..paint(canvas, Offset(faceRect.left + 5, faceRect.top + 5));

    // Jika Skipped, gambar silang atau gembok
    if (isSkipped) {
       final p = Paint()..color = Colors.red.withOpacity(0.5)..strokeWidth = 3;
       canvas.drawLine(faceRect.topLeft, faceRect.bottomRight, p);
       canvas.drawLine(faceRect.topRight, faceRect.bottomLeft, p);
    }
  }

  void _drawKey(Canvas canvas, Offset pos, Color color, double shineProgress) {
    final paint = Paint()..color = color;
    
    // Efek Bersinar (Pulse)
    if (shineProgress > 0) {
       double radius = 15 + (math.sin(shineProgress * 10).abs() * 5);
       canvas.drawCircle(pos, radius, Paint()..color = color.withOpacity(0.4));
    }

    // Kepala Kunci
    canvas.drawCircle(pos, 10, paint);
    canvas.drawCircle(pos, 3, Paint()..color = Colors.brown[800]!); // Lubang

    // Batang Kunci
    canvas.drawRect(Rect.fromLTWH(pos.dx + 5, pos.dy - 2, 20, 5), paint);
    // Gigi
    canvas.drawRect(Rect.fromLTWH(pos.dx + 15, pos.dy + 3, 4, 5), paint);
    canvas.drawRect(Rect.fromLTWH(pos.dx + 22, pos.dy + 3, 4, 3), paint);
  }

  void _drawEmptyMark(Canvas canvas, Offset pos) {
    TextPainter(text: const TextSpan(text: "💨", style: TextStyle(fontSize: 20)), textDirection: TextDirection.ltr)
      ..layout()..paint(canvas, Offset(pos.dx - 10, pos.dy - 10));
  }

  void _drawBreakOverlay(Canvas canvas, Offset center, double progress) {
    // Animasi Pop-up Sign
    double scale = math.min(1.0, progress * 1.5); // Muncul cepat
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    // Rambu STOP / BREAK
    final paintRed = Paint()..color = Colors.red;
    final paintBorder = Paint()..color = Colors.white..style=PaintingStyle.stroke..strokeWidth=3;
    
    // Bentuk Octagon (atau Circle simple)
    canvas.drawCircle(Offset.zero, 35, paintRed);
    canvas.drawCircle(Offset.zero, 32, paintBorder);
    
    final textPainter = TextPainter(
      text: const TextSpan(text: "BREAK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), 
      textDirection: TextDirection.ltr
    )..layout();
    
    textPainter.paint(canvas, Offset(-textPainter.width/2, -textPainter.height/2));

    canvas.restore();
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text, bool isBreak) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = isBreak ? Colors.red[800]! : Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white.withOpacity(0.9));
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.black87..style=PaintingStyle.stroke..strokeWidth=1);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant BreakSearchPainter old) => old.progress != progress || old.activeStep != activeStep;
}
// =============================================================================
// PAINTER 20: ROBOT PEMILAH (MATERI 20 - LOOP + IF)
// =============================================================================
class LoopIfFilterPainter extends CustomPainter {
  final double progress;
  final int activeStep;
  final ThemeData theme;

  LoopIfFilterPainter({required this.progress, required this.activeStep, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;

    // --- WARNA ---
    final beltColor = Colors.grey[850]!;
    final scannerColor = Colors.blueGrey[200]!;
    final glassColor = Colors.lightBlueAccent.withOpacity(0.2);
    
    final binRecycleColor = Colors.blue[600]!;
    final binOrganicColor = Colors.green[600]!;

    // --- 1. GAMBAR LINGKUNGAN (PIPA & BELT) ---
    
    // Posisi Bin
    final binRecyclePos = Offset(cx + 90, cy - 90);
    final binOrganicPos = Offset(cx + 90, cy + 90);

    // Pipa Vakum (Glass Tubes)
    final pathRecycle = Path();
    pathRecycle.moveTo(cx, cy - 40); // Dari atap scanner
    pathRecycle.quadraticBezierTo(cx, binRecyclePos.dy, binRecyclePos.dx - 30, binRecyclePos.dy);
    
    final pathOrganic = Path();
    pathOrganic.moveTo(cx, cy + 40); // Dari bawah scanner
    pathOrganic.quadraticBezierTo(cx, binOrganicPos.dy, binOrganicPos.dx - 30, binOrganicPos.dy);

    // Gambar Pipa
    _drawPipe(canvas, pathRecycle);
    _drawPipe(canvas, pathOrganic);

    // Conveyor Belt (Body)
    final beltRect = Rect.fromCenter(center: Offset(cx - 60, cy), width: 220, height: 20);
    canvas.drawRRect(RRect.fromRectAndRadius(beltRect, const Radius.circular(10)), Paint()..color = beltColor);
    
    // Animasi Pola Belt Berjalan
    // Bergerak terus berdasarkan (activeStep + progress)
    canvas.save();
    canvas.clipRect(beltRect);
    final beltLinePaint = Paint()..color = Colors.grey[600]!..strokeWidth = 3;
    double moveOffset = ((activeStep + progress) * 40) % 20;
    for (double i = beltRect.left; i < beltRect.right; i += 20) {
       canvas.drawLine(Offset(i + moveOffset, beltRect.top), Offset(i + moveOffset - 5, beltRect.bottom), beltLinePaint);
    }
    canvas.restore();

    // Bin (Wadah)
    _drawBin3D(canvas, binRecyclePos, binRecycleColor, "RECYCLE");
    _drawBin3D(canvas, binOrganicPos, binOrganicColor, "ORGANIC");


    // --- 2. LOGIKA ITEM & SORTIR ---
    // Item Data: 0=Botol, 1=Daun, 2=Kaleng
    int currentItemType = 0;
    bool isRecycle = true;
    String itemName = "";

    if (activeStep == 1) { // BOTOL
       currentItemType = 0; isRecycle = true; itemName = "Botol Plastik";
    } else if (activeStep == 2) { // DAUN
       currentItemType = 1; isRecycle = false; itemName = "Daun Kering";
    } else if (activeStep == 3) { // KALENG
       currentItemType = 2; isRecycle = true; itemName = "Kaleng Soda";
    } else { // STEP 0: Intro
       currentItemType = 0; itemName = "Persiapan...";
    }

    // --- 3. ANIMASI PERGERAKAN ITEM ---
    double itemX = cx - 150; 
    double itemY = cy;
    double scale = 1.0;
    
    // Status Scanner
    Color scannerLight = Colors.red; // Standby
    double laserY = cy - 30;
    bool showLaser = false;

    if (activeStep == 0) {
       // Antrian diam
       _drawItem(canvas, Offset(cx - 120, cy), 0);
       _drawItem(canvas, Offset(cx - 160, cy), 1);
    } 
    else {
       // FASE 1: Masuk (0.0 - 0.4)
       if (progress < 0.4) {
          double t = progress / 0.4;
          itemX = (cx - 150) + (t * 150); // Bergerak ke tengah (cx)
          itemY = cy - 10; // Sedikit di atas belt
       } 
       // FASE 2: Scanning (0.4 - 0.6)
       else if (progress < 0.6) {
          itemX = cx;
          itemY = cy - 10;
          showLaser = true;
          
          // Laser bergerak naik turun
          double scanProg = (progress - 0.4) / 0.2;
          laserY = (cy - 30) + (math.sin(scanProg * math.pi * 4) * 25);
          
          // Lampu berubah jadi Kuning (Processing)
          scannerLight = Colors.orange;
       } 
       // FASE 3: Sorting / Keluar (0.6 - 1.0)
       else {
          double t = (progress - 0.6) / 0.4;
          itemX = cx; // X tetap di tengah (karena masuk pipa vertikal)
          
          // Gerak vertikal menuju bin
          double targetY = isRecycle ? binRecyclePos.dy : binOrganicPos.dy;
          
          // Interpolasi posisi (Non-linear biar cepat)
          itemY = (cy - 10) + (t * (targetY - cy)); 
          
          // Gerak Horizontal sedikit mengikuti pipa
          itemX = cx + (t * 60);

          // Mengecil saat masuk bin
          if (t > 0.5) scale = 1.0 - ((t - 0.5) * 2);

          // Lampu Hijau/Biru sesuai hasil
          scannerLight = isRecycle ? Colors.blue : Colors.green;
       }

       // Gambar Item Utama
       if (scale > 0) {
          canvas.save();
          canvas.translate(itemX, itemY);
          canvas.scale(scale);
          _drawItem(canvas, Offset.zero, currentItemType);
          canvas.restore();
       }
    }

    // --- 4. GAMBAR SCANNER (LAYER DEPAN) ---
    final scannerRect = Rect.fromCenter(center: Offset(cx, cy), width: 70, height: 100);
    
    // Box Scanner Belakang (Transparan)
    canvas.drawRRect(RRect.fromRectAndRadius(scannerRect, const Radius.circular(10)), Paint()..color = glassColor);
    canvas.drawRRect(RRect.fromRectAndRadius(scannerRect, const Radius.circular(10)), Paint()..color = Colors.white30..style=PaintingStyle.stroke..strokeWidth=2);

    // Laser Beam
    if (showLaser) {
       canvas.drawLine(Offset(cx - 25, laserY), Offset(cx + 25, laserY), Paint()..color = Colors.redAccent..strokeWidth = 2);
       canvas.drawOval(Rect.fromCenter(center: Offset(cx, laserY), width: 50, height: 10), Paint()..color = Colors.red.withOpacity(0.3));
    }

    // Atap Scanner (Mesin)
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - 50), width: 80, height: 20), Paint()..color = Colors.grey[700]!);
    // Lampu Indikator
    canvas.drawCircle(Offset(cx, cy - 50), 6, Paint()..color = scannerLight);


    // --- 5. UI & TEKS ---
    String statusText = (activeStep == 0) ? "Persiapan..." : "$itemName detected";
    String logicText = "";
    
    if (activeStep == 0) logicText = "System Ready";
    else if (progress < 0.4) logicText = "Conveyor Moving...";
    else if (progress < 0.6) logicText = "Scanning...";
    else logicText = isRecycle ? "IF (Recycle) -> TRUE" : "ELSE (Organic) -> FALSE";

    _drawLabelBubble(canvas, size, statusText);
    _drawLogicBox(canvas, Offset(cx - 80, size.height * 0.9), logicText);
  }

  // --- HELPER METHODS ---

  void _drawPipe(Canvas canvas, Path path) {
    // Pipa Kaca (Tebal & Transparan)
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2)..style=PaintingStyle.stroke..strokeWidth=20);
    // Outline Pipa
    canvas.drawPath(path, Paint()..color = Colors.grey[400]!..style=PaintingStyle.stroke..strokeWidth=2);
  }

  void _drawBin3D(Canvas canvas, Offset center, Color color, String label) {
    double w = 60;
    double h = 70;
    
    // Bagian Dalam (Gelap)
    final topOval = Rect.fromCenter(center: Offset(center.dx, center.dy - h/2), width: w, height: 20);
    canvas.drawOval(topOval, Paint()..color = Colors.black26);

    // Body Bin
    final path = Path();
    path.moveTo(center.dx - w/2, center.dy - h/2);
    path.lineTo(center.dx + w/2, center.dy - h/2);
    path.lineTo(center.dx + w/2 - 5, center.dy + h/2); // Sedikit miring ke bawah
    path.lineTo(center.dx - w/2 + 5, center.dy + h/2);
    path.close();
    
    canvas.drawPath(path, Paint()..color = color);

    // Bibir Bin
    canvas.drawOval(topOval, Paint()..color = color.withOpacity(0.5)..style=PaintingStyle.stroke..strokeWidth=3);
    
    // Label
    TextPainter(text: TextSpan(text: label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)
      ..layout()..paint(canvas, Offset(center.dx - 20, center.dy));
  }

  void _drawItem(Canvas canvas, Offset center, int type) {
    // 0: Botol, 1: Daun, 2: Kaleng
    if (type == 0) { // BOTOL
       final p = Paint()..color = Colors.lightBlue[200]!;
       // Badan
       canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center + const Offset(0, 5), width: 18, height: 25), const Radius.circular(4)), p);
       // Leher
       canvas.drawRect(Rect.fromCenter(center: center + const Offset(0, -12), width: 8, height: 10), p);
       // Tutup
       canvas.drawRect(Rect.fromCenter(center: center + const Offset(0, -18), width: 10, height: 4), Paint()..color = Colors.blue[900]!);
    } 
    else if (type == 1) { // DAUN
       final p = Paint()..color = Colors.greenAccent[700]!;
       final path = Path();
       path.moveTo(center.dx, center.dy - 15);
       path.quadraticBezierTo(center.dx + 15, center.dy, center.dx, center.dy + 15);
       path.quadraticBezierTo(center.dx - 15, center.dy, center.dx, center.dy - 15);
       canvas.drawPath(path, p);
       // Tulang daun
       canvas.drawLine(Offset(center.dx, center.dy - 15), Offset(center.dx, center.dy + 10), Paint()..color = Colors.green[900]!);
    } 
    else { // KALENG
       final p = Paint()..color = Colors.redAccent;
       final rect = Rect.fromCenter(center: center, width: 22, height: 30);
       canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), p);
       // Detail Metal
       canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, 3), Paint()..color = Colors.grey[300]!);
       canvas.drawRect(Rect.fromLTWH(rect.left, rect.bottom - 3, rect.width, 3), Paint()..color = Colors.grey[300]!);
       TextPainter(text: const TextSpan(text: "SODA", style: TextStyle(color: Colors.white, fontSize: 5, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)
         ..layout()..paint(canvas, Offset(center.dx - 8, center.dy - 3));
    }
  }

  void _drawLabelBubble(Canvas canvas, Size size, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), textDirection: TextDirection.ltr)..layout();
    final bubbleRect = Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.15), width: textPainter.width + 30, height: textPainter.height + 20);
    canvas.drawRRect(RRect.fromRectAndRadius(bubbleRect, const Radius.circular(20)), Paint()..color = Colors.indigo);
    textPainter.paint(canvas, Offset(bubbleRect.center.dx - textPainter.width/2, bubbleRect.center.dy - textPainter.height/2));
  }

  void _drawLogicBox(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')), textDirection: TextDirection.ltr)..layout();
    final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 20, height: textPainter.height + 10);
    
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.white.withOpacity(0.9));
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = Colors.black87..style=PaintingStyle.stroke..strokeWidth=1);
    
    textPainter.paint(canvas, Offset(center.dx - textPainter.width/2, center.dy - textPainter.height/2));
  }

  @override
  bool shouldRepaint(covariant LoopIfFilterPainter old) => old.progress != progress || old.activeStep != activeStep;
}