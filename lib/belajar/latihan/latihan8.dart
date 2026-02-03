import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan8 extends StatelessWidget {
  const Latihan8({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 8, // ID Materi: Logika AND
      title: "Latihan: Syarat Ketat (AND)",
      
      // Mengambil dari Code Example: Masuk Konser
      question: 
        "Penjaga konser sangat ketat. Aturannya:\n"
        "JIKA (Punya Tiket) DAN (Punya KTP) MAKA Boleh Masuk.\n\n"
        "Andi datang membawa Tiket, TAPI dia lupa membawa KTP.\n"
        "Bagaimana hasil logika komputer penjaga?",
      
      options: [
        "TRUE. Andi Boleh Masuk karena tiketnya mahal.",
        "FALSE. Andi Ditolak Masuk.", // Jawaban Benar
        "TRUE. Andi Boleh Masuk tapi harus janji bawa KTP besok.",
        "FALSE. Andi Ditolak karena wajahnya mencurigakan."
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // Opsi A
        "Salah. Dalam logika AND, tidak peduli seberapa mahal tiketnya. Jika satu syarat hilang (KTP), hasilnya GAGAL.",
        
        // Opsi B (Benar)
        "Tepat Sekali! Rumus AND: (Benar + Salah = SALAH). Karena Andi tidak bawa KTP (False), maka syarat gabungan tidak terpenuhi.",
        
        // Opsi C
        "Salah. Komputer tidak mengenal negosiasi atau janji. Syarat harus dipenuhi SAAT ITU JUGA (Real-time).",
        
        // Opsi D
        "Salah Alasan. Andi ditolak bukan karena wajahnya, tapi murni karena variabel 'Punya KTP' bernilai FALSE.",
      ],
    );
  }
}