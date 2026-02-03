import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_manager.dart';
import '../services/progress_manager.dart';
import 'edit_page.dart'; 
import 'account_security_page.dart'; 
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../home/home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthManager auth = AuthManager();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isGuest = auth.currentUserType == UserType.guest;

    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: Stack(
        children: [
          ListView(
            children: [
              if (isGuest) _buildGuestLoginSection(),

              // BAGIAN 1: PROFIL
              _buildSectionHeader("Profil"),
              
              // 1. Ubah Nama & Foto
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                title: const Text("Ubah Nama & Foto"),
                trailing: isGuest 
                    ? const Icon(Icons.lock, size: 18, color: Colors.grey) 
                    : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: isGuest ? () => _showGuestAlert() : _navigateToEditProfile, 
              ),

              // 2. Keamanan Akun
              ListTile(
                leading: const Icon(Icons.security, color: Colors.redAccent),
                title: const Text("Keamanan Akun"),
                subtitle: const Text("Ubah kata sandi & pemulihan"),
                trailing: isGuest 
                    ? const Icon(Icons.lock, size: 18, color: Colors.grey) 
                    : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: isGuest ? () => _showGuestAlert() : _navigateToAccountSecurity, 
              ),

              // BAGIAN 2: BANTUAN
              _buildSectionHeader("Bantuan"),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.indigo),
                title: const Text("Panduan Aplikasi"),
                subtitle: const Text("Tampilkan ulang semua tutorial"),
                trailing: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                onTap: _replayTutorial,
              ),

              // BAGIAN 3: INFORMASI APLIKASI
              _buildSectionHeader("Informasi Aplikasi"),
              
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.purple),
                title: const Text("Tentang Kami"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => _showInfoDialog(
                  "Tentang Logithm", 
                  "Logithm adalah aplikasi pembelajaran algoritma interaktif berbasis mobile.\n\nVersi Aplikasi: 1.0.0\nDeveloper: Luthfi Fuad Radityawan"
                ),
              ),

              ListTile(
                leading: const Icon(Icons.headset_mic, color: Colors.orange),
                title: const Text("Hubungi Kami"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => _showInfoDialog(
                  "Hubungi Kami", 
                  "Email: logithm.projects@gmail.com"
                ),
              ),

              ListTile(
                leading: const Icon(Icons.description, color: Colors.blueGrey),
                title: const Text("Syarat & Ketentuan"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: _showTosDialog, // Memanggil Dialog Terms & Conditions Baru
              ),

              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.teal),
                title: const Text("Kebijakan Privasi"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: _showPrivacyDialog, // Memanggil Dialog Privacy Policy Baru
              ),

              const Divider(height: 40),

              // BAGIAN 4: LOGOUT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(),
                    icon: Icon(isGuest ? Icons.delete_forever : Icons.logout, color: Colors.white),
                    label: Text(
                      isGuest ? "Hapus Data Tamu & Reset" : "Keluar (Logout)", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              
              if(isGuest)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Catatan: Anda sedang dalam Mode Tamu.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                )
            ],
          ),
          
          if (_isLoading)
            Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // --- NAVIGASI ---
  void _navigateToAccountSecurity() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const AccountSecurityPage())
    );
  }

  // =========================================================================
  // UPDATE: DIALOG SYARAT & KETENTUAN (SESUAI HTML YANG DIKIRIM)
  // =========================================================================
  void _showTosDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Terms & Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          height: 500, // Tinggi fixed agar bisa scroll
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Effective Date: 2028-08-28", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                const SizedBox(height: 15),
                
                _buildBoldText("Introduction"),
                const Text("These terms and conditions apply to the Logithm app (hereby referred to as \"Application\") for mobile devices that was created by Luthfi Fuad Radityawan (hereby referred to as \"Service Provider\") as a Free service."),
                const SizedBox(height: 10),
                
                const Text("Upon downloading or utilizing the Application, you are automatically agreeing to the following terms. It is strongly advised that you thoroughly read and understand these terms prior to using the Application."),
                const SizedBox(height: 15),

                _buildBoldText("Intellectual Property"),
                const Text("Unauthorized copying, modification of the Application, any part of the Application, or our trademarks is strictly prohibited. Any attempts to extract the source code of the Application, translate the Application into other languages, or create derivative versions are not permitted. All trademarks, copyrights, database rights, and other intellectual property rights related to the Application remain the property of the Service Provider."),
                const SizedBox(height: 15),

                _buildBoldText("Modifications & Charges"),
                const Text("The Service Provider is dedicated to ensuring that the Application is as beneficial and efficient as possible. As such, they reserve the right to modify the Application or charge for their services at any time and for any reason. The Service Provider assures you that any charges for the Application or its services will be clearly communicated to you."),
                const SizedBox(height: 15),

                _buildBoldText("Data Security & Device Usage"),
                const Text("The Application stores and processes personal data that you have provided to the Service Provider in order to provide the Service. It is your responsibility to maintain the security of your phone and access to the Application. The Service Provider strongly advise against jailbreaking or rooting your phone."),
                const SizedBox(height: 15),

                _buildBoldText("Third-Party Services"),
                const Text("Please note that the Application utilizes third-party services that have their own Terms and Conditions:"),
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Text("• Google Play Services"),
                ),
                const SizedBox(height: 15),

                _buildBoldText("Connectivity & Charges"),
                const Text("Some functions of the Application require an active internet connection. The Service Provider cannot be held responsible if the Application does not function at full capacity due to lack of access to Wi-Fi or if you have exhausted your data allowance. You may incur charges from your mobile provider for data usage."),
                const SizedBox(height: 15),

                _buildBoldText("Updates & Termination"),
                const Text("The Service Provider may wish to update the application at some point. You agree to always accept updates to the application when offered to you. The Service Provider may also wish to cease providing the application and may terminate its use at any time without providing termination notice to you."),
                const SizedBox(height: 15),

                _buildBoldText("Contact Us"),
                const Text("If you have any questions or suggestions about the Terms and Conditions, please do not hesitate to contact the Service Provider at logithm.projects@gmail.com."),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
        ],
      ),
    );
  }

  // =========================================================================
  // UPDATE: DIALOG PRIVACY POLICY (SESUAI HTML YANG DIKIRIM)
  // =========================================================================
  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          height: 500, // Tinggi fixed agar bisa scroll
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Effective Date: 2028-01-01", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                const SizedBox(height: 15),

                const Text("This privacy policy is applicable to the Logithm app (hereinafter referred to as \"Application\") for mobile devices, which was developed by Luthfi Fuad Radityawan (hereinafter referred to as \"Service Provider\") as a Free service. This service is provided \"AS IS\"."),
                const SizedBox(height: 15),

                _buildBoldText("1. User Provided Information"),
                const Text("The Application acquires the information you supply when you download and register the Application. Registration is optional but recommended. However, bear in mind that you might not be able to utilize some of the features offered by the Application (such as saving game progress, leaderboard, and cloud sync) unless you register."),
                const SizedBox(height: 5),
                const Text("When you register with us, you generally provide:"),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• Your email address and username."),
                      Text("• Password (encrypted securely via Supabase Auth)."),
                      Text("• Game progress data (scores, levels, and achievements)."),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                _buildBoldText("2. Automatically Collected Information"),
                const Text("In addition, the Application may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, and information about the way you use the Application."),
                const SizedBox(height: 15),

                _buildBoldText("3. Third Party Access & Backend"),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Important Note on Backend Services:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 5),
                      const Text("This Application utilizes Supabase as a backend service provider for Authentication (Login/Register) and Database storage. By using this Application, you acknowledge that your data (Email, User ID, and Game Progress) is stored securely on Supabase servers.", style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Third-party service providers used by the Application:"),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• Google Play Services"),
                      Text("• Supabase"),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                _buildBoldText("4. Data Retention & Deletion"),
                const Text("The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter."),
                const SizedBox(height: 5),
                const Text("Right to Delete Data:", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("If you would like to delete your account and all associated data (including high scores and progress) from our servers, please contact us at logithm.projects@gmail.com with the subject \"Delete Account\". We will process your request and permanently remove your data within a reasonable timeframe."),
                const SizedBox(height: 15),

                _buildBoldText("5. Children's Privacy"),
                const Text("The Service Provider does not knowingly collect personally identifiable information from children under the age of 13. If you are a parent or guardian and you are aware that your child has provided us with personal information without consent, please contact the Service Provider."),
                const SizedBox(height: 15),

                _buildBoldText("6. Security"),
                const Text("We provide physical, electronic, and procedural safeguards to protect information we process and maintain. Your passwords are never stored in plain text but are hashed and salted using industry-standard encryption provided by Supabase Auth."),
                const SizedBox(height: 15),

                _buildBoldText("Contact Us"),
                const Text("If you have any questions regarding privacy while using the Application, please contact the Service Provider via email at logithm.projects@gmail.com."),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
        ],
      ),
    );
  }

  // Helper kecil untuk membuat Teks Bold
  Widget _buildBoldText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
    );
  }

  // --- HELPER LAINNYA (TIDAK BERUBAH) ---
  
  Future<void> _replayTutorial() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ulangi Semua Panduan?"),
        content: const Text("Aplikasi akan kembali ke Beranda dan menampilkan ulang semua tutorial."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Ya, Ulangi")),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setBool('has_shown_home_tutorial', false),
        prefs.setBool('has_shown_learning_tutorial', false),
        prefs.setBool('has_shown_latihan_tutorial', false),
        prefs.setBool('has_shown_quiz_tutorial', false),
        prefs.setBool('has_shown_quiz_basic_tutorial', false),
      ]);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup"))
        ],
      ),
    );
  }

  Widget _buildGuestLoginSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50], 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_off, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Simpan Progres Anda!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text("Login untuk simpan skor & buka fitur.", style: TextStyle(fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _navigateToLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, elevation: 0),
                  child: const Text("Masuk"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: _navigateToRegister,
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blue)),
                  child: const Text("Daftar"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  void _showGuestAlert() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Silakan Login/Daftar untuk akses fitur ini."), backgroundColor: Colors.orange));
  }

  void _navigateToLogin() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    if (result == true && mounted) setState(() {}); 
  }

  void _navigateToRegister() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
    if (result == true && mounted) setState(() {}); 
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
    if (result == true && mounted) setState(() {}); 
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    await auth.logout();
    await ProgressManager.init(); 
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context, true); 
    }
  }
}