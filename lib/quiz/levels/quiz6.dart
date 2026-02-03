import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz6 extends StatelessWidget {
  const Quiz6({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 6: Pabrik Robot",
      instruction: "Robot perakit sedang error! \n\nSistem mengharuskan robot untuk **memutar obeng minimal satu kali** sebelum mengecek apakah baut sudah kencang.\n\nSusun logika **Do-While** yang tepat!",
      
      baseScore: 20, 
      
      initialDuration: Duration(minutes: 12),
      // KODE YANG DIPECAH
      codeSnippet: [
        "bool bautLonggar = true;",
        "\n\n// Lakukan kerja minimal 1x",
        "\n// Baru cek kondisi",
        "\n", "___", " {",
        "\n  robot.putarObeng();",
        "\n  ",
        "\n  // Update sensor",
        "\n  bautLonggar = sensor.scan();",
        "\n} ", "___", " (bautLonggar == true);"
      ],
      
      // OPSI JAWABAN
      options: [
        "do",       // Benar (Awal Do-While)
        "while",    // Benar (Akhir Do-While)
        "if",       // Pengecoh
        "for",      // Pengecoh
        "return",   // Pengecoh
        "else",     // Pengecoh
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "do",    
  1: "while", 
},
    );
  }
}