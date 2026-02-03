import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_manager.dart';
import '../services/progress_manager.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../settings/settings_page.dart'; 
import '../friends/friends_page.dart'; // Import halaman friends
import '../widgets/custom_avatar.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _avatarData = 'foto1.png';
  int _colorIndex = 3;
  String _displayName = "";
  String _status = 'auto'; // Default status

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final auth = AuthManager();
    _displayName = auth.username;

    if (auth.currentUserType == UserType.loggedIn) {
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          final data = await Supabase.instance.client
              .from('profiles')
              .select('username, avatar_data, avatar_color_index, status') // Ambil status
              .eq('id', userId)
              .maybeSingle();
          
          if (mounted && data != null) {
            setState(() {
              _displayName = data['username'] ?? auth.username;
              _avatarData = data['avatar_data'] ?? 'foto1.png';
              _colorIndex = data['avatar_color_index'] ?? 3;
              _status = data['status'] ?? 'auto';
            });
          }
        }
      } catch (e) {
        debugPrint("Error loading profile: $e");
      }
    }
  }

  // --- LOGIC GANTI STATUS ---
  void _changeStatus() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Atur Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              _buildStatusOption("Otomatis (Default)", 'auto', Colors.green),
              _buildStatusOption("Online", 'online', Colors.green),
              _buildStatusOption("Sibuk / Jangan Ganggu", 'busy', Colors.amber),
              _buildStatusOption("Offline (Invisible)", 'offline', Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String label, String value, Color color) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, radius: 6),
      title: Text(label),
      trailing: _status == value ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () async {
        Navigator.pop(context); // Tutup modal
        setState(() => _status = value); // Update UI Lokal
        
        // Update Database
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          await Supabase.instance.client
              .from('profiles')
              .update({'status': value})
              .eq('id', userId);
        }
      },
    );
  }

  // Navigasi
  void _navigateToSettings() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
    await AuthManager().init(); 
    _fetchProfileData(); 
  }

  void _navigateToFriends() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsPage()));
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthManager();
    bool isGuest = auth.currentUserType == UserType.guest;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: _navigateToSettings)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- HEADER PROFILE DENGAN STATUS ---
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: isGuest ? null : _changeStatus, // Klik foto untuk ganti status
                    child: CustomAvatar(
                      avatarData: _avatarData,
                      colorIndex: _colorIndex,
                      radius: 60,
                      showStatus: true, // Tampilkan indikator
                      status: _status,  // Kirim status saat ini
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!isGuest) 
                    const Text("Ketuk foto untuk ganti status", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  
                  const SizedBox(height: 5),
                  Text(
                    _displayName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isGuest ? "Guest (Progress Lokal)" : (auth.email ?? "User"),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- MENU FRIENDS (BARU) ---
            if (!isGuest)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.shade200)),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.people, color: Colors.blue),
                    ),
                    title: const Text("Teman & Komunitas", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Lihat progress belajar temanmu"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: _navigateToFriends,
                  ),
                ),
              ),

            // STATISTIK / SCORE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("Total Poin", ProgressManager.totalScore),
                      _buildStatItem("Materi Selesai", ProgressManager.completedMateri, isSet: true),
                    ],
                  ),
                ),
              ),
            ),
            
            // ... (Kode Guest & Logout tetap sama) ...
            if (isGuest) ...[
               const SizedBox(height: 20),
               // ... Widget Guest Invitation Anda ...
            ],
            
             // TOMBOL LOGOUT (Hanya muncul jika Logged In)
              if (!isGuest)
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await AuthManager().logout();
                        setState(() {
                           // Reset ke tampilan guest
                           _displayName = AuthManager().username;
                           _avatarData = 'foto1.png';
                           _status = 'auto';
                        });
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text("Keluar", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),

          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, ValueNotifier notifier, {bool isSet = false}) {
    // ... (Sama seperti sebelumnya) ...
     return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, _) {
        String displayValue = isSet ? (value as Set).length.toString() : value.toString();
        return Column(
          children: [
            Text(displayValue, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        );
      },
    );
  }
}