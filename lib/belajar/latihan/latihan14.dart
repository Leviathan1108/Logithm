import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan14 extends StatelessWidget {
  const Latihan14({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 14, // ID Materi: While Loop
      title: "Latihan: Kondisi Belum Pasti",
      
      // Mengambil dari Analogi: Isi Bensin
      question: 
        "Kita sedang mengisi bensin. Kita TIDAK TAHU butuh berapa liter pasnya, tapi kita tahu kita harus berhenti saat tangki penuh.\n\n"
        "Logika: 'SELAMA (Tangki Belum Penuh), Terus isi bensin'.\n"
        "Ini adalah contoh dari...",
      
      options: [
        "A. WHILE Loop (Uncounted Loop).", // Jawaban Benar ada di awal
        "B. FOR Loop (Counted Loop).",
        "C. SEQUENCE (Berurutan).",
        "D. SWITCH CASE (Pilihan Menu)."
      ],
      
      // KUNCI JAWABAN (Index ke-0 benar)
      correctAnswerIndex: 0,

      // PENJELASAN
      explanations: [
        // A (Benar)
        "Tepat! While Loop digunakan ketika kita tidak tahu jumlah putarannya (liter bensinnya), tapi kita punya satu SYARAT untuk berhenti (Tangki Penuh).",
        // B
        "Salah. For Loop butuh angka pasti (misal: Isi 5 Liter). Kalau pakai For, nanti bensinnya bisa tumpah kalau tangki sudah penuh duluan.",
        // C
        "Salah. Mengisi bensin itu proses berulang (tetes demi tetes), bukan sekadar urutan langkah sekali jalan.",
        // D
        "Salah. Tidak ada menu pilihan di sini. Hanya ada satu aksi: Isi Bensin.",
      ],
    );
  }
}