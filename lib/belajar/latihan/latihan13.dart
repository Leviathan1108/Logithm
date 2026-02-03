import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan13 extends StatelessWidget {
  const Latihan13({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 13, // ID Materi: For Loop
      title: "Latihan: Target Pasti",
      
      // Mengambil dari Analogi: Gym / Angkat Beban
      question: 
        "Di Gym, pelatih memberi instruksi tegas: 'Angkat beban ini 5 kali!'.\n\n"
        "Karena jumlahnya SUDAH PASTI (5 kali), struktur pengulangan apa yang PALING COCOK digunakan?",
      
      options: [
        "A. WHILE Loop (Selama masih kuat, angkat terus).",
        "B. IF Statement (Jika beban ringan, angkat).",
        "C. DO-WHILE Loop (Coba angkat dulu, baru tanya).",
        "D. FOR Loop (Untuk hitungan 1 sampai 5, Angkat)." // Jawaban Benar ada di akhir
      ],
      
      // KUNCI JAWABAN (Index ke-3 benar)
      correctAnswerIndex: 3,

      // PENJELASAN
      explanations: [
        // A
        "Kurang Tepat. While Loop biasanya untuk kondisi yang belum pasti jumlahnya (Uncounted). Di sini angkanya jelas: 5 kali.",
        // B
        "Salah. IF itu Percabangan untuk memilih, bukan Pengulangan untuk melakukan aksi berkali-kali.",
        // C
        "Kurang Efisien. Do-While biasanya dipakai jika kita tidak tahu apakah syarat akan terpenuhi di awal.",
        // D (Benar)
        "Tepat Sekali! FOR Loop disebut 'Counted Loop'. Sangat cocok ketika kita sudah tahu persis berapa kali harus mengulang (Start: 1, End: 5).",
      ],
    );
  }
}