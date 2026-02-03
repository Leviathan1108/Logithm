import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // [WAJIB] Untuk verifikasi password lama
import '../services/auth_manager.dart';
import '../auth/login_page.dart'; // [WAJIB] Import halaman Login

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  final AuthManager auth = AuthManager();
  bool _isLoading = false;

  // --- LOGIC 1: UBAH PASSWORD DENGAN VALIDASI PASSWORD LAMA ---
  void _changePasswordDialog() {
    final oldPassCtrl = TextEditingController(); // [BARU] Controller Password Lama
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Ganti Sandi Baru"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Demi keamanan, masukkan kata sandi lama Anda.", style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 15),
              
              // [BARU] Input Password Lama
              TextField(
                controller: oldPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata Sandi Lama", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.lock_open, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 15),
              
              const Divider(),
              const SizedBox(height: 15),

              // Input Password Baru
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Sandi Baru", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.blue)
                ),
              ),
              const SizedBox(height: 10),
              
              // Input Konfirmasi Password
              TextField(
                controller: confirmPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Sandi", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.lock_reset, color: Colors.blue)
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              // 1. Validasi Input Kosong & Panjang
              if (oldPassCtrl.text.isEmpty || newPassCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua kolom harus diisi")));
                return;
              }
              if (newPassCtrl.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sandi baru minimal 6 karakter")));
                return;
              }
              if (newPassCtrl.text != confirmPassCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Konfirmasi sandi baru tidak cocok!")));
                return;
              }

              Navigator.pop(ctx); 
              setState(() => _isLoading = true); 

              try {
                final supabase = Supabase.instance.client;
                final email = auth.email;

                if (email == null) throw "Email user tidak ditemukan.";

                // 2. [BARU] Verifikasi Password Lama (Re-authentication)
                // Kita coba login dengan password lama. Jika gagal, berarti password lama salah.
                await supabase.auth.signInWithPassword(
                  email: email,
                  password: oldPassCtrl.text,
                );

                // 3. Jika berhasil login, baru update ke password baru
                await auth.updatePassword(newPassCtrl.text);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sandi berhasil diperbarui!"), backgroundColor: Colors.green));
                }
              } catch (e) {
                if (mounted) {
                  String msg = "Gagal memperbarui sandi.";
                  if (e.toString().contains("Invalid login credentials")) {
                    msg = "Kata sandi lama salah!";
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            child: const Text("Simpan")
          )
        ],
      ),
    );
  }

  // --- LOGIC 2: LUPA PASSWORD (FLOW OTP MANUAL) ---
  void _startForgotPasswordFlow() {
    final emailCtrl = TextEditingController(text: auth.email); 

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Lupa Kata Sandi?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Kami akan mengirimkan KODE VERIFIKASI ke email Anda."),
            const SizedBox(height: 15),
            TextField(
              controller: emailCtrl,
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
              if (emailCtrl.text.isEmpty) return;
              
              Navigator.pop(ctx);
              setState(() => _isLoading = true);
              
              try {
                await auth.sendForgotPasswordOTP(emailCtrl.text.trim());
                
                if (mounted) {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => VerifyOtpPage(email: emailCtrl.text.trim()))
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red));
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
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
    return Scaffold(
      appBar: AppBar(title: const Text("Keamanan Akun")),
      body: Stack(
        children: [
          ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Kelola keamanan akun Anda. Jangan berikan kata sandi kepada siapa pun.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.lock, color: Colors.blue),
                ),
                title: const Text("Ubah Kata Sandi"),
                subtitle: const Text("Ganti sandi saat ini dengan yang baru"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: _changePasswordDialog,
              ),
              
              const Divider(),

              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.mark_email_read, color: Colors.orange),
                ),
                title: const Text("Lupa Kata Sandi?"),
                subtitle: const Text("Reset sandi menggunakan Kode OTP"),
                trailing: const Icon(Icons.send, size: 16, color: Colors.grey),
                onTap: _startForgotPasswordFlow, 
              ),
            ],
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

// --- HALAMAN 1: INPUT OTP ---
class VerifyOtpPage extends StatefulWidget {
  final String email;
  const VerifyOtpPage({super.key, required this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final otpCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Masukkan kode 6 digit yang dikirim ke ${widget.email}", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              maxLength: 6,
              decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ""),
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    if (otpCtrl.text.length < 6) return;
                    setState(() => _isLoading = true);
                    
                    try {
                      bool isValid = await AuthManager().verifyOTP(widget.email, otpCtrl.text);
                      if (isValid) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordFormPage(email: widget.email, otpCode: otpCtrl.text)
                            )
                          );
                        }
                      } else {
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode salah atau kadaluarsa")));
                      }
                    } catch (e) {
                      // Error handle
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text("Verifikasi"),
                )
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN 2: INPUT PASSWORD BARU (RESET) ---
class ResetPasswordFormPage extends StatefulWidget {
  final String email;
  final String otpCode;
  const ResetPasswordFormPage({super.key, required this.email, required this.otpCode});

  @override
  State<ResetPasswordFormPage> createState() => _ResetPasswordFormPageState();
}

class _ResetPasswordFormPageState extends State<ResetPasswordFormPage> {
  final passCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Kata Sandi")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Silakan masukkan kata sandi baru Anda."),
            const SizedBox(height: 20),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Sandi Baru", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    if (passCtrl.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Minimal 6 karakter")));
                      return;
                    }
                    setState(() => _isLoading = true);

                    try {
                      // Panggil Reset Manual
                      await AuthManager().resetPasswordManual(widget.email, passCtrl.text, widget.otpCode);
                      
                      if (mounted) {
                        // [UPDATE]: Langsung ke halaman Login dan hapus semua history navigasi
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()), 
                          (route) => false // Hapus semua rute sebelumnya
                        );

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sandi berhasil direset. Silakan login kembali."), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text("Simpan Sandi Baru"),
                )
          ],
        ),
      ),
    );
  }
}