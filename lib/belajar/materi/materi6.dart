import 'package:flutter/material.dart';
import '../widgets/material_learning_screen.dart'; // Template UI Baru
import '../data/materi_data.dart'; // Data Source

class Materi6 extends StatelessWidget {
  const Materi6({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialLearningScreen(
      content: MateriData.getMateri(6), // Ambil data Materi 1
    );
  }
}