import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz7 extends StatelessWidget {
  const Quiz7({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 7: Bug Hunter",
      instruction: "Program antivirus ini boros memori! \n\nDia terus memindai file lain padahal virus utama sudah ditemukan. \n\nTambahkan perintah yang tepat untuk **menghentikan loop** segera setelah virus terdeteksi.",
      
      baseScore: 25, 
      
      initialDuration: Duration(minutes: 10),
      // KODE YANG DIPECAH
      codeSnippet: [
        "List<String> files = ['Safe', 'Virus', 'Safe'];",
        "\n\nfor (String file in files) {",
        "\n  print('Scanning ' + file);",
        "\n  ",
        "\n  if (file == 'Virus') {",
        "\n    print('BAHAYA DITEMUKAN!');",
        "\n    // Hentikan proses scan!",
        "\n    ", "___", ";",
        "\n  }",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "break",    // Benar (Keluar dari loop)
        "continue", // Pengecoh (Lanjut ke iterasi berikutnya)
        "stop",     // Pengecoh (Bukan keyword Dart)
        "exit",     // Pengecoh
        "return",   // Pengecoh (Keluar fungsi, bukan cuma loop)
        "pause",    // Pengecoh
      ],
      
      // KUNCI JAWABAN
      // Index ke-7 adalah posisi "___" dalam list codeSnippet di atas
     correctAnswers: {
  0: "break",
},
    );
  }
}