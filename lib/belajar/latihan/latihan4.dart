import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan4 extends StatelessWidget {
  const Latihan4({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 4, // Judul: Logika Percabangan (If)
      title: "Latihan: Kondisi Tunggal",
      
      // Mengambil dari Code Example: Hujan
      question: 
        "Kita ingin membuat robot yang pintar menjaga diri.\n"
        "Logika IF manakah yang benar agar robot tidak basah kuyup?",
      
      options: [
        "JIKA (Cerah) MAKA Buka Payung.",
        "JIKA (Hujan Turun) MAKA Buka Payung.", // Jawaban Benar
        "JIKA (Lapar) MAKA Buka Payung.",
        "JIKA (Hujan Turun) MAKA Pakai Kacamata Hitam."
      ],
      
      correctAnswerIndex: 1, // B

      explanations: [
        "Salah. Jika cerah, payung tidak dibutuhkan. Kondisi tidak sesuai aksi.",
        "Tepat! Kondisinya adalah 'Hujan', maka Aksinya adalah 'Buka Payung'. Jika tidak hujan, aksi tidak dijalankan.",
        "Salah. Kondisi 'Lapar' tidak relevan dengan solusi 'Payung'.",
        "Salah. Aksinya tidak menyelesaikan masalah (Robot tetap basah)."
      ],
    );
  }
}