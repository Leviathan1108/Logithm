import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan7 extends StatelessWidget {
  const Latihan7({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 7, // ID Materi: Percabangan Majemuk (Else-If)
      title: "Latihan: Percabangan Bertingkat",
      
      // Mengambil dari Analogi: Ukuran Baju
      question: 
        "Toko baju menggunakan logika komputer untuk memberikan baju sesuai kode ukuran:\n\n"
        "1. JIKA (Kode == 'S') MAKA Ambil Baju KECIL.\n"
        "2. ATAU JIKA (Kode == 'M') MAKA Ambil Baju SEDANG.\n"
        "3. ATAU JIKA (Kode == 'L') MAKA Ambil Baju BESAR.\n"
        "4. SELAIN ITU (Else) Ambil Baju JUMBO (XL).\n\n"
        "Pembeli memasukkan Kode 'M'. Baju apa yang keluar?",
      
      options: [
        "Baju KECIL.",
        "Baju SEDANG.", // Jawaban Benar
        "Baju BESAR.",
        "Baju SEDANG dan Baju BESAR sekaligus."
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // Opsi A
        "Salah. Komputer mengecek syarat pertama (Kode == 'S'). Karena 'M' tidak sama dengan 'S', maka syarat ini GAGAL dan dilewati.",
        
        // Opsi B (Benar)
        "Tepat! Syarat pertama gagal, lalu komputer masuk ke 'ATAU JIKA' yang kedua (Kode == 'M'). Karena COCOK, maka aksi 'Ambil Baju Sedang' dijalankan.",
        
        // Opsi C
        "Salah. Komputer membaca dari atas. Karena sudah menemukan yang cocok di langkah ke-2 (Size M), komputer TIDAK AKAN mengecek langkah ke-3 (Size L) lagi.",
        
        // Opsi D
        "Salah Fatal. Dalam percabangan Else-If, hanya SATU pilihan yang boleh diambil. Tidak bisa mengambil dua jalur sekaligus.",
      ],
    );
  }
}