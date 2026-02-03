import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan15 extends StatelessWidget {
  const Latihan15({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 15, // ID Materi: Do-While Loop
      title: "Latihan: Coba Dulu",
      
      // Mengambil dari Analogi: Cicip Masakan
      question: 
        "Seorang Koki ingin memastikan rasa supnya pas. \n"
        "Logikanya: Dia HARUS mencicipi supnya minimal satu kali dulu. Setelah dicicipi, baru dia cek apakah perlu tambah garam atau berhenti.\n\n"
        "Struktur apa yang menjamin aksi dilakukan MINIMAL SATU KALI sebelum cek syarat?",
      
      options: [
        "A. FOR Loop.",
        "B. WHILE Loop.",
        "C. DO-WHILE Loop.", // Jawaban Benar ada di tengah
        "D. IF - ELSE."
      ],
      
      // KUNCI JAWABAN (Index ke-2 benar)
      correctAnswerIndex: 2,

      // PENJELASAN
      explanations: [
        // A
        "Salah. For Loop itu kaku, berdasarkan hitungan angka.",
        // B
        "Kurang Tepat. While Loop mengecek syarat DI AWAL. Jika sejak awal syarat tidak terpenuhi, Koki tidak jadi mencicipi sama sekali.",
        // C (Benar)
        "Tepat! Do-While adalah 'Post-Test Loop'. Aksi (Cicipi) dilakukan DULU (Do), baru kemudian syaratnya diperiksa (While).",
        // D
        "Salah. Ini struktur percabangan, bukan pengulangan.",
      ],
    );
  }
}