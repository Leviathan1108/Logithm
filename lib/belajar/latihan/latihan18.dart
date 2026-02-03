import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan18 extends StatelessWidget {
  const Latihan18({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 18, // ID Materi: Infinite Loop
      title: "Latihan: Jebakan Loop",
      
      // Mengambil dari Analogi: Sampo
      question: 
        "Di belakang botol sampo tertulis instruksi konyol: '1. Usap, 2. Bilas, 3. Ulangi'.\n\n"
        "Jika robot yang sangat patuh membaca ini, apa yang akan terjadi?",
      
      options: [
        "A. Robot akan keramas selamanya sampai rusak (Infinite Loop).", // Jawaban Benar
        "B. Robot akan berhenti setelah 3 kali bilas.",
        "C. Robot akan bertanya 'Kapan berhentinya?'.",
        "D. Robot akan mengabaikan instruksi itu."
      ],
      
      // KUNCI JAWABAN (Index ke-0 benar)
      correctAnswerIndex: 0,

      // PENJELASAN
      explanations: [
        // A (Benar)
        "Tepat! Ini disebut 'Infinite Loop' (Pengulangan Tak Terbatas). Karena tidak ada syarat 'Kapan Harus Berhenti' (Stop Condition), komputer akan terjebak selamanya.",
        // B
        "Salah. Di instruksi tidak ada tulisan '3 kali'. Komputer tidak bisa menebak angka.",
        // C
        "Salah. Robot/Komputer standar tidak punya kesadaran untuk bertanya.",
        // D
        "Salah. Komputer wajib menjalankan instruksi program.",
      ],
    );
  }
}