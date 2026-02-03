import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz9 extends StatelessWidget {
  const Quiz9({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 9: Memory Saver",
      instruction: "RAM Penuh! Kamu harus membuat skrip pembersih memori otomatis. \n\nTugas: Matikan semua aplikasi KECUALI **'System'**. Jika 'System' dimatikan, HP akan crash! \n\nLengkapi kode untuk **melewati (skip)** proses System.",
      
      baseScore: 20, 
      
      initialDuration: Duration(minutes: 15),
      // KODE YANG DIPECAH
      codeSnippet: [
        "List<String> apps = ['Game', 'System', 'Browser'];",
        "\n\nfor (String app in apps) {",
        "\n  // Safety Check: Jangan sentuh System",
        "\n  if (app ", "___", " 'System') {",
        "\n    print('Skipping kernel...');",
        "\n    ", "___", "; // Lanjut ke item berikutnya",
        "\n  }",
        "\n",
        "\n  // Matikan aplikasi lain",
        "\n  killProcess(app);",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "==",       // Benar (Cek kesamaan)
        "continue", // Benar (Skip)
        "!=",       // Pengecoh (Salah logika)
        "break",    // Pengecoh (Berhenti total, RAM tidak bersih)
        "return",   // Pengecoh (Keluar fungsi)
        "exit",     // Pengecoh
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "==",       
  1: "continue", 
},
    );
  }
}