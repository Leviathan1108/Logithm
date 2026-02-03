import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager {
  // Singleton pattern agar mudah dipanggil dimanapun
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  // --- CONFIG ---
  final String _tempFileName = 'user_current_pp.jpg'; // Nama file statis agar selalu ter-overwrite
  final String _guestPrefKey = 'guest_avatar_name';

  // --- LOGIC USER (Logged In) ---
  
  // 1. Simpan/Overwrite Foto User ke Lokal
  Future<File> saveUserImage(File newImage) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$_tempFileName';
    
    // Hapus file lama jika ada (opsional, karena copy akan menimpa, tapi lebih aman dicek)
    final File existingFile = File(path);
    if (await existingFile.exists()) {
      await existingFile.delete();
    }

    // Simpan file baru (Ini yang membuat offline tetap bisa lihat update terakhir)
    return await newImage.copy(path);
  }

  // 2. Ambil Foto User dari Lokal
  Future<File?> getUserImageLocal() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$_tempFileName');
    
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  // --- LOGIC GUEST ---

  // 1. Simpan Pilihan Avatar Guest (Cuma simpan nama filenya, misal 'hero.png')
  Future<void> setGuestAvatar(String assetName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_guestPrefKey, assetName);
  }

  // 2. Ambil Pilihan Avatar Guest
  Future<String> getGuestAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    // Default ke default.png jika belum pilih
    return prefs.getString(_guestPrefKey) ?? 'default.png';
  }
}