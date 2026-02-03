import 'dart:io';
import 'package:flutter/material.dart';
import '../services/profile_manager.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onTap; // Aksi ketika foto diklik

  const ProfileAvatarWidget({
    Key? key,
    required this.isGuest,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50, // Sesuaikan ukuran
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: SizedBox(
            width: 100,
            height: 100,
            child: isGuest 
                ? _buildGuestImage() 
                : _buildUserImage(),
          ),
        ),
      ),
    );
  }

  // Tampilan untuk Guest (Load dari Assets)
  Widget _buildGuestImage() {
    return FutureBuilder<String>(
      future: ProfileManager().getGuestAvatar(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        
        // Load dari assets/ppicture/original/
        return Image.asset(
          'assets/ppicture/original/${snapshot.data}',
          fit: BoxFit.cover,
        );
      },
    );
  }

  // Tampilan untuk User (Load dari Lokal HP)
  Widget _buildUserImage() {
    return FutureBuilder<File?>(
      future: ProfileManager().getUserImageLocal(),
      builder: (context, snapshot) {
        // Jika sedang loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // Jika ada file lokal (Offline support jalan disini)
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            fit: BoxFit.cover,
            // Kunci agar refresh gambar jalan saat overwrite:
            key: ValueKey(DateTime.now().toString()), 
          );
        }

        // Jika user belum pernah upload sama sekali, tampilkan default asset
        return Image.asset(
          'assets/ppicture/original/default.png',
          fit: BoxFit.cover,
        );
      },
    );
  }
}