import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_manager.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // --- VARIABLES ---
  final _usernameController = TextEditingController();
  final AuthManager _auth = AuthManager();
  
  bool _isLoading = false;
  File? _imageFile; 
  
  // Data State untuk Tampilan
  String _currentAvatarData = 'foto1.png'; 
  int _selectedColorIndex = 3; 

  // List Warna Pilihan
  final List<Color> _availableColors = [
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.amber.shade400,
    Colors.blue.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _usernameController.text = _auth.username;
    _loadProfileData(); 
  }

  // --- LOGIC: LOAD DATA ---
  Future<void> _loadProfileData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      // Cek koneksi internet sederhana untuk load awal
      if (await _checkConnection()) {
        final data = await Supabase.instance.client
            .from('profiles')
            .select('username, avatar_data, avatar_color_index')
            .eq('id', userId)
            .single();
        
        if (mounted) {
          setState(() {
            _usernameController.text = data['username'] ?? _auth.username;
            if (data['avatar_data'] != null) {
              _currentAvatarData = data['avatar_data'];
            }
            if (data['avatar_color_index'] != null) {
              _selectedColorIndex = data['avatar_color_index'];
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Gagal load profil: $e");
    }
  }

  // --- HELPER: CEK KONEKSI ---
  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // --- HELPER: CEK KETERSEDIAAN USERNAME ---
  Future<bool> _isUsernameTaken(String username, String currentUserId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('id')
          .eq('username', username)
          .neq('id', currentUserId) // Jangan anggap duplikat jika itu username kita sendiri
          .maybeSingle(); // Mengembalikan null jika tidak ada, data jika ada
      
      return response != null; // True jika ada (Taken), False jika null (Available)
    } catch (e) {
      debugPrint("Error check username: $e");
      return false; // Asumsikan aman jika error (atau handle sesuai kebutuhan)
    }
  }

  // --- HELPER: GENERATE USERNAME UNIK (REKUSIF 1, 2, 3...) ---
  // Fungsi ini menerapkan logika: Budi -> Budi1 -> Budi2 -> dst.
  // Gunakan fungsi ini di ProgressManager saat Sync, atau untuk fitur "Auto Fix".
  Future<String> _getAvailableUsername(String baseName) async {
    String candidate = baseName;
    int counter = 1;
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

    while (await _isUsernameTaken(candidate, userId)) {
      candidate = "$baseName$counter";
      counter++;
    }
    return candidate;
  }

  // --- LOGIC: PILIH GAMBAR DARI GALERI ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800, 
      maxHeight: 800,
      imageQuality: 80, 
    );
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // --- LOGIC: PILIH PRESET ---
  void _selectPreset(int index) {
    setState(() {
      _imageFile = null; 
      _currentAvatarData = 'foto$index.png';
    });
  }

  // --- LOGIC: SIMPAN PERUBAHAN UTAMA ---
  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Username tidak boleh kosong!")));
      setState(() => _isLoading = false);
      return;
    }

    // 1. CEK KONEKSI INTERNET
    bool isOnline = await _checkConnection();

    // 2. LOGIKA JIKA ONLINE
    if (isOnline) {
      // Cek apakah username sudah dipakai
      bool taken = await _isUsernameTaken(newUsername, user.id);
      
      if (taken) {
        if (mounted) {
          // Tampilkan Popup / Notifikasi sesuai permintaan
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Username Tidak Tersedia"),
              content: Text("Username '$newUsername' sudah digunakan orang lain.\nSilakan ganti username lain."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
                // Opsional: Tombol saran otomatis
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    // Contoh penggunaan helper auto-increment
                    setState(() => _isLoading = true);
                    String suggested = await _getAvailableUsername(newUsername);
                    setState(() {
                       _usernameController.text = suggested;
                       _isLoading = false;
                    });
                  },
                  child: const Text("Carikan Alternatif"),
                )
              ],
            ),
          );
          setState(() => _isLoading = false);
        }
        return; // BERHENTI DI SINI
      }

      // Jika aman, Lanjut simpan ke Server
      try {
        await _executeSaveToSupabase(user, newUsername);
      } catch (e) {
        _handleError(e);
      }

    } else {
      // 3. LOGIKA JIKA OFFLINE
      // Simpan ke AuthManager lokal saja
      _auth.username = newUsername;
      // Catatan: Anda perlu menyimpan status "needs_sync" dan avatar lokal di ProgressManager
      // agar nanti saat online bisa disinkronkan.
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Offline: Username '$newUsername' disimpan di HP. Nanti akan disinkronkan otomatis."),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context, true);
      }
      setState(() => _isLoading = false);
    }
  }

  // Fungsi Terpisah untuk Upload & Update Database
  Future<void> _executeSaveToSupabase(User user, String username) async {
    final supabase = Supabase.instance.client;
    String finalAvatarData = _currentAvatarData;

    // A. Upload File Jika Ada
    if (_imageFile != null) {
      final fileExt = _imageFile!.path.split('.').last;
      final fileName = '${user.id}/avatar.$fileExt'; 
      
      await supabase.storage.from('avatars').upload(
        fileName,
        _imageFile!,
        fileOptions: const FileOptions(upsert: true), 
      );

      finalAvatarData = supabase.storage.from('avatars').getPublicUrl(fileName);
      finalAvatarData = '$finalAvatarData?t=${DateTime.now().millisecondsSinceEpoch}';
    }

    // B. Update Database Profiles
    await supabase.from('profiles').update({
      'username': username,
      'avatar_data': finalAvatarData,       
      'avatar_color_index': _selectedColorIndex,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);

    // C. Update Lokal
    _auth.username = username; 
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil berhasil diperbarui!")));
      Navigator.pop(context, true); 
    }
    setState(() => _isLoading = false);
  }

  void _handleError(dynamic e) {
    if (mounted) {
      String message = "Gagal menyimpan: $e";
      if (e.toString().contains("Bucket not found")) {
        message = "Error: Bucket 'avatars' belum dibuat!";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor = _availableColors.length > _selectedColorIndex 
        ? _availableColors[_selectedColorIndex] 
        : Colors.blue;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // AVATAR
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: activeColor, 
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: SizedBox(
                          width: 110, height: 110,
                          child: _buildAvatarImage(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // INPUT USERNAME
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 30),

            // PILIH WARNA
            const Align(alignment: Alignment.centerLeft, child: Text("Warna Latar", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_availableColors.length, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: _availableColors[index],
                      shape: BoxShape.circle,
                      border: _selectedColorIndex == index ? Border.all(color: Colors.black, width: 3) : null,
                    ),
                    child: _selectedColorIndex == index ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // PILIH PRESET
            const Align(alignment: Alignment.centerLeft, child: Text("Pilih Karakter", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  int photoNum = index + 1;
                  String assetName = 'foto$photoNum.png';
                  bool isSelected = (_imageFile == null && _currentAvatarData.contains(assetName));

                  return GestureDetector(
                    onTap: () => _selectPreset(photoNum),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _availableColors[_selectedColorIndex].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset('assets/ppicture/original/$assetName', fit: BoxFit.contain),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent
                ),
                child: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, fit: BoxFit.cover);
    }
    if (_currentAvatarData.startsWith('http')) {
      return Image.network(
        _currentAvatarData, 
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.white),
      );
    }
    return Image.asset(
      'assets/ppicture/original/$_currentAvatarData', 
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
    );
  }
}