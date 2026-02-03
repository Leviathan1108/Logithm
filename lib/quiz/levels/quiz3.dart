import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz3 extends StatelessWidget {
  const Quiz3({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 3: Looping Labirin",
      instruction: "Robot Explorer terjebak di lorong gelap! \n\nDia harus berjalan maju sebanyak 10 langkah untuk mencapai pintu keluar. Susun logika **Perulangan (Loop)** agar robot berjalan otomatis sampai tujuan.",
      
      baseScore: 25, 

      initialDuration: Duration(minutes: 15),
      // KODE YANG DIPECAH
      codeSnippet: [
        "int langkah = 0;",
        "\nint pintuKeluar = 10;",
        "\n\n// Ulangi selama belum sampai (langkah < 10)",
        "\n", "___", " (langkah < pintuKeluar) {",
        "\n  robot.maju();",
        "\n  print('Langkah ke: ' + langkah);",
        "\n  // Jangan lupa update hitungan!",
        "\n  langkah", "___", ";",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "while",    // Benar (Looping)
        "if",       // Pengecoh (Hanya jalan sekali)
        "++",       // Benar (Increment/Maju)
        "--",       // Pengecoh (Decrement/Mundur - Infinite Loop)
        "break",    // Pengecoh (Berhenti mendadak)
        "for",      // Pengecoh (Sintaks tidak cocok di sini)
      ],
      
      // KUNCI JAWABAN
      // Index dihitung dari elemen codeSnippet (termasuk enter/spasi yang dipisah koma)
      correctAnswers: {
  0: "while", 
  1: "++",    
},
    );
  }
}