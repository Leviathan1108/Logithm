import 'package:flutter/material.dart';
import '../services/auth_manager.dart';
import '../services/progress_manager.dart';
import 'register_page.dart'; // Import halaman register
import '../settings/account_security_page.dart'; // [PENTING] Import halaman VerifyOtpPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email dan Password harus diisi")));
       return;
    }

    setState(() => isLoading = true);
    try {
      await AuthManager().login(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );
      
      await ProgressManager.init();
      
      if (mounted) {
        Navigator.pop(context, true); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil!"), backgroundColor: Colors.green)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Gagal: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- LOGIC LUPA PASSWORD (FROM LOGIN PAGE) ---
  void _forgotPasswordFlow() {
    // Gunakan email yang sudah diketik user (jika ada) sebagai pre-fill
    final resetEmailCtrl = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Lupa Kata Sandi?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Kami akan mengirimkan KODE OTP ke email Anda untuk reset password."),
            const SizedBox(height: 15),
            TextField(
              controller: resetEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Anda",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (resetEmailCtrl.text.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email wajib diisi")));
                 return;
              }
              
              Navigator.pop(ctx);
              setState(() => isLoading = true); // Tampilkan loading di halaman login
              
              try {
                // 1. Kirim OTP via SMTP (AuthManager Manual Flow)
                await AuthManager().sendForgotPasswordOTP(resetEmailCtrl.text.trim());
                
                if (mounted) {
                  // 2. Buka Halaman Verifikasi OTP (yang ada di file account_security_page.dart)
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => VerifyOtpPage(email: resetEmailCtrl.text.trim()))
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red));
                }
              } finally {
                if (mounted) setState(() => isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            child: const Text("Kirim Kode"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blueAccent;

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
              // --- LOGO LOGITHM ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1), // Fix: withOpacity lebih umum
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_open_rounded, size: 50, color: primaryColor),
              ),
              const SizedBox(height: 16),
              const Text(
                "LOGITHM",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 3.0, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text("Selamat datang kembali, Learners!", style: TextStyle(fontSize: 14, color: Colors.grey[600])),

              const SizedBox(height: 40),
              
              // --- INPUT EMAIL ---
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                hint: "Masukkan email terdaftar",
                inputType: TextInputType.emailAddress,
                accentColor: primaryColor,
              ),
              const SizedBox(height: 20),
              
              // --- INPUT PASSWORD ---
              _buildTextField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline,
                hint: "Masukkan kata sandi",
                isObscure: true,
                accentColor: primaryColor,
              ),
              
              // --- TOMBOL LUPA PASSWORD [BARU] ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPasswordFlow,
                  child: const Text("Lupa Kata Sandi?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 20), // Jarak disesuaikan karena ada tombol lupa password
              
              // --- TOMBOL MASUK ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15), 
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: isLoading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                    : const Text("MASUK AKUN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // --- FOOTER (REGISTER LINK) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? ", style: TextStyle(color: Colors.grey[700])),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const RegisterPage())
                      );
                    },
                    child: const Text("Daftar Sekarang", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color accentColor,
    String? hint,
    bool isObscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
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
          prefixIcon: Icon(icon, color: accentColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}