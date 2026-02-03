import 'package:flutter/material.dart';
import '../drag_drop_quiz.dart';

class Quiz1 extends StatelessWidget {
  const Quiz1({super.key});

  @override
  Widget build(BuildContext context) {
    return const DragDropQuiz(
      title: "Level 1: Robot Hero",
      instruction: "Gawat! Ada kebakaran di lantai 3. Robot Pemadam bingung harus melakukan apa duluan. \n\nBantu susun algoritma fungsi robot agar api bisa padam dengan selamat!",
      
      // [PERBAIKAN] Tambahkan baseScore agar level terdeteksi sebagai Easy
      baseScore: 15, 

      // Set Durasi sesuai metadata di quiz_page (5 min)
      initialDuration: Duration(minutes: 5),

      codeSnippet: [
        "void actionRescue() {",
        "\n  // 1. Deteksi bahaya",
        "\n  ", "___", ";", 
        "\n  // 2. Menuju lokasi",
        "\n  ", "___", ";",
        "\n  // 3. Persiapan alat",
        "\n  ", "___", ";",
        "\n  // 4. Eksekusi",
        "\n  ", "___", ";",
        "\n}"
      ],
      
      options: [
        "gerakKeLokasi()",
        "semprotAir()",
        "scanPanas()",
        "siapkanSelang()",
        "tidurDulu()", 
        "selfie()",    
      ],
      
      correctAnswers: {
        0: "scanPanas()",      
        1: "gerakKeLokasi()",  
        2: "siapkanSelang()",  
        3: "semprotAir()",     
      },
    );
  }
}