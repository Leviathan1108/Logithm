import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan6 extends StatelessWidget {
  const Latihan6({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 6, // ID Materi: Operator Pembanding
      title: "Latihan: Bandingkan Nilai",
      
      // Mengambil dari Analogi: Wahana Dufan (Tinggi Badan)
      question: 
        "Petugas Roller Coaster memiliki aturan keselamatan:\n"
        "Syarat: Tinggi > 150 cm (Harus LEBIH DARI 150 cm).\n\n"
        "Datanglah Budi dengan tinggi 140 cm. Bagaimana komputer mengecek syarat tersebut?",
      
      options: [
        "Cek: 140 > 150. Hasil: TRUE (Benar). Budi Boleh Masuk.",
        "Cek: 140 > 150. Hasil: FALSE (Salah). Budi Ditolak.",
        "Cek: 140 < 150. Hasil: FALSE (Salah). Budi Boleh Masuk.",
        "Cek: 140 == 150. Hasil: TRUE (Benar). Budi Boleh Masuk."
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // Opsi A (Salah Matematika)
        "Salah Hitung. Angka 140 itu lebih KECIL dari 150. Jadi pernyataan '140 lebih besar dari 150' adalah kebohongan (FALSE).",
        
        // Opsi B (Benar)
        "Tepat Sekali! Komputer membandingkan 140 dengan 150. Karena 140 tidak lebih besar, maka hasilnya FALSE (Salah). Karena syarat GAGAL, Budi tidak boleh masuk.",
        
        // Opsi C (Salah Logika)
        "Salah. 140 < 150 itu hasilnya TRUE (Benar), bukan FALSE. Tapi aturannya kan minta 'lebih dari' (>), bukan 'kurang dari' (<).",
        
        // Opsi D (Salah Operator)
        "Salah. Tanda '==' artinya 'Sama Persis'. Tinggi Budi (140) jelas tidak sama dengan 150.",
      ],
    );
  }
}