import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz10 extends StatelessWidget {
  const Quiz10({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 10: The Final Boss",
      instruction: "PERTARUNGAN TERAKHIR! ⚔️\n\nKalahkan Boss Monster (HP: 500) dengan seranganmu. \n\nAturan Strategi:\n1. **Hemat Stamina**: Jika serangan `0` (meleset), lewati giliran (`continue`).\n2. **Serang**: Kurangi HP Boss (`-=`).\n3. **Menang**: Jika HP Boss habis, hentikan pertarungan segera (`break`).",
      
      baseScore: 30, 
      
      initialDuration: Duration(minutes: 30),
      // KODE YANG DIPECAH
      codeSnippet: [
        "int bossHP = 500;",
        "\nList<int> attacks = [0, 200, 400, 100];",
        "\n\nfor (int dmg in attacks) {",
        "\n  // 1. Jika meleset, lewati giliran",
        "\n  if (dmg == 0) ", "___", ";",
        "\n",
        "\n  // 2. Berikan Damage (Kurangi HP)",
        "\n  bossHP ", "___", " dmg;",
        "\n",
        "\n  // 3. Cek Kemenangan",
        "\n  if (bossHP <= 0) {",
        "\n    print('VICTORY!');",
        "\n    ", "___", "; // Stop Loop",
        "\n  }",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "continue", // Benar (Skip)
        "-=",       // Benar (Kurangi nilai variabel)
        "break",    // Benar (Stop loop)
        "+=",       // Pengecoh (Malah nambah darah boss)
        "return",   // Pengecoh
        "=",        // Pengecoh (Assignment biasa)
        "stop",     // Pengecoh
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "continue", 
  1: "-=",       
  2: "break",   
},
    );
  }
}