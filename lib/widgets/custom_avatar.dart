import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String avatarData; 
  final int colorIndex;    
  final double radius;
  final String status; // 'auto', 'online', 'busy', 'offline'
  final bool showStatus; // Mau nampilin status nggak?

  const CustomAvatar({
    super.key,
    required this.avatarData,
    required this.colorIndex,
    this.radius = 40,
    this.status = 'auto', 
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    // List warna background avatar
    final List<Color> bgColors = [
      Colors.red.shade400,
      Colors.green.shade400,
      Colors.amber.shade400,
      Colors.blue.shade400,
    ];

    Color bgColor = (colorIndex >= 0 && colorIndex < bgColors.length) 
        ? bgColors[colorIndex] 
        : Colors.blue.shade400;

    return Stack(
      children: [
        // 1. GAMBAR UTAMA
        CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipOval(
              child: _getImageWidget(),
            ),
          ),
        ),

        // 2. INDIKATOR STATUS (Bulatan Kecil)
        if (showStatus)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: radius * 0.6, // Ukuran dinamis sesuai radius avatar
              height: radius * 0.6,
              decoration: BoxDecoration(
                color: _getStatusColor(),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2), // Border putih biar rapi
              ),
            ),
          ),
      ],
    );
  }

  // Logic Warna Status
  Color _getStatusColor() {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'busy':
        return Colors.amber;
      case 'offline':
        return Colors.grey;
      case 'auto':
      default:
        return Colors.green; // Default auto dianggap online saat app dibuka
    }
  }

  Widget _getImageWidget() {
    if (avatarData.isEmpty) {
      return Image.asset('assets/ppicture/original/foto1.png', fit: BoxFit.contain);
    }
    if (avatarData.startsWith('http')) {
      return Image.network(
        avatarData,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
      );
    }
    return Image.asset(
      'assets/ppicture/original/$avatarData',
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
    );
  }
}