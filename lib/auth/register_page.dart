import 'package:flutter/gestures.dart'; // [PENTING] Untuk TextSpan clickable
import 'package:flutter/material.dart';
import '../services/auth_manager.dart';
import '../services/progress_manager.dart';
import 'login_page.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool isLoading = false;
  bool _isTosAccepted = false; // [BARU] Variable status checkbox

  Future<void> _handleRegister() async {
    // 1. Validasi Input Kosong
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua kolom wajib diisi")));
      return;
    }

    // 2. [BARU] Validasi Checkbox ToS
    if (!_isTosAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Anda harus menyetujui Syarat & Ketentuan"), 
          backgroundColor: Colors.redAccent
        )
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await AuthManager().register(
        _emailController.text.trim(), 
        _passwordController.text.trim(),
        _usernameController.text.trim()
      );
      
      await ProgressManager.init();

      if (mounted) {
        Navigator.pop(context, true); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akun Berhasil Dibuat!"), backgroundColor: Colors.green)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // [BARU] Fungsi Menampilkan Pop-up ToS
  void _showTosDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Syarat & Ketentuan", style: TextStyle(fontWeight: FontWeight.bold)),
        // Menggunakan Container dengan tinggi terbatas agar bisa discroll
        content: SizedBox(
          height: 400, // Batasi tinggi agar tidak memenuhi layar
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Terakhir Diperbarui: 25 Mei 2024", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey)),
                SizedBox(height: 15),
                
                Text("1. Pendahuluan", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Selamat datang di Logithm. Dengan mendaftar dan menggunakan aplikasi ini, Anda setuju untuk tunduk pada Syarat dan Ketentuan berikut. Jika Anda tidak setuju, mohon untuk tidak menggunakan aplikasi ini."),
                SizedBox(height: 10),

                Text("2. Akun Pengguna", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("• Anda bertanggung jawab penuh atas keamanan akun dan kata sandi Anda.\n• Anda setuju untuk memberikan data yang akurat (Username & Email) saat pendaftaran.\n• Satu akun hanya boleh digunakan oleh satu pengguna."),
                SizedBox(height: 10),

                Text("3. Privasi & Data Pengguna", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Kami menghargai privasi Anda. Data yang kami kumpulkan meliputi:\n• Nama Pengguna (Username)\n• Alamat Email\n• Progres Belajar & Skor Latihan\n\nData ini digunakan semata-mata untuk fitur Leaderboard, pemulihan akun, dan analisis progres belajar. Kami tidak akan menjual data Anda ke pihak ketiga."),
                SizedBox(height: 10),

                Text("4. Etika Penggunaan", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Saat menggunakan fitur komunitas atau leaderboard, dilarang:\n• Menggunakan kata-kata kasar, SARA, atau pornografi pada Username.\n• Melakukan kecurangan (cheating) atau memanipulasi skor.\n• Mencoba meretas atau merusak sistem aplikasi."),
                SizedBox(height: 10),

                Text("5. Kekayaan Intelektual", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Seluruh materi, soal latihan, dan kode dalam aplikasi ini adalah hak cipta Logithm. Dilarang menyalin atau mendistribusikan ulang materi untuk tujuan komersial tanpa izin."),
                SizedBox(height: 10),

                Text("6. Penafian (Disclaimer)", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Aplikasi ini disediakan 'sebagaimana adanya'. Kami berusaha menyajikan materi yang akurat, namun tidak menjamin aplikasi bebas dari kesalahan (bug) atau gangguan server."),
                SizedBox(height: 20),
                
                Text("Dengan mengklik tombol 'Saya Setuju', Anda menyatakan telah membaca dan memahami seluruh ketentuan di atas.", 
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Simpan status setuju
              setState(() => _isTosAccepted = true);
              Navigator.pop(ctx);
            },
            child: const Text("Saya Setuju"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.green;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1), 
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.code, size: 50, color: primaryColor),
              ),
              const SizedBox(height: 16),
              const Text(
                "LOGITHM",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 3.0, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text("Mulai perjalanan kodingmu di sini", style: TextStyle(fontSize: 14, color: Colors.grey[600])),

              const SizedBox(height: 40),

              // --- FORM ---
              _buildTextField(controller: _usernameController, label: "Username", icon: Icons.badge_outlined, hint: "Buat username unik"),
              const SizedBox(height: 20),
              _buildTextField(controller: _emailController, label: "Email", icon: Icons.email_outlined, hint: "contoh@email.com", inputType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildTextField(controller: _passwordController, label: "Password", icon: Icons.lock_outline, hint: "Minimal 6 karakter", isObscure: true),
              
              const SizedBox(height: 20),

              // --- [BARU] CHECKBOX Syarat & Ketentuan ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Agar sejajar atas jika teks panjang
                children: [
                  SizedBox(
                    height: 24, 
                    width: 24,
                    child: Checkbox(
                      value: _isTosAccepted,
                      activeColor: primaryColor,
                      onChanged: (val) {
                        setState(() => _isTosAccepted = val ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        children: [
                          const TextSpan(text: "Saya menyetujui "),
                          TextSpan(
                            text: "Syarat & Ketentuan",
                            style: const TextStyle(
                              color: primaryColor, 
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            // Event handler klik teks
                            recognizer: TapGestureRecognizer()..onTap = _showTosDialog,
                          ),
                          const TextSpan(text: " serta Kebijakan Privasi."),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              
              // --- TOMBOL DAFTAR ---
              SizedBox(
                width: double.infinity,
                height: 55, 
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: isLoading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                    : const Text("DAFTAR SEKARANG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),

              const SizedBox(height: 30),

              // --- FOOTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah punya akun? ", style: TextStyle(color: Colors.grey[700])),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: const Text("Masuk", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isObscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50], 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.green), 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}