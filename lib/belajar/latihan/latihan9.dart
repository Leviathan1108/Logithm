import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan9 extends StatelessWidget {
  const Latihan9({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 9, // ID Materi: Logika OR
      title: "Latihan: Syarat Alternatif (OR)",
      
      // Mengambil dari Real World Example: Masuk Mall / Vaksin
      question: 
        "Satpam Mall memiliki aturan masuk yang fleksibel:\n"
        "JIKA (Sudah Vaksin) ATAU (Bawa Surat Dokter) MAKA Boleh Masuk.\n\n"
        "Siti datang ke Mall. Dia BELUM Vaksin karena sakit, TAPI dia membawa Surat Dokter.\n"
        "Apakah Siti boleh masuk?",
      
      options: [
        "DITOLAK. Karena Siti belum vaksin.",
        "DITERIMA (Boleh Masuk).", // Jawaban Benar
        "DITOLAK. Karena syaratnya harus dua-duanya lengkap.",
        "DITERIMA. Tapi harus divaksin dulu di tempat."
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // Opsi A
        "Salah. Kamu menggunakan logika AND (Dan). Padahal aturannya pakai ATAU (OR). Tidak vaksin tidak masalah, asalkan punya alternatif lain.",
        
        // Opsi B (Benar)
        "Tepat Sekali! Rumus OR: (Salah + Benar = BENAR). Meskipun syarat pertama Gagal (Belum Vaksin), tapi syarat kedua Sukses (Ada Surat). Jadi Pintu Terbuka.",
        
        // Opsi C
        "Salah Besar. Itu adalah logika 'AND'. Logika 'OR' itu ibarat 'Pintu Depan atau Pintu Belakang', lewat mana saja boleh.",
        
        // Opsi D
        "Salah. Algoritma mengecek kondisi SAAT ITU JUGA. Saat Siti datang membawa surat, syarat sudah terpenuhi (TRUE).",
      ],
    );
  }
}