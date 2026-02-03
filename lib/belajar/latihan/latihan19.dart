import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan19 extends StatelessWidget {
  const Latihan19({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 19, // ID Materi: Break Statement
      title: "Latihan: Berhenti Paksa",
      
      // Mengambil dari Analogi: Alarm Kebakaran
      question: 
        "Siswa sedang belajar di kelas (Looping dari jam 7 s.d 15).\n"
        "Tiba-tiba jam 10 pagi, ALARM KEBAKARAN berbunyi!\n\n"
        "Perintah apa yang HARUS dijalankan agar semua siswa selamat?",
      
      options: [
        "A. CONTINUE (Abaikan alarm, lanjut belajar sampai jam 15).",
        "B. RESTART (Ulangi pelajaran dari jam 7 pagi).",
        "C. BREAK (Hentikan pelajaran SEKARANG JUGA dan keluar).", // Jawaban Benar
        "D. IF - ELSE (Jika api kecil lanjut, jika besar lari)."
      ],
      
      // KUNCI JAWABAN (Index ke-2 benar)
      correctAnswerIndex: 2,

      // PENJELASAN
      explanations: [
        // A
        "Salah dan Berbahaya. Continue artinya 'Lanjut ke putaran berikutnya'. Kamu bisa terbakar.",
        // B
        "Salah. Situasi darurat bukan waktunya mengulang dari awal.",
        // C (Benar)
        "Tepat! Perintah BREAK memaksa program (kegiatan belajar) berhenti total detik itu juga, meskipun waktu belajar (Loop) belum habis.",
        // D
        "Salah. Jangan ambil risiko. Jika ada 'Error Fatal' (Kebakaran), solusinya adalah berhenti total (Break), bukan memilih-milih.",
      ],
    );
  }
}