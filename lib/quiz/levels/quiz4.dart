import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz4 extends StatelessWidget {
  const Quiz4({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 4: Kode Rahasia",
      instruction: "Markas Agen Rahasia butuh sistem status otomatis yang Cepat & Efisien! \n\nUbah logika deteksi ini menjadi **satu baris** menggunakan **Ternary Operator**. \n\nJika `adaMusuh` bernilai True, status jadi 'BAHAYA', jika tidak 'AMAN'.",
      
      baseScore: 15, 

      initialDuration: Duration(minutes: 8),
      // KODE YANG DIPECAH
      codeSnippet: [
        "bool adaMusuh = true;",
        "\n// Tentukan status dalam 1 baris:",
        "\n// (Syarat) ? Benar : Salah",
        "\nString status = adaMusuh", "___", "true",
        "\n                ", "___", "'BAHAYA'",
        "\n                ", "___", "'AMAN';",
        "\n\nprint(status); // Output: BAHAYA"
      ],
      
      // OPSI JAWABAN
      options: [
        "==",       // Benar (Komparasi)
        "?",        // Benar (Tanya)
        ":",        // Benar (Titik Dua)
        "if",       // Pengecoh
        "else",     // Pengecoh
        "=",        // Pengecoh (Assignment)
        "&&",       // Pengecoh
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "==",    
  1: "?",     
  2: ":",    
},
    );
  }
}