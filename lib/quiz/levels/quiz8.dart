import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz8 extends StatelessWidget {
  const Quiz8({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 8: Bug Hunter 2",
      instruction: "Sistem Radar macet total! 🚨\n\nProgrammer ceroboh salah memasukkan variabel counter pada **Loop Dalam**, sehingga loop tidak pernah berhenti (*Infinite Loop*). \n\nPerbaiki kodenya agar radar bisa memindai Baris dan Kolom dengan benar.",
      
      baseScore: 25, 
      
      initialDuration: Duration(minutes: 20),
      // KODE YANG DIPECAH
      codeSnippet: [
        "// Scan area 5x5",
        "\nfor (int i = 0; i < 5; i++) {",
        "\n  print('Scan Baris ' + i);",
        "\n  ",
        "\n  // Loop Dalam (Counter: j)",
        "\n  for (int j = 0; j < 5; ", "___", ") {",
        "\n    ",
        "\n    // Scan koordinat [i, j]",
        "\n    radar.scan(i, ", "___", ");",
        "\n  }",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "j++",      // Benar (Increment j)
        "i++",      // Pengecoh (Penyebab Infinite Loop - Fatal Bug!)
        "j",        // Benar (Variabel koordinat)
        "i",        // Pengecoh (Salah koordinat)
        "j--",      // Pengecoh (Mundur/Infinite)
        "0",        // Pengecoh
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "j++",   
  1: "j",     
},
    );
  }
}