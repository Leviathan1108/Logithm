import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_avatar.dart';
import 'friend_profile_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _myUserId = Supabase.instance.client.auth.currentUser?.id;
  
  // Search
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchMode = false;
  String _searchQuery = "";

  // Cache Status Hubungan
  Map<String, String> _relationshipStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchRelationships();
  }

  // --- LOGIC: LOAD RELATIONSHIPS ---
  Future<void> _fetchRelationships() async {
    if (_myUserId == null) return;
    
    // 1. Ambil orang yang SAYA add
    final myRequests = await Supabase.instance.client
        .from('friendships')
        .select('friend_id, status')
        .eq('user_id', _myUserId!);
        
    // 2. Ambil orang yang ADD SAYA
    final incomingRequests = await Supabase.instance.client
        .from('friendships')
        .select('user_id, status')
        .eq('friend_id', _myUserId!);

    if (mounted) {
      setState(() {
        _relationshipStatus.clear();
        
        // Mapping yang saya kirim
        for (var item in myRequests) {
          String id = item['friend_id'];
          String status = item['status'];
          if (status == 'accepted') {
            _relationshipStatus[id] = 'friend';
          } else {
            _relationshipStatus[id] = 'sent'; 
          }
        }

        // Mapping yang masuk ke saya
        for (var item in incomingRequests) {
          String id = item['user_id'];
          String status = item['status'];
          if (status == 'pending') {
            _relationshipStatus[id] = 'received'; 
          }
        }
      });
    }
  }

  // --- LOGIC: ACTIONS ---

  // 1. Kirim Request (+ KIRIM NOTIFIKASI)
  Future<void> _sendFriendRequest(String targetId) async {
    try {
      // A. Masukkan ke tabel friendships
      await Supabase.instance.client.from('friendships').insert({
        'user_id': _myUserId,
        'friend_id': targetId,
        'status': 'pending',
      });

      // B. [BARU] Kirim Notifikasi ke Target
      // Ambil nama saya dulu
      final myProfile = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('id', _myUserId!)
          .single();
      String myName = myProfile['username'] ?? 'Teman Baru';

      await Supabase.instance.client.from('notifications').insert({
        'user_id': targetId, // Ke siapa?
        'sender_id': _myUserId, // Dari siapa? (Penting buat tombol terima)
        'title': 'Permintaan Pertemanan',
        'body': '$myName ingin menjadi teman Anda!',
        'type': 'friend_request',
        'is_read': false,
      });

      setState(() => _relationshipStatus[targetId] = 'sent');
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permintaan dikirim!")));
    } catch (e) {
      debugPrint("Error adding: $e");
    }
  }

  // 2. Terima Request
  Future<void> _acceptRequest(String requesterId) async {
    try {
      // Update status menjadi accepted
      await Supabase.instance.client
          .from('friendships')
          .update({'status': 'accepted'})
          .eq('user_id', requesterId) 
          .eq('friend_id', _myUserId!);

      // Hubungan 2 arah
      await Supabase.instance.client.from('friendships').upsert({
        'user_id': _myUserId,
        'friend_id': requesterId,
        'status': 'accepted'
      });

      setState(() => _relationshipStatus[requesterId] = 'friend');
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pertemanan diterima!"), backgroundColor: Colors.green));
    } catch (e) {
      debugPrint("Error accepting: $e");
    }
  }

  // 3. Tolak / Hapus Request
  Future<void> _deleteRequest(String otherUserId, {bool isRejecting = true}) async {
    try {
      await Supabase.instance.client
          .from('friendships')
          .delete()
          .or('and(user_id.eq.$_myUserId,friend_id.eq.$otherUserId),and(user_id.eq.$otherUserId,friend_id.eq.$_myUserId)');

      setState(() => _relationshipStatus.remove(otherUserId));
      
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text(isRejecting ? "Permintaan ditolak" : "Dibatalkan"),
         ));
      }
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }

  // --- STREAMS ---

  // Stream Permintaan Masuk (Requests)
  Stream<List<Map<String, dynamic>>> _getIncomingRequestsStream() {
    return Supabase.instance.client
        .from('friendships')
        .stream(primaryKey: ['id'])
        .eq('friend_id', _myUserId!) 
        .asyncMap((data) async {
          final pendingRequests = data.where((item) => item['status'] == 'pending').toList();
          if (pendingRequests.isEmpty) return [];
          
          final userIds = pendingRequests.map((e) => e['user_id']).toList();
          
          final profiles = await Supabase.instance.client
              .from('profiles')
              .select()
              .inFilter('id', userIds);
              
          return List<Map<String, dynamic>>.from(profiles);
        });
  }

  // Stream Teman Saya (Accepted Friends)
  Stream<List<Map<String, dynamic>>> _getMyFriendsStream() {
    return Supabase.instance.client
        .from('friendships')
        .stream(primaryKey: ['id'])
        .eq('user_id', _myUserId!) 
        .asyncMap((data) async {
          final acceptedFriends = data.where((item) => item['status'] == 'accepted').toList();
          if (acceptedFriends.isEmpty) return [];

          final friendIds = acceptedFriends.map((e) => e['friend_id']).toList();
          
          final profiles = await Supabase.instance.client
              .from('profiles')
              .select()
              .inFilter('id', friendIds);
              
          return List<Map<String, dynamic>>.from(profiles);
        });
  }

  // Future Search Global
  Future<List<Map<String, dynamic>>> _searchGlobalUsers(String query) async {
    if (query.isEmpty) return [];
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .ilike('username', '%$query%')
        .neq('id', _myUserId!)
        .limit(20);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: _isSearchMode
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Cari username...",
                border: InputBorder.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            )
          : const Text("Teman & Komunitas", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSearchMode ? Icons.close : Icons.person_add, color: Colors.blue),
            onPressed: () {
              setState(() {
                _isSearchMode = !_isSearchMode;
                _searchQuery = "";
                _searchController.clear();
                if(!_isSearchMode) _fetchRelationships(); 
              });
            },
          )
        ],
      ),
      body: _isSearchMode ? _buildSearchBody() : _buildMainBody(),
    );
  }

  // --- TAMPILAN UTAMA ---
  Widget _buildMainBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await _fetchRelationships();
      },
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getIncomingRequestsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              final requests = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text("PERMINTAAN PERTEMANAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
                          ),
                          _buildRequestCard(requests[index]),
                        ],
                      );
                    }
                    return _buildRequestCard(requests[index]);
                  },
                  childCount: requests.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("DAFTAR TEMAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            ),
          ),

          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getMyFriendsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Icon(Icons.people_outline, size: 60, color: Colors.grey),
                          Text("Belum ada teman", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final friends = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildFriendCard(friends[index]);
                  },
                  childCount: friends.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ITEM ---
  Widget _buildRequestCard(Map<String, dynamic> user) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CustomAvatar(
          avatarData: user['avatar_data'] ?? 'foto1.png',
          colorIndex: user['avatar_color_index'] ?? 3,
          radius: 25,
        ),
        title: Text(user['username'] ?? "User", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Ingin berteman dengan Anda", style: TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => _deleteRequest(user['id'], isRejecting: true),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              onPressed: () => _acceptRequest(user['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text("Konfirmasi"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> user) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        leading: CustomAvatar(
          avatarData: user['avatar_data'] ?? 'foto1.png',
          colorIndex: user['avatar_color_index'] ?? 3,
          radius: 20,
          showStatus: true,
          status: user['status'] ?? 'auto',
        ),
        title: Text(user['username'] ?? "User"),
        subtitle: _buildStatusText(user['status'] ?? 'auto'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => FriendProfilePage(profileData: user)));
        },
      ),
    );
  }

  Widget _buildSearchBody() {
    if (_searchQuery.isEmpty) return const Center(child: Text("Ketik username..."));

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _searchGlobalUsers(_searchQuery),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final results = snapshot.data!;
        
        if (results.isEmpty) return Center(child: Text("User '$_searchQuery' tidak ditemukan"));

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final user = results[index];
            final String userId = user['id'];
            
            String status = _relationshipStatus[userId] ?? 'none'; 
            
            Widget actionButton;
            if (status == 'friend') {
              actionButton = const Chip(label: Text("Teman"), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white));
            } else if (status == 'sent') {
              actionButton = const Chip(label: Text("Terkirim"), backgroundColor: Colors.grey, labelStyle: TextStyle(color: Colors.white));
            } else if (status == 'received') {
              actionButton = ElevatedButton(
                onPressed: () => _acceptRequest(userId),
                child: const Text("Terima"),
              );
            } else {
              actionButton = ElevatedButton.icon(
                icon: const Icon(Icons.person_add, size: 16),
                label: const Text("Add"),
                onPressed: () => _sendFriendRequest(userId),
              );
            }

            return ListTile(
              leading: CustomAvatar(
                avatarData: user['avatar_data'] ?? 'foto1.png',
                colorIndex: user['avatar_color_index'] ?? 3,
                radius: 20,
              ),
              title: Text(user['username'] ?? "User"),
              trailing: actionButton,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FriendProfilePage(profileData: user))),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusText(String status) {
    Color color = (status == 'online' || status == 'auto') ? Colors.green : Colors.grey;
    String text = (status == 'online' || status == 'auto') ? "Online" : "Offline";
    if (status == 'busy') { color = Colors.amber; text = "Sibuk"; }
    return Text(text, style: TextStyle(color: color, fontSize: 11));
  }
}