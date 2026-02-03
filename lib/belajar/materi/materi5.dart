import 'package:flutter/material.dart';
import '../widgets/material_learning_screen.dart'; // Template UI Baru
import '../data/materi_data.dart'; // Data Source

class Materi5 extends StatelessWidget {
  const Materi5({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialLearningScreen(
      content: MateriData.getMateri(5), // Ambil data Materi 1
    );
  }
}