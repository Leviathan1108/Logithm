import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan10 extends StatelessWidget {
  const Latihan10({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 10, // ID Materi: Percabangan Bersarang (Nested If)
      title: "Latihan: Percabangan Dalam Percabangan",
      
      // Mengambil dari Analogi: Seleksi TNI / Tahapan Seleksi
      question: 
        "Sistem seleksi TNI menggunakan logika 'Nested If' (Bertingkat):\n\n"
        "1. JIKA (Lulus Tes Fisik) MAKA Lanjut Cek Kesehatan.\n"
        "   -> (Di dalam): JIKA (Lulus Tes Kesehatan) MAKA Diterima.\n"
        "   -> (Di dalam): SELAIN ITU (Gagal Kesehatan) MAKA Gugur di Tahap 2.\n"
        "2. SELAIN ITU (Gagal Tes Fisik) MAKA Gugur di Tahap 1.\n\n"
        "Kasus: Budi LULUS Tes Fisik, tapi GAGAL Tes Kesehatan. Apa status Budi?",
      
      options: [
        "Budi Diterima menjadi TNI.",
        "Budi Gugur di Tahap 1 (Gagal Fisik).",
        "Budi Gugur di Tahap 2 (Gagal Kesehatan).", // Jawaban Benar
        "Budi Lulus bersyarat."
      ],
      
      // KUNCI JAWABAN (Index ke-2 benar)
      correctAnswerIndex: 2,

      // PENJELASAN
      explanations: [
        // Opsi A
        "Salah. Syarat diterima adalah lulus KEDUANYA. Budi gagal di tes kedua, jadi tidak bisa diterima.",
        
        // Opsi B
        "Salah. Budi SUDAH Lulus Tes Fisik. Jadi dia tidak mungkin gugur di tahap 1. Dia berhak masuk ke 'blok dalam' (Inner If).",
        
        // Opsi C (Benar)
        "Tepat Sekali! Budi berhasil melewati pintu pertama (Outer If), tapi terhenti di pintu kedua (Inner If). Inilah konsep 'Bersarang'.",
        
        // Opsi D
        "Salah. Komputer bekerja pasti (Hitam/Putih). Jika kondisinya 'Gagal', maka aksinya 'Gugur'. Tidak ada status abu-abu.",
      ],
    );
  }
}