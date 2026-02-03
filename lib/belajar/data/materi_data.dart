import '../models/materi_model.dart';

class MateriData {
  /// Mengambil materi berdasarkan ID.
  /// Jika ID tidak ditemukan, kembalikan materi pertama sebagai default.
  static MateriContent getMateri(int id) {
    return _allMateri.firstWhere(
      (m) => m.id == id,
      orElse: () => _allMateri[0], 
    );
  }

  // --- DATA LENGKAP MATERI 1 - 20 ---
  static final List<MateriContent> _allMateri = [
    
    // 1. PENGENALAN ALGORITMA (Match: "alur logika")
    MateriContent(
      id: 1,
      title: "Pengenalan Algoritma",
      introduction: {
        "title": "Apa itu Algoritma?",
        "description": "Algoritma hanyalah kata keren untuk 'langkah-langkah penyelesaian masalah'. Sebelum komputer bekerja, kita harus memberitahu langkahnya satu per satu.",
        "conceptOverview": "Bayangkan memberi petunjuk jalan kepada turis. Jika petunjuknya lompat-lompat, turis akan tersesat. Algoritma harus urut dan jelas.",
      },
      definition: {
        "title": "Definisi Logis",
        "technicalDefinition": "Urutan langkah logis yang disusun secara sistematis untuk menyelesaikan suatu masalah.",
        "syntax": "Mulai -> Langkah 1 -> Langkah 2 -> Selesai",
        "codeExample": "// Algoritma Espresso:\n1. Pasang portafilter\n2. Letakkan cangkir\n3. Tekan tombol seduh\n4. Kopi siap",
      },
      analogy: {
        "title": "Analogi: Mesin Kopi",
        "analogyTitle": "Barista & Mesin Espresso",
        "analogyDescription": "Komputer ibarat mesin kopi yang canggih namun pasif. Ia membutuhkan instruksi urut dari Barista (kamu) mulai dari memasang tuas hingga menekan tombol agar bisa menghasilkan kopi.",
        "realWorldExample": "Proses menyeduh Espresso.",
        "imageUrl": "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400",
        "semanticLabel": "Mesin kopi sedang menyeduh",
      },
      visualization: {
        "title": "Alur Logika", // MATCHED
        "visualizationType": "algoritma", 
        "description": "Garis lurus dari atas ke bawah.",
      },
    ),

    // 2. INPUT PROSES OUTPUT (Match: "kotak hitam")
    MateriContent(
      id: 2,
      title: "Input, Proses, Output",
      introduction: {
        "title": "Pola Pikir Komputer",
        "description": "Semua program komputer di dunia bekerja dengan pola ini: Terima bahan (Input), Olah bahan (Proses), Tampilkan hasil (Output).",
        "conceptOverview": "Kita tidak bisa mendapatkan hasil tanpa bahan baku yang jelas.",
      },
      definition: {
        "title": "Model IPO",
        "technicalDefinition": "Siklus dasar pengolahan data dimana input diubah menjadi output melalui proses.",
        "syntax": "Input [Bahan] -> Proses [Olah] -> Output [Hasil]",
        "codeExample": "// Membuat Jus:\nInput: Buah Jeruk\nProses: Blender\nOutput: Jus Jeruk",
      },
      analogy: {
        "title": "Analogi: Blender",
        "analogyTitle": "Blender & Buah",
        "analogyDescription": "Jeruk kupas dimasukkan ke dalam wadah (Input), pisau blender berputar menghancurkan buah (Proses), lalu dituang menjadi air jus (Output).",
        "realWorldExample": "Kalkulator (Angka -> Hitung -> Hasil).",
        "imageUrl": "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400",
        "semanticLabel": "Blender sedang memproses buah",
      },
      visualization: {
        "title": "Kotak Hitam", // MATCHED
        "visualizationType": "algoritma", 
        "description": "Kotak yang menerima panah masuk dan mengeluarkan panah keluar.",
      },
    ),

    // 3. SEKUENSIAL (Match: "garis lurus")
    MateriContent(
      id: 3,
      title: "Sekuensial (Urutan)",
      introduction: {
        "title": "Urutan Itu Penting",
        "description": "Komputer membaca instruksi dari baris pertama ke baris terakhir. Urutan tidak boleh terbalik.",
        "conceptOverview": "Hasil akan berbeda atau berantakan jika langkahnya ditukar sembarangan.",
      },
      definition: {
        "title": "Eksekusi Berurutan",
        "technicalDefinition": "Setiap instruksi dijalankan satu per satu sesuai urutan penulisannya.",
        "syntax": "Langkah A \nLalu Langkah B \nLalu Langkah C",
        "codeExample": "// Memakai Sepatu:\n1. Pasang kaus kaki\n2. Pasang sepatu\n(Jika dibalik, hasilnya aneh)",
      },
      analogy: {
        "title": "Analogi: Alas Kaki",
        "analogyTitle": "Kaus Kaki & Sepatu",
        "analogyDescription": "Kamu wajib memakai kaus kaki terlebih dahulu sebelum memasukkan kaki ke dalam sepatu. Jika urutannya dibalik (sepatu dulu), maka kaus kaki tidak bisa dipakai.",
        "realWorldExample": "Mandi (Basahi badan -> Sabun -> Bilas).",
        "imageUrl": "https://images.unsplash.com/photo-1595341888016-a392ef81b7de?w=400",
        "semanticLabel": "Orang mengikat tali sepatu",
      },
      visualization: {
        "title": "Garis Lurus", // MATCHED
        "visualizationType": "algoritma", 
        "description": "Panah lurus ke bawah tanpa cabang.",
      },
    ),

    // 4. PERCABANGAN (IF) (Match: "cabang satu")
    MateriContent(
      id: 4,
      title: "Logika Percabangan (If)",
      introduction: {
        "title": "Mengambil Keputusan",
        "description": "Kadang hidup tidak lurus saja. Kita harus memilih jalan berdasarkan kondisi tertentu.",
        "conceptOverview": "Jika suatu kondisi terpenuhi, lakukan ini. Jika tidak, abaikan.",
      },
      definition: {
        "title": "Logika Deteksi",
        "technicalDefinition": "Blok kode yang hanya akan dieksekusi jika kondisi atau 'sensor' bernilai BENAR (True).",
        "syntax": "JIKA [Sensor Aktif] MAKA [Buka Pintu]",
        "codeExample": "// Sistem Pintu Mall:\nJIKA (Ada Orang Lewat) MAKA:\n  - Mesin Pintu Terbuka\n(Jika sepi, pintu diam)",
      },
      analogy: {
        "title": "Analogi: Pintu Mall",
        "analogyTitle": "Sensor Gerak Otomatis",
        "analogyDescription": "Sensor di atas pintu selalu bertanya: 'Ada orang tidak?'. JIKA jawabannya YA, ia memerintah motor pintu untuk bergeser terbuka. JIKA TIDAK, ia diam saja.",
        "realWorldExample": "Palang parkir (Jika tiket diambil -> Palang naik).",
        "imageUrl": "https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=400",
        "semanticLabel": "Pintu kaca otomatis mall",
      },
      visualization: {
        "title": "Cabang Satu", // CHANGED from "Cek Kondisi"
        "visualizationType": "algoritma", 
        "description": "Diamond (Kondisi) memeriksa sensor. Jika Ya, panah mengarah ke kotak aksi 'Buka Pintu'.",
      },
    ),

    // 5. PERCABANGAN DUA ARAH (IF-ELSE) (Match: "cabang dua")
    MateriContent(
      id: 5,
      title: "Percabangan Dua Arah",
      introduction: {
        "title": "Pilihan A atau B",
        "description": "Bagaimana jika kondisinya salah? Kita butuh rencana cadangan.",
        "conceptOverview": "Jika benar lakukan A, jika salah lakukan B. Harus memilih salah satu.",
      },
      definition: {
        "title": "Jalur Alternatif",
        "technicalDefinition": "Logika yang memaksa program memilih satu dari dua jalur. Tidak bisa lewat keduanya, tidak bisa diam di tempat.",
        "syntax": "JIKA [Syarat Penuh] MAKA [Jalur A]\nSELAIN ITU [Jalur B]",
        "codeExample": "// Pemeriksaan Tiket Tol:\nJIKA (Saldo Cukup) MAKA:\n  - Masuk Jalur Hijau (Buka Palang)\nSELAIN ITU:\n  - Masuk Jalur Merah (Alarm Bunyi)",
      },
      analogy: {
        "title": "Analogi: Gerbang Tol",
        "analogyTitle": "Jalur Hijau vs Merah",
        "analogyDescription": "Mobil mendekat ke gerbang. JIKA kartu valid, lampu berubah HIJAU dan mobil jalan terus. JIKA kartu tidak valid, lampu berubah MERAH dan mobil harus minggir.",
        "realWorldExample": "Lampu Lalu Lintas (Hijau = Jalan, Merah = Berhenti).",
        "imageUrl": "https://images.unsplash.com/photo-1565514020176-db8b7a4c475d?w=400",
        "semanticLabel": "Gerbang tol dengan lampu indikator",
      },
      visualization: {
        "title": "Cabang Dua", // CHANGED from "Percabangan Jalan"
        "visualizationType": "algoritma", 
        "description": "Diamond memisahkan jalur: Kanan (True) ke kotak Hijau, Kiri (False) ke kotak Merah.",
      },
    ),

    // 6. OPERATOR PEMBANDING (Match: "timbangan")
    MateriContent(
      id: 6,
      title: "Operator Pembanding",
      introduction: {
        "title": "Alat Ukur Keputusan",
        "description": "Untuk membuat keputusan, kita perlu membandingkan sesuatu.",
        "conceptOverview": "Apakah A lebih besar dari B? Apakah A sama dengan B?",
      },
      definition: {
        "title": "Relational Operators",
        "technicalDefinition": "Simbol untuk membandingkan dua nilai yang menghasilkan Benar atau Salah.",
        "syntax": "> (Lebih dari), < (Kurang dari), == (Sama dengan)",
        "codeExample": "Tinggi > 150 (Apakah tinggi lebih dari 150?)\nTinggi < 100 (Apakah tinggi kurang dari 100?)", 
      },
      analogy: {
        "title": "Analogi: Tinggi Badan",
        "analogyTitle": "Wahana Dufan",
        "analogyDescription": "Petugas mengukur tinggi badan. JIKA Tinggi > 150cm MAKA boleh masuk.",
        "realWorldExample": "Timbangan berat badan petinju.",
        "imageUrl": "https://images.unsplash.com/photo-1533561362021-995ae2000c0f?w=400",
        "semanticLabel": "Pengukur tinggi",
      },
      visualization: {
        "title": "Timbangan", // MATCHED
        "visualizationType": "algoritma", 
        "description": "Menimbang dua sisi.",
      },
    ),

    // 7. PERCABANGAN MAJEMUK (Match: "tangga keputusan")
    MateriContent(
      id: 7,
      title: "Percabangan Majemuk",
      introduction: {
        "title": "Banyak Pilihan",
        "description": "Satu ukuran tidak muat untuk semua. Kadang kita butuh banyak opsi.",
        "conceptOverview": "Cek ukuran S, jika tidak muat cek M, jika tidak muat cek L, dst.",
      },
      definition: {
        "title": "Kondisional Bertingkat",
        "technicalDefinition": "Pengecekan beruntun untuk memilih satu dari banyak kemungkinan ukuran.",
        "syntax": "JIKA [Ukuran Kecil] ..\nATAU JIKA [Ukuran Sedang] ..\nSELAIN ITU [Ukuran Besar] ..",
        "codeExample": "JIKA (Badan Kecil) -> Pakai S\nATAU JIKA (Badan Sedang) -> Pakai M\nSELAIN ITU -> Pakai L",
      },
      analogy: {
        "title": "Analogi: Ukuran Baju",
        "analogyTitle": "Memilih Size",
        "analogyDescription": "Jika kecil ambil S, Jika sedang ambil M, Jika besar ambil L, Selain itu ambil XL.",
        "realWorldExample": "Memilih jenis kerah (V-Neck, O-Neck, atau Polo).",
        "imageUrl": "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=400",
        "semanticLabel": "Baju berbagai ukuran",
      },
      visualization: {
        "title": "Tangga Keputusan", // MATCHED
        "visualizationType": "algoritma", 
        "description": "Menyeleksi ukuran baju secara bertahap.",
      },
    ),

    // 8. LOGIKA AND (Match: "gerbang seri")
    MateriContent(
      id: 8,
      title: "Logika AND (Dan)",
      introduction: {
        "title": "Keamanan Ganda",
        "description": "Brankas yang sangat aman biasanya tidak cukup dibuka dengan satu cara saja.",
        "conceptOverview": "Kode harus benar DAN Kunci fisik harus masuk. Jika salah satu kurang, brankas tetap terkunci.",
      },
      definition: {
        "title": "Operator AND",
        "technicalDefinition": "Menghasilkan Terbuka (True) hanya jika semua pengaman (Operand) bernilai Benar.",
        "syntax": "Pengaman A [DAN] Pengaman B",
        "codeExample": "JIKA (Kode Angka Benar) DAN (Kunci Fisik Masuk) MAKA:\n  - Pintu Brankas Terbuka",
      },
      analogy: {
        "title": "Analogi: Brankas Bank",
        "analogyTitle": "Dua Pemegang Kunci",
        "analogyDescription": "Brankas bank besar hanya terbuka jika Manajer memutar kunci A DAN Satpam memutar kunci B secara bersamaan.",
        "realWorldExample": "Safe Deposit Box (Kunci Nasabah DAN Kunci Bank).",
        "imageUrl": "https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400",
        "semanticLabel": "Brankas besi",
      },
      visualization: {
        "title": "Gerbang Seri", // CHANGED from "Mekanisme Pengunci"
        "visualizationType": "algoritma", 
        "description": "Dua slot kunci yang harus terisi bersamaan agar tuas bisa bergerak.",
      },
    ),

    // 9. LOGIKA OR (Match: "gerbang paralel")
    MateriContent(
      id: 9,
      title: "Logika OR (Atau)",
      introduction: {
        "title": "Jalur Alternatif",
        "description": "Jika satu jalan tertutup, masih ada jalan lain. Kita punya pilihan.",
        "conceptOverview": "Tidak perlu semua terbuka. Cukup salah satu pintu terbuka, maka kita bisa masuk.",
      },
      definition: {
        "title": "Operator OR",
        "technicalDefinition": "Menghasilkan Benar (True) jika salah satu atau semua kondisi (Pintu) bernilai Benar (Terbuka).",
        "syntax": "Pintu A [ATAU] Pintu B",
        "codeExample": "JIKA (Pintu Depan Terbuka) ATAU (Pintu Belakang Terbuka) MAKA:\n  - Berhasil Masuk Rumah",
      },
      analogy: {
        "title": "Analogi: Dua Pintu",
        "analogyTitle": "Akses Masuk Bebas",
        "analogyDescription": "Untuk masuk ke dalam ruangan, kamu tidak wajib membuka kedua pintu. Lewat Pintu A boleh, ATAU lewat Pintu B juga boleh.",
        "realWorldExample": "Masuk Mall (Bisa lewat Pintu Utara ATAU Pintu Selatan).",
        "imageUrl": "https://images.unsplash.com/photo-1517601278517-456741613ca1?w=400",
        "semanticLabel": "Dua pintu akses",
      },
      visualization: {
        "title": "Gerbang Paralel", // CHANGED from "Pintu Paralel"
        "visualizationType": "algoritma", 
        "description": "Dua pintu berjajar menuju ruangan yang sama. Pilih salah satu.",
      },
    ),

    // 10. PERCABANGAN BERSARANG (Match: "pohon keputusan")
    MateriContent(
      id: 10,
      title: "Percabangan Bersarang",
      introduction: {
        "title": "Pemeriksaan Berlapis",
        "description": "Satu pemeriksaan saja tidak cukup. Setelah lolos satu pintu, ada pintu pemeriksaan berikutnya.",
        "conceptOverview": "Cek syarat pertama dulu. Jika lolos, baru cek syarat kedua di dalamnya.",
      },
      definition: {
        "title": "Nested If",
        "technicalDefinition": "Struktur If yang berada di dalam blok If lain.",
        "syntax": "JIKA [Tiket Valid] MAKA:\n  -> JIKA [X-Ray Aman] MAKA...",
        "codeExample": "JIKA (Tiket Valid) MAKA:\n  -> JIKA (X-Ray Aman) MAKA: Boleh Terbang\n  -> SELAIN ITU: Sita Barang\nSELAIN ITU: Ditolak Masuk",
      },
      analogy: {
        "title": "Analogi: Keamanan Bandara",
        "analogyTitle": "Tiket & Scan X-Ray",
        "analogyDescription": "Pertama cek tiket di gerbang. JIKA Tiket Valid, baru lanjut ke mesin X-Ray. JIKA X-Ray Aman (tidak ada bom/pisau), baru boleh masuk ruang tunggu.",
        "realWorldExample": "Imigrasi (Cek Paspor -> Jika Valid, Cek Visa).",
        "imageUrl": "https://images.unsplash.com/photo-1565514020176-db793b2a2d48?w=400",
        "semanticLabel": "Pemeriksaan keamanan bandara",
      },
      visualization: {
        "title": "Pohon Keputusan", // CHANGED from "Pos Bertingkat"
        "visualizationType": "algoritma", 
        "description": "Harus lolos Pos 1 untuk bisa menemui Pos 2.",
      },
    ),

   // 11. SWITCH CASE (Match: "titik distribusi")
    MateriContent(
      id: 11,
      title: "Logika Switch / Case",
      introduction: {
        "title": "Memilih dari Menu",
        "description": "Daripada mengecek satu-satu, lebih cepat langsung menekan tombol yang spesifik.",
        "conceptOverview": "Langsung melompat ke pilihan yang cocok tanpa proses tanya jawab yang panjang.",
      },
      definition: {
        "title": "Seleksi Kasus",
        "technicalDefinition": "Struktur kontrol untuk memilih satu blok kode berdasarkan nilai yang pasti (matching).",
        "syntax": "SWITCH [Variabel]:\nCASE 'Nilai A': Aksi 1\nCASE 'Nilai B': Aksi 2",
        "codeExample": "SWITCH (Tombol):\nCASE 'A1': Jatuhkan Cola\nCASE 'B2': Jatuhkan Air\nDEFAULT: Saldo Kembali", 
      },
      analogy: {
        "title": "Analogi: Vending Machine",
        "analogyTitle": "Tombol Minuman",
        "analogyDescription": "Anda tekan tombol A1, keluar Cola. Tekan B2, keluar Air. Mesin langsung tahu tujuannya tanpa bingung.",
        "realWorldExample": "Tombol Lift (Tekan 1 ke Lantai 1, Tekan G ke Ground).",
        "imageUrl": "https://images.unsplash.com/photo-1620553765239-c9676755455c?w=400",
        "semanticLabel": "Mesin penjual otomatis",
      },
      visualization: {
        "title": "Titik Distribusi", // CHANGED from "Papan Tombol"
        "visualizationType": "algoritma", 
        "description": "Satu input terhubung ke banyak output spesifik.",
      },
    ),

   // 12. PENGENALAN LOOP (Match: "lingkaran")
    MateriContent(
      id: 12,
      title: "Pengenalan Loop",
      introduction: {
        "title": "Jangan Capek Mengulang",
        "description": "Daripada menyuruh satu per satu 'Lari langkah 1, Lari langkah 2...', lebih baik satu perintah paket.",
        "conceptOverview": "Kita cukup suruh komputer: 'Teruslah berlari berputar sampai target tercapai'.",
      },
      definition: {
        "title": "Looping / Iterasi",
        "technicalDefinition": "Mengeksekusi blok kode berulang kali selama kondisi tertentu terpenuhi.",
        "syntax": "ULANGI [Aksi] SELAMA [Belum Selesai]",
        "codeExample": "ULANGI TERUS:\n  - Lari satu putaran\n  - SAMPAI (Sudah 5 keliling)", 
      },
      analogy: {
        "title": "Analogi: Lari Lapangan",
        "analogyTitle": "Target Putaran",
        "analogyDescription": "Pelatih bilang: 'Lari 5 putaran'. Anda mulai lari. Putaran 1, lanjut. Putaran 2, lanjut... Pas putaran 5, baru berhenti.",
        "realWorldExample": "Pembalap F1 mengelilingi sirkuit 50 lap.",
        "imageUrl": "https://images.unsplash.com/photo-1552674605-46940428d02e?w=400",
        "semanticLabel": "Pelari di lintasan",
      },
      visualization: {
        "title": "Lingkaran", // CHANGED from "Lintasan Sirkuit"
        "visualizationType": "algoritma", 
        "description": "Garis panah yang kembali ke titik start.",
      },
    ),

    // 13. FOR LOOP (Match: "counter")
    MateriContent(
      id: 13,
      title: "Pengulangan Terhitung",
      introduction: {
        "title": "Target Finish",
        "description": "Dalam lomba lari resmi, kita sudah tahu PASTI berapa kali harus mengelilingi lapangan.",
        "conceptOverview": "Start dari putaran 1, terus berlari, dan berhenti tepat setelah putaran ke-3.",
      },
      definition: {
        "title": "Counted Loop",
        "technicalDefinition": "Pengulangan yang jumlah iterasinya (putaran) sudah ditentukan sejak awal.",
        "syntax": "UNTUK [Putaran 1] SAMPAI [Putaran 3], LAKUKAN...",
        "codeExample": "UNTUK Lap = 1 SAMPAI 3:\n  - Lari Keliling Lapangan\n(Hasil: Atlet berlari tepat 3 kali)", 
      },
      analogy: {
        "title": "Analogi: Lomba Lari",
        "analogyTitle": "Lari 3 Putaran",
        "analogyDescription": "Wasit menetapkan 3 putaran. Anda lari putaran 1, lanjut putaran 2, lanjut putaran 3, lalu FINISH.",
        "realWorldExample": "Pembalap MotoGP menyelesaikan total 20 Lap.",
        "imageUrl": "https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?w=400",
        "semanticLabel": "Pelari di lintasan",
      },
      visualization: {
        "title": "Counter", // CHANGED from "Penghitung Lap"
        "visualizationType": "algoritma", 
        "description": "Angka counter bertambah setiap melewati garis start.",
      },
    ),

    // 14. WHILE LOOP (Match: "siklus cek awal")
    MateriContent(
      id: 14,
      title: "Pengulangan Bersyarat",
      introduction: {
        "title": "Cek Dulu, Baru Isi",
        "description": "Kita tidak tahu pasti butuh berapa liter, tapi kita tahu kapan harus berhenti.",
        "conceptOverview": "Selama tangki masih muat (belum penuh), bensin terus mengalir.",
      },
      definition: {
        "title": "Uncounted Loop",
        "technicalDefinition": "Pengulangan yang terus berjalan selama kondisi bernilai True. Cek kondisi di awal sebelum beraksi.",
        "syntax": "SELAMA [Tangki Belum Penuh] LAKUKAN [Isi Bensin]",
        "codeExample": "SELAMA (Tangki < Penuh):\n  - Tekan Tuas Bensin\n(Berhenti otomatis saat sensor mendeteksi Penuh)", 
      },
      analogy: {
        "title": "Analogi: Isi Bensin",
        "analogyTitle": "Isi Full Tank",
        "analogyDescription": "Anda menekan tuas nozzle. Bensin mengalir. Sistem terus mengecek: 'Sudah penuh belum?'. Jika belum, lanjut isi. Jika sudah, 'Klik!', berhenti.",
        "realWorldExample": "Mengisi air ke dalam botol minum sampai bibir botol.",
        "imageUrl": "https://images.unsplash.com/photo-1616401776146-2d64a781b49f?w=400",
        "semanticLabel": "Pom bensin",
      },
      visualization: {
        "title": "Siklus Cek Awal", // CHANGED from "Siklus Pengisian"
        "visualizationType": "algoritma", 
        "description": "Cek Kapasitas -> Tuang Bensin -> Kembali Cek Kapasitas.",
      },
    ),

    // 15. DO-WHILE LOOP (Match: "siklus cek akhir")
    MateriContent(
      id: 15,
      title: "Do-While Loop",
      introduction: {
        "title": "Cicipi Dulu, Baru Nilai",
        "description": "Berbeda dengan While, di sini kita wajib melakukan aksinya dulu minimal satu kali sebelum mengecek.",
        "conceptOverview": "Tambahkan bumbu dulu, baru cek rasanya. Tidak mungkin mengecek rasa sebelum dicicipi.",
      },
      definition: {
        "title": "Post-Test Loop",
        "technicalDefinition": "Blok kode dijalankan terlebih dahulu satu kali, baru kemudian kondisi diperiksa di akhir.",
        "syntax": "LAKUKAN [Tambah Bumbu]... KEMUDIAN CEK [Apakah Hambar?]",
        "codeExample": "LAKUKAN:\n  - Tabur Garam\n  - Cicipi Kuah\nSELAMA (Rasa == Kurang Asin)", 
      },
      analogy: {
        "title": "Analogi: Memasak",
        "analogyTitle": "Koreksi Rasa",
        "analogyDescription": "Anda pasti mencicipi masakan dulu (DO). JIKA rasanya kurang asin (WHILE), baru Anda tambahkan penyedap lagi dan ulangi.",
        "realWorldExample": "Mengocok telur (Kocok dulu, cek apakah sudah mengembang).",
        "imageUrl": "https://images.unsplash.com/photo-1546272989-40c92939c6c2?w=400",
        "semanticLabel": "Koki mencicipi sup",
      },
      visualization: {
        "title": "Siklus Cek Akhir", // CHANGED from "Siklus Cicipi"
        "visualizationType": "algoritma", 
        "description": "Tuang Bumbu -> Cek Rasa -> Jika Kurang, Ulangi Tuang.",
      },
    ),

    // 16. COUNTER (Match: "tangga naik")
    MateriContent(
      id: 16,
      title: "Variabel Penghitung",
      introduction: {
        "title": "Papan Catatan",
        "description": "Saat melakukan pengulangan, kita butuh 'tempat' untuk mencatat sudah berapa kali kita melakukannya.",
        "conceptOverview": "Seperti menulis satu garis di papan tulis setiap kali satu putaran selesai.",
      },
      definition: {
        "title": "Increment (Penambahan)",
        "technicalDefinition": "Variabel yang nilainya terus dinaikkan (biasanya +1) setiap kali loop berjalan.",
        "syntax": "Angka_Di_Papan = Angka_Di_Papan + 1",
        "codeExample": "Awal: Papan Kosong (0)\nLoop 1: Tulis '1'\nLoop 2: Hapus '1', Tulis '2'\nLoop 3: Hapus '2', Tulis '3'",
      },
      analogy: {
        "title": "Analogi: Papan Tulis",
        "analogyTitle": "Pemilihan Ketua Kelas",
        "analogyDescription": "Setiap kali nama kandidat disebut, panitia menggambar satu garis (turus) di papan tulis. Garis itu adalah counter yang terus bertambah.",
        "realWorldExample": "Menghitung skor pertandingan voli di papan skor manual.",
        "imageUrl": "https://images.unsplash.com/photo-1531190260877-c8d11eb5bfaf?w=400",
        "semanticLabel": "Tulisan kapur di papan tulis",
      },
      visualization: {
        "title": "Tangga Naik", // CHANGED from "Angka Berubah"
        "visualizationType": "algoritma", 
        "description": "Angka lama dihapus, diganti angka baru yang lebih besar.",
      },
    ),

   // 17. ACCUMULATOR (Match: "bola salju")
    MateriContent(
      id: 17,
      title: "Variabel Penampung",
      introduction: {
        "title": "Total Belanjaan",
        "description": "Saat belanja banyak barang, kita butuh satu angka yang terus bertambah setiap kali kasir melakukan scan.",
        "conceptOverview": "Kita butuh 'wadah' untuk menampung penjumlahan harga barang A, barang B, barang C, dan seterusnya.",
      },
      definition: {
        "title": "Akumulator",
        "technicalDefinition": "Variabel yang digunakan untuk menyimpan hasil penjumlahan bertahap dari setiap perulangan (loop).",
        "syntax": "Total_Bayar = Total_Bayar + Harga_Barang_Baru",
        "codeExample": "Awal: Total = 0\nScan Susu (5rb) -> Total jadi 5rb\nScan Roti (10rb) -> Total jadi 15rb\nScan Keju (5rb) -> Total jadi 20rb",
      },
      analogy: {
        "title": "Analogi: Mesin Kasir",
        "analogyTitle": "Struk Belanja",
        "analogyDescription": "Kasir scan barang pertama, harganya muncul. Scan barang kedua, mesin menjumlahkan harga baru ke total sebelumnya. Begitu terus sampai selesai.",
        "realWorldExample": "Celengan (Uang lama + Uang baru dimasukkan = Total Tabungan).",
        "imageUrl": "https://images.unsplash.com/photo-1556742049-0cfed4f7a07d?w=400",
        "semanticLabel": "Layar mesin kasir",
      },
      visualization: {
        "title": "Bola Salju", // CHANGED from "Kalkulator Kasir"
        "visualizationType": "algoritma", 
        "description": "Angka di layar yang terus bertambah besar setiap tombol ditekan.",
      },
    ),

    // 18. INFINITE LOOP (Match: "roda hamster")
    MateriContent(
      id: 18,
      title: "Infinite Loop",
      introduction: {
        "title": "Lari Tanpa Garis Finish",
        "description": "Apa yang terjadi jika kita menyuruh komputer 'Lari terus!' tanpa memberitahu kapan harus berhenti?",
        "conceptOverview": "Komputer akan terus bekerja selamanya, berputar-putar tanpa henti sampai 'pingsan' (Crash/Hang).",
      },
      definition: {
        "title": "Loop Tak Terbatas",
        "technicalDefinition": "Kesalahan logika (Bug) di mana syarat untuk berhenti tidak pernah terpenuhi (Selalu Benar).",
        "syntax": "SELAMA (Roda == Berputar) LAKUKAN [Lari]",
        "codeExample": "SELAMA (Hamster Hidup):\n  - Lari di Roda\n  (Lupa menulis perintah: Istirahat)", 
      },
      analogy: {
        "title": "Analogi: Hamster",
        "analogyTitle": "Roda Putar",
        "analogyDescription": "Hamster berlari di dalam roda mainan. Kakinya berlari kencang, rodanya berputar cepat, tapi dia tetap di tempat yang sama selamanya.",
        "realWorldExample": "Aplikasi 'Not Responding' atau Loading screen yang muter terus.",
        "imageUrl": "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?w=400",
        "semanticLabel": "Hamster main roda",
      },
      visualization: {
        "title": "Roda Hamster", // CHANGED from "Lingkaran Setan"
        "visualizationType": "algoritma", 
        "description": "Panah alur yang berputar balik tanpa jalan keluar.",
      },
    ),

   // 19. BREAK (Match: "pintu keluar")
    MateriContent(
      id: 19,
      title: "Break (Berhenti Paksa)",
      introduction: {
        "title": "Sudah Ketemu, Stop!",
        "description": "Saat mencari sesuatu, jika barangnya sudah ditemukan, kita pasti langsung berhenti mencari.",
        "conceptOverview": "Tidak masuk akal untuk tetap memeriksa sisa laci jika barang yang dicari sudah ada di tangan.",
      },
      definition: {
        "title": "Break Statement",
        "technicalDefinition": "Perintah untuk menghentikan loop seketika (keluar paksa) karena tujuan sudah tercapai atau kondisi khusus terpenuhi.",
        "syntax": "JIKA [Barang Ketemu] MAKA [BREAK/KELUAR]",
        "codeExample": "UNTUK (Laci 1 sampai 5):\n  - Buka Laci\n  - JIKA (Ada Kunci) -> AMBIL & BREAK\n(Laci sisa tidak perlu dibuka)", 
      },
      analogy: {
        "title": "Analogi: Mencari Barang",
        "analogyTitle": "Bongkar Laci",
        "analogyDescription": "Anda mencari kaos kaki. Buka Laci 1: Kosong. Buka Laci 2: Ketemu! Maka Anda berhenti (BREAK). Anda TIDAK AKAN membuka Laci 3 dan 4.",
        "realWorldExample": "Mencari nama teman di daftar kontak (Stop scroll saat nama ditemukan).",
        "imageUrl": "https://images.unsplash.com/photo-1595514020176-db793b2a2d48?w=400",
        "semanticLabel": "Laci lemari terbuka",
      },
      visualization: {
        "title": "Pintu Keluar", // CHANGED from "Jalan Pintas"
        "visualizationType": "algoritma", 
        "description": "Panah yang melompat keluar dari siklus putaran.",
      },
    ),

    // 20. COMBINE LOGIC (Match: "saringan")
    MateriContent(
      id: 20,
      title: "Loop dengan If",
      introduction: {
        "title": "Pilah-Pilih Otomatis",
        "description": "Kita punya tumpukan sampah yang campur aduk. Kita harus memprosesnya satu per satu untuk dipisahkan.",
        "conceptOverview": "Ambil satu sampah (Loop), cek jenisnya (If), lalu buang ke tempat yang sesuai.",
      },
      definition: {
        "title": "Kombinasi Logika",
        "technicalDefinition": "Menggunakan percabangan (If-Else) di dalam tubuh pengulangan (Loop) untuk memfilter atau mengelompokkan data.",
        "syntax": "UNTUK Setiap [Item], LAKUKAN Pengecekan [Kondisi]",
        "codeExample": "UNTUK Setiap Sampah:\n  - Scan Barang\n  - JIKA (Plastik/Kertas) -> Tong Daur Ulang\n  - SELAIN ITU -> Tong Organik",
      },
      analogy: {
        "title": "Analogi: Sortir Sampah",
        "analogyTitle": "Conveyor Belt",
        "analogyDescription": "Sampah berjalan di ban berjalan (Loop). Scanner mendeteksi: Jika botol, dorong ke Kiri (Daur Ulang). Jika kulit pisang, dorong ke Kanan (Organik).",
        "realWorldExample": "Mesin penukar botol plastik otomatis (Reverse Vending Machine).",
        "imageUrl": "https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400",
        "semanticLabel": "Tong sampah terpisah",
      },
      visualization: {
        "title": "Saringan", // CHANGED from "Penyortir"
        "visualizationType": "algoritma", 
        "description": "Satu jalur masuk, terpecah ke dua wadah berbeda.",
      },
    ),
  ];
}