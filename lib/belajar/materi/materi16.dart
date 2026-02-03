import 'package:flutter/material.dart';
import '../widgets/material_learning_screen.dart'; // Template UI Baru
import '../data/materi_data.dart'; // Data Source

class Materi16 extends StatelessWidget {
  const Materi16({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialLearningScreen(
      content: MateriData.getMateri(16), // Ambil data Materi 1
    );
  }
}