import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_avatar.dart';
import '../friends/friend_profile_page.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final _myUserId = Supabase.instance.client.auth.currentUser?.id;
  
  // Set untuk menyimpan ID teman agar tombol berubah jadi "Added" jika sudah berteman
  Set<String> _myFriendIds = {}; 

  @override
  void initState() {
    super.initState();
    _fetchFriendList(); // Cek siapa saja yang sudah jadi teman
  }

  // Ambil daftar ID teman saya
  Future<void> _fetchFriendList() async {
    if (_myUserId == null) return;
    final response = await Supabase.instance.client
        .from('friendships')
        .select('friend_id')
        .eq('user_id', _myUserId!);
    
    if (mounted) {
      setState(() {
        _myFriendIds = (response as List).map((e) => e['friend_id'] as String).toSet();
      });
    }
  }

  // Logic Add Friend ke Database
  Future<void> _addFriend(String friendId, String friendName) async {
    if (_myUserId == null) return;
    
    try {
      await Supabase.instance.client.from('friendships').insert({
        'user_id': _myUserId,
        'friend_id': friendId,
      });

      setState(() {
        _myFriendIds.add(friendId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil mengikuti $friendName"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      // Error biasanya karena sudah ada (Unique constraint)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sudah menjadi teman."), backgroundColor: Colors.orange),
      );
    }
  }

  // Fetch Data Leaderboard
  Future<List<Map<String, dynamic>>> _getLeaderboardData() async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('id, username, total_score, avatar_data, avatar_color_index, status')
          .order('total_score', ascending: false)
          .limit(50);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Warna background lembut
      appBar: AppBar(
        title: const Text("Papan Peringkat", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              _fetchFriendList();
            },
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data."));
          }

          final leaderboardData = snapshot.data!;
          // Ambil Top 3
          final top3 = leaderboardData.take(3).toList();
          // Sisanya
          final rest = leaderboardData.skip(3).toList();

          return Column(
            children: [
              // --- SECTION PODIUM (TOP 3) ---
              Container(
                padding: const EdgeInsets.only(bottom: 30),
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (top3.length > 1) _buildPodium(top3[1], 2), // Juara 2 Kiri
                    if (top3.isNotEmpty) _buildPodium(top3[0], 1), // Juara 1 Tengah
                    if (top3.length > 2) _buildPodium(top3[2], 3), // Juara 3 Kanan
                  ],
                ),
              ),

              // --- LIST SISANYA (RANK 4++) ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: rest.length,
                  itemBuilder: (context, index) {
                    final user = rest[index];
                    return _buildListItem(user, index + 4);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget Podium
  Widget _buildPodium(Map<String, dynamic> user, int rank) {
    final bool isMe = user['id'] == _myUserId;
    final double size = rank == 1 ? 100 : 80;
    final double heightOffset = rank == 1 ? 0 : 20;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FriendProfilePage(profileData: user))),
      child: Padding(
        padding: EdgeInsets.only(bottom: heightOffset),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]
                  ),
                  child: CustomAvatar(
                    avatarData: user['avatar_data'] ?? 'foto1.png',
                    colorIndex: user['avatar_color_index'] ?? 3,
                    radius: size / 2,
                    showStatus: true,
                    status: user['status'] ?? 'auto',
                  ),
                ),
                if (rank == 1)
                  const Positioned(
                    top: -25, right: 0, left: 0,
                    child: Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                  ),
                Positioned(
                  bottom: -10, right: 0, left: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: rank == 1 ? Colors.amber : (rank == 2 ? Colors.grey : Colors.brown),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("#$rank", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(
              isMe ? "Anda" : (user['username'] ?? "User"),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${user['total_score']} pts",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Widget List Item
  Widget _buildListItem(Map<String, dynamic> user, int rank) {
    final bool isMe = user['id'] == _myUserId;
    final bool isFriend = _myFriendIds.contains(user['id']);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      color: isMe ? Colors.blue[50] : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 30, child: Text("#$rank", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey))),
            CustomAvatar(
              avatarData: user['avatar_data'] ?? 'foto1.png',
              colorIndex: user['avatar_color_index'] ?? 3,
              radius: 24,
              showStatus: true,
              status: user['status'] ?? 'auto',
            ),
          ],
        ),
        title: Text(
          isMe ? "${user['username']} (Anda)" : (user['username'] ?? "User"),
          style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? Colors.blue : Colors.black),
        ),
        subtitle: Text("${user['total_score']} Poin", style: const TextStyle(color: Colors.orange)),
        trailing: isMe 
          ? const Icon(Icons.star, color: Colors.blue)
          : IconButton(
              icon: Icon(
                isFriend ? Icons.check_circle : Icons.person_add, 
                color: isFriend ? Colors.green : Colors.grey,
              ),
              onPressed: isFriend 
                ? null // Sudah teman tidak bisa diklik
                : () => _addFriend(user['id'], user['username']),
            ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => FriendProfilePage(profileData: user)));
        },
      ),
    );
  }
}