import 'package:flutter/gestures.dart'; 
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
  
  // [BARU] Dua variabel untuk checkbox
  bool _isTosAccepted = false; 
  bool _isPrivacyAccepted = false; 

  // --- LOGIC REGISTER EMAIL ---
  Future<void> _handleRegister() async {
    // 1. Validasi Input Kosong
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua kolom wajib diisi")));
      return;
    }

    // 2. [PERBAIKAN] Validasi Checkbox Ganda
    if (!_isTosAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda harus menyetujui Syarat & Ketentuan"), backgroundColor: Colors.redAccent)
      );
      return;
    }

    if (!_isPrivacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda harus menyetujui Kebijakan Privasi"), backgroundColor: Colors.redAccent)
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

  // --- LOGIC GOOGLE SIGN IN ---
  Future<void> _handleGoogleLogin() async {
    // Google Login juga butuh persetujuan ToS & Privacy
    if (!_isTosAccepted || !_isPrivacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon setujui Syarat & Ketentuan serta Kebijakan Privasi."), backgroundColor: Colors.orange)
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await AuthManager().loginWithGoogle();
      await ProgressManager.init();
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil masuk dengan Google!"), backgroundColor: Colors.green)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // [BARU] Dialog Syarat & Ketentuan (English)
  void _showTosDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Terms & Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          height: 400,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Effective Date: 2026-02-04", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 15),
                
                _buildBoldText("Introduction"),
                const Text("These terms and conditions apply to the Logithm app (hereby referred to as \"Application\") for mobile devices that was created by Luthfi Fuad Radityawan (hereby referred to as \"Service Provider\") as a Free service. Upon downloading or utilizing the Application, you are automatically agreeing to the following terms. It is strongly advised that you thoroughly read and understand these terms prior to using the Application."),
                const SizedBox(height: 10),

                _buildBoldText("Intellectual Property"),
                const Text("Unauthorized copying, modification of the Application, any part of the Application, or our trademarks is strictly prohibited. Any attempts to extract the source code of the Application, translate the Application into other languages, or create derivative versions are not permitted. All trademarks, copyrights, database rights, and other intellectual property rights related to the Application remain the property of the Service Provider."),
                const SizedBox(height: 10),

                _buildBoldText("Modifications & Charges"),
                const Text("The Service Provider is dedicated to ensuring that the Application is as beneficial and efficient as possible. As such, they reserve the right to modify the Application or charge for their services at any time and for any reason. The Service Provider assures you that any charges for the Application or its services will be clearly communicated to you."),
                const SizedBox(height: 10),

                _buildBoldText("Data Security & Device Usage"),
                const Text("The Application stores and processes personal data that you have provided to the Service Provider in order to provide the Service. It is your responsibility to maintain the security of your phone and access to the Application. The Service Provider strongly advise against jailbreaking or rooting your phone."),
                const SizedBox(height: 10),

                _buildBoldText("Third-Party Services"),
                const Text("Please note that the Application utilizes third-party services that have their own Terms and Conditions:\n• Google Play Services"),
                const SizedBox(height: 10),

                _buildBoldText("Connectivity & Charges"),
                const Text("Some functions of the Application require an active internet connection. The Service Provider cannot be held responsible if the Application does not function at full capacity due to lack of access to Wi-Fi or if you have exhausted your data allowance. You may incur charges from your mobile provider for data usage."),
                const SizedBox(height: 10),

                _buildBoldText("Updates & Termination"),
                const Text("The Service Provider may wish to update the application at some point. You agree to always accept updates to the application when offered to you. The Service Provider may also wish to cease providing the application and may terminate its use at any time without providing termination notice to you."),
                const SizedBox(height: 10),

                _buildBoldText("Contact Us"),
                const Text("If you have any questions or suggestions about the Terms and Conditions, please do not hesitate to contact the Service Provider at logithm.projects@gmail.com."),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _isTosAccepted = true);
              Navigator.pop(ctx);
            },
            child: const Text("I Agree"),
          )
        ],
      ),
    );
  }

  // [BARU] Dialog Kebijakan Privasi (English)
  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          height: 400,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Effective Date: 2026-02-04", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 15),

                const Text("This privacy policy is applicable to the Logithm app (hereinafter referred to as \"Application\") for mobile devices, which was developed by Luthfi Fuad Radityawan (hereinafter referred to as \"Service Provider\") as a Free service. This service is provided \"AS IS\"."),
                const SizedBox(height: 10),

                _buildBoldText("1. User Provided Information"),
                const Text("The Application acquires the information you supply when you download and register the Application. Registration is optional but recommended. However, bear in mind that you might not be able to utilize some of the features offered by the Application (such as saving game progress, leaderboard, and cloud sync) unless you register.\n\nWhen you register with us, you generally provide:\n• Your email address and username.\n• Password (encrypted securely via Supabase Auth).\n• Game progress data (scores, levels, and achievements)."),
                const SizedBox(height: 10),

                _buildBoldText("2. Automatically Collected Information"),
                const Text("In addition, the Application may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, and information about the way you use the Application."),
                const SizedBox(height: 10),

                _buildBoldText("3. Third Party Access & Backend"),
                const Text("Important Note on Backend Services:\nThis Application utilizes Supabase as a backend service provider for Authentication (Login/Register) and Database storage. By using this Application, you acknowledge that your data (Email, User ID, and Game Progress) is stored securely on Supabase servers.\n\nThird-party service providers used by the Application:\n• Google Play Services\n• Supabase"),
                const SizedBox(height: 10),

                _buildBoldText("4. Data Retention & Deletion"),
                const Text("The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter.\n\nRight to Delete Data:\nIf you would like to delete your account and all associated data (including high scores and progress) from our servers, please contact us at logithm.projects@gmail.com with the subject \"Delete Account\". We will process your request and permanently remove your data within a reasonable timeframe."),
                const SizedBox(height: 10),

                _buildBoldText("5. Children's Privacy"),
                const Text("The Service Provider does not knowingly collect personally identifiable information from children under the age of 13. If you are a parent or guardian and you are aware that your child has provided us with personal information without consent, please contact the Service Provider."),
                const SizedBox(height: 10),

                _buildBoldText("6. Security"),
                const Text("We provide physical, electronic, and procedural safeguards to protect information we process and maintain. Your passwords are never stored in plain text but are hashed and salted using industry-standard encryption provided by Supabase Auth."),
                const SizedBox(height: 10),

                _buildBoldText("Contact Us"),
                const Text("If you have any questions regarding privacy while using the Application, please contact the Service Provider via email at logithm.projects@gmail.com."),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _isPrivacyAccepted = true);
              Navigator.pop(ctx);
            },
            child: const Text("I Agree"),
          )
        ],
      ),
    );
  }

  // Helper untuk teks tebal
  Widget _buildBoldText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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

              // --- CHECKBOX 1: Syarat & Ketentuan ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: _isTosAccepted,
                      activeColor: primaryColor,
                      onChanged: (val) => setState(() => _isTosAccepted = val ?? false),
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
                              color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()..onTap = _showTosDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // --- CHECKBOX 2: Kebijakan Privasi ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: _isPrivacyAccepted,
                      activeColor: primaryColor,
                      onChanged: (val) => setState(() => _isPrivacyAccepted = val ?? false),
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
                            text: "Kebijakan Privasi",
                            style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()..onTap = _showPrivacyDialog,
                          ),
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

              const SizedBox(height: 20),
              
              // --- OR DIVIDER ---
              Row(children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("ATAU", style: TextStyle(color: Colors.grey[500], fontSize: 12))),
                Expanded(child: Divider(color: Colors.grey[300])),
              ]),
              const SizedBox(height: 20),

              // --- GOOGLE BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : _handleGoogleLogin,
                  icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red), 
                  label: const Text("Daftar dengan Google", style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(color: Colors.grey[300]!)
                  ),
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