import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart'; // Pastikan pakai sizer agar responsif

class PointsPage extends StatelessWidget {
  const PointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Background abu sangat muda
      appBar: AppBar(
        title: const Text("Pencapaian Belajar", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: userId == null 
          ? const Center(child: Text("Silakan Login untuk melihat poin."))
          : StreamBuilder<List<Map<String, dynamic>>>(
              // 1. STREAM PROFILE (Untuk Total Score)
              stream: Supabase.instance.client
                  .from('profiles')
                  .stream(primaryKey: ['id'])
                  .eq('id', userId),
              builder: (context, snapshotProfile) {
                int totalScore = 0;
                if (snapshotProfile.hasData && snapshotProfile.data!.isNotEmpty) {
                  totalScore = snapshotProfile.data!.first['total_score'] ?? 0;
                }

                return Column(
                  children: [
                    // --- HEADER: TOTAL SKOR ---
                    _buildTotalScoreCard(totalScore),

                    // --- TITLE LIST ---
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 1.h),
                      child: Row(
                        children: [
                          const Icon(Icons.list_alt, color: Colors.indigo),
                          const SizedBox(width: 10),
                          Text("Riwayat Modul & Latihan", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    // --- LIST MODUL 1-20 ---
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        // 2. STREAM USER PROGRESS (Untuk Cek Mana yg Selesai)
                        stream: Supabase.instance.client
                            .from('user_progress')
                            .stream(primaryKey: ['id'])
                            .eq('user_id', userId),
                        builder: (context, snapshotProgress) {
                          if (snapshotProgress.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          // Ambil ID materi yang sudah selesai
                          final completedData = snapshotProgress.data ?? [];
                          final completedIds = completedData.map((e) => e['materi_id'] as int).toSet();

                          // Generate List 1 sampai 20
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                            itemCount: 20, // Ada 20 Materi
                            itemBuilder: (context, index) {
                              final materiId = index + 1;
                              final isCompleted = completedIds.contains(materiId);
                              
                              // Cari data spesifik untuk mendapatkan skor (jika ada di DB history)
                              // Defaultnya Materi = 10 poin.
                              // Latihan = Poin dinamis (Disimpan di total_score profil, tapi kita visualisasikan di sini)
                              
                              return _buildAchievementItem(materiId, isCompleted);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  // WIDGET: KARTU TOTAL SKOR (Paling Atas)
  Widget _buildTotalScoreCard(int score) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: const BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
      ),
      child: Column(
        children: [
          const Text("Total Poin Anda", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, color: Colors.amber, size: 40),
              const SizedBox(width: 10),
              Text(
                "$score",
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20)
            ),
            child: const Text("Terus tingkatkan!", style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  // WIDGET: ITEM LIST (Modul 1, 2, dst)
  Widget _buildAchievementItem(int id, bool isCompleted) {
    return Card(
      elevation: isCompleted ? 2 : 0,
      color: isCompleted ? Colors.white : Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isCompleted ? const BorderSide(color: Colors.green, width: 1) : BorderSide.none
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // ICON STATUS
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green[50] : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.lock_outline,
                color: isCompleted ? Colors.green : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            
            // TEXT DESKRIPSI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Materi & Latihan $id",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: isCompleted ? Colors.black87 : Colors.grey
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted ? "Selesai dikerjakan" : "Belum selesai",
                    style: TextStyle(fontSize: 12, color: isCompleted ? Colors.green : Colors.grey),
                  ),
                ],
              ),
            ),

            // BADGE POIN
            if (isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.withOpacity(0.5))
                ),
                child: const Column(
                  children: [
                    Text("DONE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                    // Kita asumsikan minimal dapat 10 poin dari membaca
                    // Poin latihan sudah masuk ke total global
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}