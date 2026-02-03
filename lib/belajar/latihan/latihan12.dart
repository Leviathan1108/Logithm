import 'package:flutter/material.dart';
import '../latihan_template.dart';

class Latihan12 extends StatelessWidget {
  const Latihan12({super.key});

  @override
  Widget build(BuildContext context) {
    return const LatihanTemplate(
      idMateri: 12, // ID Materi: Pengenalan Loop
      title: "Latihan: Konsep Pengulangan",
      
      // Mengambil dari Analogi: Lari Lapangan
      question: 
        "Pelatih menyuruh atlet: 'Lari keliling lapangan 100 kali!'\n\n"
        "Bagaimana cara memberitahu komputer (Si Atlet) agar kodenya EFISIEN dan TIDAK CAPEK menulisnya?",
      
      options: [
        "A. Menulis perintah 'Lari' sebanyak 100 baris ke bawah.",
        "B. Gunakan struktur LOOP: 'ULANGI (Lari) SEBANYAK 100 kali'.", // Jawaban Benar
        "C. Gunakan IF: 'JIKA (Lari) MAKA (Berhenti)'.",
        "D. Tulis 'Lari' sekali saja, nanti komputer paham sendiri."
      ],
      
      // KUNCI JAWABAN (Index ke-1 benar)
      correctAnswerIndex: 1,

      // PENJELASAN
      explanations: [
        // Opsi A
        "Kurang Cerdas. Bayangkan jika disuruh lari 1.000.000 kali? Tanganmu akan keriting menulis kodenya. Ini cara manual (Sequential) yang buruk untuk kasus ini.",
        
        // Opsi B (Benar)
        "Tepat Sekali! Inilah inti dari Looping. Kita cukup menulis instruksinya SEKALI, lalu memberitahu komputer berapa kali harus mengulangnya.",
        
        // Opsi C
        "Salah. IF itu untuk 'Memilih' (Percabangan), bukan untuk 'Mengulang'.",
        
        // Opsi D
        "Salah. Komputer itu 'bodoh' tapi patuh. Jika kamu tulis sekali, dia hanya akan lari sekali. Dia tidak bisa menebak keinginanmu.",
      ],
    );
  }
}