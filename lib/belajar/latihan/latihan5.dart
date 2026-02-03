import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan5 extends StatelessWidget {
  const Latihan5({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 5, // Judul: Percabangan Dua Arah
      title: "Latihan: Pilihan Ganda",
      
      // Mengambil dari Analogi: Ujian
      question: 
        "Guru membuat aturan nilai: Syarat Lulus adalah nilai di atas 70.\n\n"
        "Bagaimana logika IF-ELSE yang benar untuk Budi yang mendapat nilai 50?",
      
      options: [
        "JIKA (Nilai > 70) MAKA Lulus. (Budi Lulus)",
        "JIKA (Nilai > 70) MAKA Lulus, SELAIN ITU Remidi. (Budi Remidi)", // Jawaban Benar
        "JIKA (Nilai < 70) MAKA Lulus. (Budi Lulus)",
        "SELAIN ITU MAKA Lulus."
      ],
      
      correctAnswerIndex: 1, // B

      explanations: [
        "Salah. Nilai Budi 50, itu tidak lebih besar dari 70. Jadi kondisi ini FALSE.",
        "Tepat! Karena 50 tidak lebih besar dari 70, maka komputer mengambil jalan 'SELAIN ITU' (Else), yaitu Remidi.",
        "Salah Logika. Masa nilai kecil malah lulus?",
        "Error. Tidak boleh ada 'SELAIN ITU' (Else) tanpa 'JIKA' (If) di depannya."
      ],
    );
  }
}