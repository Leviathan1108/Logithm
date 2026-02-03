import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz5 extends StatelessWidget {
  const Quiz5({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 5: Array Hacker",
      instruction: "Sistem keamanan bobol! \n\nKamu harus melakukan *patching* (perbaikan) pada setiap server yang ada di dalam daftar database. \n\nGunakan **For Loop** untuk mengakses setiap server satu per satu berdasarkan indeks-nya.",
      
      baseScore: 20, 

      initialDuration: Duration(minutes: 12),
      // KODE YANG DIPECAH
      codeSnippet: [
        "List<String> servers = ['Alpha', 'Beta', 'Gamma'];",
        "\n\nvoid patchAllSystems() {",
        "\n  // Ulangi dari index 0 sampai akhir list",
        "\n  for (int i = 0; i < servers.length; i", "___", ") {",
        "\n    ",
        "\n    // Ambil nama server pada posisi 'i'",
        "\n    String target = servers[", "___", "];",
        "\n    ",
        "\n    deployFix(target);",
        "\n  }",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "++",       // Benar (Increment)
        "i",        // Benar (Index Variable)
        "--",       // Pengecoh (Loop mundur/Infinite)
        "0",        // Pengecoh (Hanya ambil item pertama)
        "int",      // Pengecoh (Tipe data)
        "length",   // Pengecoh (Properti)
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "++",    
  1: "i",     
},
    );
  }
}