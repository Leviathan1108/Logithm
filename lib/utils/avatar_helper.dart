import 'dart:math';

class AvatarHelper {
  // Base path folder asset Anda
  static const String _assetPath = 'assets/ppicture/original';

  // 1. FUNGSI GENERATOR RANDOM (Dipakai saat Register)
  // Output: "foto1.png", "foto5.png", dst.
  static String generateRandomAvatarName() {
    // Random angka 1 sampai 9
    int randomNumber = Random().nextInt(9) + 1;
    return 'foto$randomNumber.png'; 
  }

  // 2. FUNGSI CEK TIPE (Dipakai oleh UI)
  // Cek apakah string ini URL (Upload-an) atau Asset (Bawaan)
  static bool isUrl(String avatarData) {
    return avatarData.startsWith('http') || avatarData.startsWith('https');
  }

  // 3. FUNGSI GET FULL ASSET PATH
  // Menggabungkan path folder dengan nama file
  static String getAssetPath(String fileName) {
    return '$_assetPath/$fileName';
  }
}