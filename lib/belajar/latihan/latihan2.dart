import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan2 extends StatelessWidget {
  const Latihan2({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 2, // Judul: Input, Proses, Output
      title: "Latihan: Model IPO",
      
      // Mengambil dari Code Example: Membuat Jus
      question: 
        "Kita ingin membuat program 'Mesin Jus Buah'.\n\n"
        "Manakah urutan Input, Proses, dan Output yang BENAR sesuai pola pikir komputer?",
      
      options: [
        "Input: Blender -> Proses: Listrik -> Output: Buah.",
        "Input: Buah Jeruk -> Proses: Blender (Giling) -> Output: Jus Jeruk.", // Jawaban Benar
        "Input: Jus Jeruk -> Proses: Minum -> Output: Buah Jeruk.",
        "Input: Gelas -> Proses: Tuang -> Output: Blender."
      ],
      
      correctAnswerIndex: 1, // B

      explanations: [
        "Salah. Blender adalah 'Alat Proses', bukan bahan baku (Input).",
        "Tepat Sekali! Bahan (Input) diolah oleh Mesin (Proses) menjadi Hasil (Output). Ini adalah prinsip dasar IPO.",
        "Salah. Ini terbalik. Kita tidak bisa mengubah Jus kembali menjadi Buah utuh.",
        "Kurang tepat. Gelas hanyalah wadah akhir, bukan bahan utama yang diproses."
      ],
    );
  }
}