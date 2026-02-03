import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz2 extends StatelessWidget {
  const Quiz2({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 2: Kode Brankas",
      instruction: "Kamu adalah teknisi keamanan Bank. \nSistem brankas macet! \n\nAturannya: Pintu hanya terbuka jika PIN Benar **DAN** Sidik Jari Cocok. Lengkapi kode di bawah ini.",
      
      baseScore: 20, 

      initialDuration: Duration(minutes: 10),
      codeSnippet: [
        "bool pinBenar = true;",
        "\nbool sidikJari = true;",
        "\n\n// Cek Keamanan Ganda",
        "\nif (pinBenar ", "___", " sidikJari) {",
        "\n  // Jika Sukses",
        "\n  system = ", "___", ";",
        "\n} else {",
        "\n  // Jika Gagal",
        "\n  system = ", "___", ";",
        "\n}"
      ],
      
      // OPSI JAWABAN
      options: [
        "&&",             // Operator AND (Benar)
        "||",             // Operator OR (Salah)
        "'BUKA_PINTU'",   // Aksi Sukses
        "'BUNYIKAN_ALARM'", // Aksi Gagal
        "'ERROR_404'",    // Pengecoh
        "!",              // Pengecoh
      ],
      
      // KUNCI JAWABAN
      correctAnswers: {
  0: "&&",              // Lubang pertama
  1: "'BUKA_PINTU'",    // Lubang kedua
  2: "'BUNYIKAN_ALARM'", // Lubang ketiga
},
    );
  }
}