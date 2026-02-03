import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan3 extends StatelessWidget {
  const Latihan3({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 3, // Judul: Sekuensial
      title: "Latihan: Urutan Eksekusi",
      
      // Mengambil dari Code Example: Memakai Sepatu
      question: 
        "Dalam algoritma Sekuensial, urutan baris sangat penting.\n\n"
        "Manakah urutan algoritma 'Pergi Sekolah' yang logis?",
      
      options: [
        "1. Pakai Sepatu -> 2. Pakai Kaus Kaki -> 3. Jalan.",
        "1. Jalan -> 2. Pakai Sepatu -> 3. Pakai Kaus Kaki.",
        "1. Pakai Kaus Kaki -> 2. Pakai Sepatu -> 3. Jalan.", // Jawaban Benar
        "1. Pakai Kaus Kaki -> 2. Jalan -> 3. Pakai Sepatu."
      ],
      
      correctAnswerIndex: 2, // C

      explanations: [
        "Salah. Kamu tidak bisa memakai kaus kaki SETELAH sepatu terpasang (Kecuali kamu Superman).",
        "Salah. Kamu harus siap dulu baru jalan. Komputer membaca dari atas ke bawah.",
        "Tepat! Ini adalah urutan sekuensial yang benar. Langkah A selesai, lanjut Langkah B, lalu C.",
        "Salah. Jangan jalan dulu sebelum sepatu terpasang."
      ],
    );
  }
}