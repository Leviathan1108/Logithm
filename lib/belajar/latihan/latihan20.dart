import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan20 extends StatelessWidget {
  const Latihan20({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 20, // ID Materi: Kombinasi Loop + If
      title: "Latihan: Logika Kompleks",
      
      // Mengambil dari Analogi: Sortir Buah
      question: 
        "Di pabrik apel, ada ribuan apel berjalan di mesin (Conveyor Belt).\n"
        "Kita ingin memisahkan: Apel Bagus -> Dijual, Apel Busuk -> Dibuang.\n\n"
        "Bagaimana kombinasi logika yang BENAR?",
      
      options: [
        "A. LOOPING (untuk cek semua apel) + IF (untuk cek kondisi busuk/bagus).", // Jawaban Benar
        "B. HANYA IF (Cek satu apel saja, sisanya biarkan).",
        "C. HANYA LOOPING (Ambil semua apel termasuk yang busuk).",
        "D. SWITCH CASE (Pilih menu apel).",
      ],
      
      // KUNCI JAWABAN (Index ke-0 benar)
      correctAnswerIndex: 0,

      // PENJELASAN
      explanations: [
        // A (Benar)
        "Sempurna! Ini adalah penerapan algoritma dunia nyata. LOOP digunakan untuk menangani JUMLAH (Banyak Apel), dan IF digunakan untuk menangani KONDISI (Bagus/Busuk).",
        // B
        "Salah. Jika cuma pakai IF, kamu hanya mengecek apel pertama. Ribuan apel di belakangnya tidak akan dicek.",
        // C
        "Salah. Jika cuma pakai LOOP tanpa IF, kamu akan menjual apel busuk ke pelanggan. Pabrik bisa bangkrut.",
        // D
        "Salah. Ini bukan soal memilih menu, tapi menyortir data satu per satu.",
      ],
    );
  }
}