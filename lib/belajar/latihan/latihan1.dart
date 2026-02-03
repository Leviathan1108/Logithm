import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan1 extends StatelessWidget {
  const Latihan1({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 1, // Judul: Pengenalan Algoritma
      title: "Latihan: Konsep Dasar",
      
      // Mengambil dari Analogi: Koki & Resep
      question: 
        "Komputer itu seperti Koki yang sangat patuh tapi tidak bisa berpikir sendiri.\n\n"
        "Agar Koki bisa memasak Nasi Goreng yang enak, apa yang paling dia butuhkan dari kamu?",
      
      options: [
        "A. Bahan makanan yang mahal.",
        "B. Panci yang berwarna-warni.",
        "C. Resep (Langkah-langkah) yang urut dan jelas.", // Jawaban Benar
        "D. Perintah untuk memasak sesuka hati."
      ],
      
      correctAnswerIndex: 2, // C

      explanations: [
        "Salah. Bahan mahal tidak berguna jika Koki tidak tahu cara mengolahnya (Langkah tidak ada).",
        "Salah. Alat (Hardware) penting, tapi tanpa instruksi (Software/Algoritma), alat itu diam saja.",
        "Tepat! Algoritma adalah 'Resep'. Langkahnya harus logis dan sistematis agar Koki (Komputer) tidak bingung.",
        "Salah. Komputer tidak punya 'perasaan' atau inisiatif. Dia butuh instruksi spesifik."
      ],
    );
  }
}