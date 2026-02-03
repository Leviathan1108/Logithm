import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan sudah install package ini
import 'package:path_provider/path_provider.dart'; // Untuk simpan file sementara

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // --- STATE VARIABLES ---
  
  // 1. Data Avatar (Default awal: foto1)
  String _selectedAsset = 'foto1.png'; 
  File? _uploadedFile; // Jika user upload, ini akan terisi
  
  // 2. Data Warna (Default awal: Biru)
  // List warna yang tersedia: Merah, Hijau, Kuning, Biru
  final List<Color> _availableColors = [
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.amber.shade400, // Kuning yang enak dilihat
    Colors.blue.shade400,
  ];
  int _selectedColorIndex = 3; // Default index 3 (Biru)

  // --- LOGIC ---

  // Fungsi saat user klik tombol Upload
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _uploadedFile = File(image.path);
        // Reset pilihan asset jika upload dipilih (opsional)
      });
    }
  }

  // Fungsi saat user memilih salah satu preset avatar
  void _selectPreset(int index) {
    setState(() {
      _uploadedFile = null; // Hapus file upload jika user balik pilih preset
      _selectedAsset = 'foto$index.png';
    });
  }

  // Fungsi Simpan (Nanti disambungkan ke Database)
  void _saveProfile() {
    // Data yang siap dikirim ke DB:
    // 1. Avatar: Jika _uploadedFile != null -> Upload dulu, ambil URL.
    //            Jika _uploadedFile == null -> Kirim string _selectedAsset ('fotoX.png').
    // 2. Warna: Kirim _selectedColorIndex (misal: 0, 1, 2, 3) atau Hex Code warnanya.
    
    print("Simpan Avatar: ${_uploadedFile != null ? 'File Upload' : _selectedAsset}");
    print("Simpan Warna Index: $_selectedColorIndex");
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil disimpan (Simulasi)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna background yang aktif
    Color activeColor = _availableColors[_selectedColorIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // --- BAGIAN 1: PREVIEW BESAR ---
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    // Ini kuncinya: Warna background berubah sesuai pilihan
                    backgroundColor: activeColor, 
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // Padding agar gambar tidak terlalu mepet
                      child: _buildMainAvatarImage(),
                    ),
                  ),
                  // Ikon edit kecil (hiasan)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.black54, size: 20),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            const Text("Pilih Warna Latar", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // --- BAGIAN 2: PILIH WARNA (COLOR PICKER) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_availableColors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _availableColors[index],
                      shape: BoxShape.circle,
                      border: _selectedColorIndex == index 
                          ? Border.all(color: Colors.black, width: 3) // Highlight pilihan
                          : null,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
                      ]
                    ),
                    child: _selectedColorIndex == index 
                        ? const Icon(Icons.check, color: Colors.white, size: 20) 
                        : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Pilih Avatar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),

            // --- BAGIAN 3: GRID PILIHAN (UPLOAD + PRESET) ---
            Container(
              height: 400, // Batasi tinggi agar scrollable jika perlu
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Scroll ikut parent
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 kolom
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                // Total item = 1 tombol upload + 9 foto preset
                itemCount: 10, 
                itemBuilder: (context, index) {
                  // ITEM 0: TOMBOL UPLOAD
                  if (index == 0) {
                    return GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, color: Colors.grey),
                            Text("Upload", style: TextStyle(fontSize: 10, color: Colors.grey))
                          ],
                        ),
                      ),
                    );
                  }

                  // ITEM 1-9: PRESET AVATAR
                  // index grid 1 map ke foto1, index 2 map ke foto2...
                  int photoIndex = index; 
                  String assetName = 'foto$photoIndex.png';
                  bool isSelected = (_selectedAsset == assetName && _uploadedFile == null);

                  return GestureDetector(
                    onTap: () => _selectPreset(photoIndex),
                    child: Container(
                      decoration: BoxDecoration(
                        // Gunakan warna pilihan user sebagai background preview kecil juga
                        color: _availableColors[_selectedColorIndex].withOpacity(0.5), 
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected 
                            ? Border.all(color: Colors.black, width: 3) 
                            : null,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        'assets/ppicture/original/$assetName',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _saveProfile,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // Widget Helper untuk menentukan gambar mana yang tampil di Preview Besar
  Widget _buildMainAvatarImage() {
    if (_uploadedFile != null) {
      // Jika user upload foto sendiri
      // Biasanya foto upload tidak transparan, jadi kita ClipOval biar rapi
      return ClipOval(
        child: Image.file(
          _uploadedFile!,
          width: 140, // Match radius * 2
          height: 140,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Jika pakai preset (Transparan)
      return Image.asset(
        'assets/ppicture/original/$_selectedAsset',
        fit: BoxFit.contain,
      );
    }
  }
}