import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // [WAJIB] Import Supabase

import '../widgets/custom_avatar.dart'; 

class FriendProfilePage extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const FriendProfilePage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    // --- 1. DATA USER YANG DILAPORKAN (TERLAPOR) ---
    // Data ini dikirim dari halaman list teman
    final String reportedUsername = profileData['username'] ?? "Unknown";
    // Pastikan query Supabase sebelumnya menyertakan kolom 'email'
    final String reportedEmail = profileData['email'] ?? "Email tidak tersedia"; 
    
    final String avatarData = profileData['avatar_data'] ?? "foto1.png";
    final int colorIndex = int.tryParse(profileData['avatar_color_index'].toString()) ?? 3;
    final String status = profileData['status'] ?? 'auto';
    final int totalScore = int.tryParse(profileData['total_score'].toString()) ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Profil $reportedUsername"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.redAccent),
            tooltip: "Laporkan Pengguna",
            onPressed: () {
              _showReportDialog(context, reportedUsername, reportedEmail);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  CustomAvatar(
                    avatarData: avatarData,
                    colorIndex: colorIndex,
                    radius: 70,
                    showStatus: true,
                    status: status,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    reportedUsername,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
                      _buildStatBox("Total Poin", "$totalScore", Icons.star, Colors.amber),
                      _buildStatBox("Level", "User", Icons.verified, Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI KIRIM EMAIL (SMTP) ---
  Future<void> _sendReportEmail(
    String reporterName, 
    String reporterEmail, 
    String reportedName, 
    String reportedEmail, 
    String reason
  ) async {
    // Konfigurasi Email Pengirim (Gunakan App Password Google)
    String username = 'logithm.projects@gmail.com'; 
    String password = 'kati tyxg pzze bcnn'; // GANTI dengan App Password Anda

    final smtpServer = gmail(username, password);

    // Isi Email
    final message = Message()
      ..from = Address(username, 'Sistem Pelaporan Logithm')
      ..recipients.add('logithm.projects@gmail.com') // Email Developer Tujuan
      ..subject = 'LAPORAN USER: $reportedName'
      ..text = '''
Halo Developer Logithm,

Ada laporan baru dari pengguna aplikasi (Supabase):

DATA PELAPOR (YANG MELAPOR):
- Username : $reporterName
- Email    : $reporterEmail

DATA TERLAPOR (YANG DILAPORKAN):
- Username : $reportedName
- Email    : $reportedEmail

KELUHAN / ALASAN:
$reason

Mohon segera ditindaklanjuti.
Terima kasih.
''';

    try {
      await send(message, smtpServer);
      debugPrint('Email laporan terkirim.');
    } on MailerException catch (e) {
      debugPrint('Gagal mengirim email.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
      throw e; 
    }
  }

  // --- FUNGSI POP UP & LOGIKA SUPABASE ---
  void _showReportDialog(BuildContext context, String reportedName, String reportedEmail) {
    final TextEditingController otherController = TextEditingController();
    String? selectedReason;
    bool isLoading = false; 

    // --- 2. AMBIL DATA PELAPOR DARI SUPABASE ---
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // Default jika user belum login atau data null
    String myEmail = user?.email ?? "anonim@unknown.com";
    String myUsername = "Loading..."; 

    final List<String> reasons = [
      "Spam",
      "Konten Tidak Pantas",
      "Pelecehan / Harassment",
      "Akun Palsu",
      "Lainnya"
    ];

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            
            // Fetch Username Pelapor saat dialog dibuka (sekali saja)
            // Asumsi: Tabel user Anda bernama 'users' atau data ada di 'user_metadata'
            if (myUsername == "Loading...") {
              // Opsi A: Jika username ada di tabel khusus 'users'
              /*
              supabase
                  .from('users') 
                  .select('username')
                  .eq('id', user?.id ?? '')
                  .maybeSingle()
                  .then((data) {
                    if (context.mounted) {
                      setState(() {
                        myUsername = data?['username'] ?? myEmail.split('@')[0];
                      });
                    }
                  });
              */

              // Opsi B: Jika username ada di user_metadata (Lebih umum di Supabase Auth)
              if (user?.userMetadata != null && user!.userMetadata!.containsKey('username')) {
                 myUsername = user.userMetadata!['username'];
                 // Trigger rebuild untuk update tampilan jika perlu
              } else {
                 myUsername = myEmail.split('@')[0]; // Fallback ke bagian depan email
              }
            }

            return AlertDialog(
              title: Text("Laporkan $reportedName"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading) 
                      const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ))
                    else ...[
                      const Text("Apa alasan Anda melaporkan akun ini?"),
                      const SizedBox(height: 10),
                      ...reasons.map((reason) {
                        return RadioListTile<String>(
                          title: Text(reason),
                          value: reason,
                          groupValue: selectedReason,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        );
                      }).toList(),
                      if (selectedReason == "Lainnya")
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            controller: otherController,
                            decoration: const InputDecoration(
                              labelText: "Tulis detail keluhan...",
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                        ),
                    ]
                  ],
                ),
              ),
              actions: isLoading ? [] : [ 
                TextButton(
                  child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Kirim Laporan"),
                  onPressed: () async {
                    if (selectedReason == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pilih alasan terlebih dahulu")),
                       );
                       return;
                    }

                    String finalReason = selectedReason == "Lainnya" 
                        ? "Lainnya: ${otherController.text}" 
                        : selectedReason!;

                    setState(() => isLoading = true); 

                    try {
                      // Kirim data lengkap ke fungsi email
                      await _sendReportEmail(
                        myUsername, 
                        myEmail, 
                        reportedName, 
                        reportedEmail, 
                        finalReason
                      );

                      if (context.mounted) {
                        Navigator.of(context).pop(); 
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Laporan berhasil dikirim ke Developer."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      setState(() => isLoading = false); 
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal mengirim laporan: $e")),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildStatusBadge(String status) {
    String label;
    Color color;
    switch (status) {
      case 'online': label = "Sedang Online"; color = Colors.green; break;
      case 'busy': label = "Sedang Sibuk"; color = Colors.amber; break;
      case 'offline': label = "Offline"; color = Colors.grey; break;
      default: label = "Online"; color = Colors.green; break;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}