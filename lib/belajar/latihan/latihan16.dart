import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan16 extends StatelessWidget {
  const Latihan16({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 16, // ID Materi: Variabel Counter
      title: "Latihan: Menghitung Jumlah",
      
      // Mengambil dari Analogi: Papan Skor / Turus
      question: 
        "Dalam pertandingan basket, setiap kali bola masuk ring, petugas harus menaikkan skor.\n\n"
        "Rumus logika 'Counter' manakah yang benar untuk menambah nilai skor sebanyak 1 poin?",
      
      options: [
        "A. Skor = 1 (Skor selalu kembali jadi satu).",
        "B. Skor = Skor + 1 (Skor lama ditambah satu).", // Jawaban Benar
        "C. Skor = Skor * 1 (Skor dikali satu, tidak berubah).",
        "D. Skor = 0 (Skor di-reset)."
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // A
        "Salah. Ini namanya 'Assignment' biasa. Jika skor awalnya 10, lalu kamu set 'Skor = 1', maka skornya malah turun jadi 1.",
        // B (Benar)
        "Tepat Sekali! Konsep Counter adalah mengambil nilai yang sudah ada di memori, menambahkannya dengan 1, lalu menyimpannya kembali.",
        // C
        "Salah. Angka berapapun dikali 1 hasilnya tetap sama. Skor tidak akan bertambah.",
        // D
        "Salah. Ini malah menghapus semua skor menjadi nol.",
      ],
    );
  }
}