import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan11 extends StatelessWidget {
  const Latihan11({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 11, // ID Materi: Switch Case
      title: "Latihan: Seleksi Menu",
      
      // Mengambil dari Analogi: Vending Machine
      question: 
        "Kita sedang memprogram 'Vending Machine'.\n"
        "Mesin punya banyak tombol menu spesifik:\n"
        "- Tombol 'A': Keluarkan Air Mineral\n"
        "- Tombol 'B': Keluarkan Cola\n"
        "- Tombol 'C': Keluarkan Jus\n\n"
        "Struktur kontrol apa yang PALING RAPI dan TEPAT untuk kasus 'Pilih Menu' seperti ini?",
      
      options: [
        "A. LOOPING (Ulangi terus sampai tombol ditekan).",
        "B. SWITCH - CASE (Cek tombol: Kasus A, Kasus B, dst).", // Jawaban Benar
        "C. IF - ELSE bertingkat sampai 100 kali.",
        "D. BREAK (Hentikan mesin).",
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // Opsi A
        "Salah. Looping digunakan untuk mengulang aksi, bukan untuk memilih satu opsi dari banyak menu.",
        
        // Opsi B (Benar)
        "Tepat Sekali! Switch Case didesain khusus untuk situasi 'Satu Variabel (Tombol), Banyak Nilai Tetap (A, B, C)'. Kodenya jauh lebih bersih daripada If-Else panjang.",
        
        // Opsi C
        "Kurang Efisien. Meskipun bisa jalan, tapi bayangkan jika ada 100 tombol. Kodenya akan sangat panjang dan sulit dibaca (Spaghetti Code).",
        
        // Opsi D
        "Salah. Break hanyalah perintah untuk berhenti, bukan struktur logika untuk memilih menu.",
      ],
    );
  }
}