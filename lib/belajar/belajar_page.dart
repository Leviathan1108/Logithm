import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart'; // Pastikan sizer terinstall/diimport jika pakai sizer
import '../services/progress_manager.dart';
import '../services/auth_manager.dart'; // Untuk ambil ID user sendiri
import 'data/materi_data.dart'; // Untuk ambil Judul Materi
import '../widgets/custom_avatar.dart'; // Untuk menampilkan avatar user lain
import 'materi_list_page.dart';

class BelajarPage extends StatefulWidget {
  const BelajarPage({super.key});

  @override
  State<BelajarPage> createState() => _BelajarPageState();
}

class _BelajarPageState extends State<BelajarPage> {
  final _myUserId = Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Adventure Mode", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Set<int>>(
        valueListenable: ProgressManager.completedMateri,
        builder: (context, completed, _) {
          
          // --- LOGIKA PROGRESS ---
          int totalLevels = 20;
          int completedCount = completed.length;
          int nextLevel = completedCount + 1;
          if (nextLevel > totalLevels) nextLevel = totalLevels;

          double progress = completedCount / totalLevels;

          // --- LOGIKA HISTORY (3 TERAKHIR) ---
          // Kita urutkan dari ID terbesar (terbaru) ke terkecil, lalu ambil 3
          List<int> historyList = completed.toList();
          historyList.sort((a, b) => b.compareTo(a)); // Descending
          List<int> recentHistory = historyList.take(3).toList();

          return Column(
            children: [
              // ============================================
              // 1. HEADER PROGRESS (HUD)
              // ============================================
              _buildHeader(progress, completedCount, totalLevels),

              const SizedBox(height: 20),

              // ============================================
              // 2. JEJAK PETUALANGAN (HISTORY USER LAIN)
              // ============================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(
                      "Jejak Terakhir Anda", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo[900])
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // LIST HISTORY
              Expanded(
                child: recentHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: recentHistory.length,
                        itemBuilder: (context, index) {
                          int materiId = recentHistory[index];
                          return _buildHistoryCard(materiId);
                        },
                      ),
              ),

              // ============================================
              // 3. TOMBOL START GAME (MAIN BUTTON)
              // ============================================
              _buildStartButton(context, completedCount, nextLevel),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGET HEADER ---
  Widget _buildHeader(double progress, int completedCount, int totalLevels) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80, height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.yellowAccent),
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Status Pemain:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 5),
                Text(
                  completedCount == 0 
                      ? "Pemula" 
                      : (completedCount == totalLevels 
                          ? "MASTER ALGORITMA!" 
                          : "Level $completedCount Selesai"),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
                ),
                Text(
                  completedCount == 0 ? "Siap memulai perjalanan?" : "Pertahankan semangatmu!",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTU HISTORY & USER LAIN ---
  Widget _buildHistoryCard(int materiId) {
    // Ambil data materi statis
    final materi = MateriData.getMateri(materiId);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris 1: Judul Materi & Badge Selesai
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level $materiId: ${materi.title}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Text("Selesai", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          
          const Divider(height: 20),
          
          // Baris 2: User lain yang menyelesaikan (Future Builder)
          const Text("Juga diselesaikan oleh:", style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 8),
          
          SizedBox(
            height: 35,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              // Fetch data user lain dari Supabase
              future: _fetchOtherCompleters(materiId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Align(alignment: Alignment.centerLeft, child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)));
                }
                
                final users = snapshot.data ?? [];
                
                if (users.isEmpty) {
                  return const Text("Jadilah yang pertama di antara temanmu!", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 11));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final profile = user['profiles'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Tooltip(
                        message: profile['username'] ?? 'User',
                        child: CustomAvatar(
                          avatarData: profile['avatar_data'] ?? 'foto1.png',
                          colorIndex: profile['avatar_color_index'] ?? 3,
                          radius: 16,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // --- LOGIC FETCH USER LAIN ---
  Future<List<Map<String, dynamic>>> _fetchOtherCompleters(int materiId) async {
    try {
      final response = await Supabase.instance.client
          .from('user_progress')
          .select('user_id, profiles(username, avatar_data, avatar_color_index)')
          .eq('materi_id', materiId)
          .neq('user_id', _myUserId ?? '') // Jangan tampilkan diri sendiri
          .limit(5); // Ambil max 5 orang
      
      // Filter jika profiles null (misal user terhapus)
      return List<Map<String, dynamic>>.from(response).where((e) => e['profiles'] != null).toList();
    } catch (e) {
      return [];
    }
  }

  // --- WIDGET KOSONG ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.indigo.withOpacity(0.1)),
          const SizedBox(height: 10),
          const Text(
            "Belum ada jejak petualangan.\nMulai mainkan level pertama!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- TOMBOL MULAI ---
  Widget _buildStartButton(BuildContext context, int completedCount, int nextLevel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))]
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MateriListPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completedCount == 0 ? "MULAI GAME" : "LANJUT MAIN",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Level $nextLevel",
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}