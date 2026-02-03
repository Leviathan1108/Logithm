import 'package:flutter/material.dart';

class FullScreenVisualization extends StatefulWidget {
  final String title;
  final Duration duration;
  final Widget Function(AnimationController controller) animationBuilder;

  const FullScreenVisualization({
    super.key,
    required this.title,
    required this.duration,
    required this.animationBuilder,
  });

  @override
  State<FullScreenVisualization> createState() => _FullScreenVisualizationState();
}

class _FullScreenVisualizationState extends State<FullScreenVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Logika Tutup Otomatis saat selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () { // Jeda 1 detik biar user sadar sudah selesai
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Mode Background agar fokus
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- HEADER KECIL ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Visualisasi: ${widget.title}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  // Tombol Tutup Manual
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),

            // --- AREA VISUALISASI UTAMA ---
            // Menggunakan Expanded agar memenuhi sisa layar
            Expanded(
              child: Container(
                width: double.infinity, // Paksa lebar penuh
                padding: const EdgeInsets.all(16.0),
                child: widget.animationBuilder(_controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}