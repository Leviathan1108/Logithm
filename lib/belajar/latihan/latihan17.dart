import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan17 extends StatelessWidget {
  const Latihan17({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 17, // ID Materi: Variabel Accumulator
      title: "Latihan: Menghitung Total",
      
      // Mengambil dari Analogi: Mesin Kasir
      question: 
        "Kasir sedang men-scan belanjaan: Roti (2000), lalu Susu (5000).\n\n"
        "Kita butuh variabel 'Total' untuk menampung harga semuanya.\n"
        "Bagaimana rumus 'Accumulator' yang benar saat barang baru di-scan?",
      
      options: [
        "A. Total = HargaBarang (Total nilainya diganti harga barang baru).",
        "B. Total = Total - HargaBarang (Malah dikurangi).",
        "C. Total = Total * HargaBarang (Dikali).",
        "D. Total = Total + HargaBarang (Ditambahkan ke nilai sebelumnya)." // Jawaban Benar
      ],
      
      // KUNCI JAWABAN (Index ke-3 benar)
      correctAnswerIndex: 3,

      // PENJELASAN
      explanations: [
        // A
        "Salah. Jika kamu pakai rumus ini, harga 'Roti' akan hilang tertimpa harga 'Susu'. Total akhirnya cuma 5000, bukan 7000.",
        // B
        "Salah Logika. Masa belanja malah mengurangi total bayar?",
        // C
        "Salah. Penjumlahan total itu pakai tambah (+), bukan kali (*).",
        // D (Benar)
        "Tepat! Accumulator bekerja seperti bola salju. Nilai total yang lama (2000) ditambah harga baru (5000) = 7000.",
      ],
    );
  }
}