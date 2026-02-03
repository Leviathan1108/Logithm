import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/notification_manager.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  
  // --- LOGIC TERIMA TEMAN ---
  Future<void> _acceptFriend(String notifId, String senderId, String myId) async {
    try {
      // 1. Update status di tabel friendships jadi 'accepted'
      // Asumsi: Row sudah dibuat saat request dikirim dengan status 'pending'
      await Supabase.instance.client
          .from('friendships')
          .update({'status': 'accepted'})
          .match({'user_id': senderId, 'friend_id': myId});

      // 2. Tandai notifikasi sudah dibaca
      await NotificationManager().markAsRead(int.parse(notifId));

      // 3. (Opsional) Hapus Notifikasi agar tidak bisa diklik lagi atau update UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pertemanan diterima! 🎉"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      debugPrint("Error accept: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menerima. Mungkin data sudah berubah?")),
        );
      }
    }
  }

  // --- LOGIC TOLAK TEMAN ---
  Future<void> _rejectFriend(String notifId, String senderId, String myId) async {
    try {
      // 1. Hapus baris dari friendships
      await Supabase.instance.client
          .from('friendships')
          .delete()
          .match({'user_id': senderId, 'friend_id': myId});

      // 2. Tandai notifikasi dibaca
      await NotificationManager().markAsRead(int.parse(notifId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permintaan ditolak."), backgroundColor: Colors.grey),
        );
      }
    } catch (e) {
      debugPrint("Error reject: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final myId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kotak Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.blueAccent),
            tooltip: "Tandai semua dibaca",
            onPressed: () => NotificationManager().markAllAsRead(),
          )
        ],
      ),
      body: myId == null
          ? const Center(child: Text("Silakan login."))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from('notifications')
                  .stream(primaryKey: ['id'])
                  .eq('user_id', myId)
                  .order('created_at'), // Sort descending otomatis oleh Stream biasanya, atau tambah .order di query kalau perlu
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                // Sort manual biar yang terbaru di atas (Stream kadang ascending)
                final notifs = snapshot.data!;
                notifs.sort((a, b) => b['created_at'].compareTo(a['created_at']));
                
                return ListView.separated(
                  itemCount: notifs.length,
                  separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey[200]),
                  itemBuilder: (context, index) {
                    final item = notifs[index];
                    
                    // Data Parsing
                    final String notifId = item['id'].toString();
                    final bool isRead = item['is_read'] ?? false;
                    final String type = item['type'] ?? 'info';
                    final String? senderId = item['sender_id'];
                    final DateTime time = DateTime.parse(item['created_at']);
                    
                    // Style Condition
                    final Color bg = isRead ? Colors.white : const Color(0xFFF0F7FF);
                    final FontWeight titleWeight = isRead ? FontWeight.normal : FontWeight.bold;
                    final Color textColor = isRead ? Colors.grey[700]! : Colors.black87;

                    return Container(
                      color: bg,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: type == 'friend_request' 
                                  ? (isRead ? Colors.grey[300] : Colors.green[100]) 
                                  : (isRead ? Colors.grey[300] : Colors.blue[100]),
                              child: Icon(
                                type == 'friend_request' ? Icons.person_add : Icons.notifications,
                                color: type == 'friend_request' 
                                    ? (isRead ? Colors.grey : Colors.green) 
                                    : (isRead ? Colors.grey : Colors.blue),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              item['title'] ?? 'Notifikasi',
                              style: TextStyle(fontWeight: titleWeight, color: textColor),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  item['body'] ?? '',
                                  style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  timeago.format(time, locale: 'en_short'),
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (!isRead) NotificationManager().markAsRead(int.parse(notifId));
                            },
                          ),
                          
                          // --- ACTION BUTTONS (Khusus Friend Request) ---
                          // PERBAIKAN: Tombol tetap muncul meskipun sudah dibaca (isRead),
                          // selama tipe-nya friend_request dan ada senderId.
                          if (type == 'friend_request' && senderId != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 72, right: 20, bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _acceptFriend(notifId, senderId, myId),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                        minimumSize: const Size(0, 32),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                                      ),
                                      child: const Text("Terima", style: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _rejectFriend(notifId, senderId, myId),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                        minimumSize: const Size(0, 32),
                                        side: BorderSide(color: Colors.grey[300]!),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                                      ),
                                      child: const Text("Tolak", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
            child: Icon(Icons.notifications_off_outlined, size: 50, color: Colors.blue[200]),
          ),
          const SizedBox(height: 20),
          Text("Semua bersih!", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("Belum ada notifikasi baru.", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
}