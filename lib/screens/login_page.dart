import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import 'main_screen.dart'; // ✅ Updated to use MainScreen after login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true; // <-- Added for password visibility toggle

  void _navigateToMain(User? user) {
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()), // ✅ Use bottom navigation screen
      );
    }
  }

  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  Future<void> _handleEmailLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await _auth.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      _navigateToMain(user);
    } catch (e) {
      setState(() {
        _error = 'Login failed. Please check your credentials.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSocialLogin(Future<User?> Function() loginMethod) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await loginMethod();
      _navigateToMain(user);
    } catch (e) {
      setState(() {
        _error = 'Social login failed. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _socialIconWithLabel({
    required Widget iconWidget,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
    double iconSize = 40,
    double radius = 32,
    bool showBorder = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: showBorder
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  )
                : null,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: bgColor,
              child: Center(
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Center(child: iconWidget),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 64,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Veyo',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C853),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Move smarter in Africa.",
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Or continue with"),
              const SizedBox(height: 16),

              if (!_isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialIconWithLabel(
                      iconWidget: SvgPicture.asset(
                        'assets/images/icons/google.svg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      label: "Google",
                      bgColor: Colors.white,
                      radius: 32,
                      iconSize: 40,
                      onTap: () => _handleSocialLogin(_auth.signInWithGoogle),
                      showBorder: true,
                    ),
                    _socialIconWithLabel(
                      iconWidget: const Center(
                        child: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 32),
                      ),
                      label: "Facebook",
                      bgColor: const Color(0xFF1877F2),
                      radius: 32,
                      iconSize: 32,
                      onTap: () => _handleSocialLogin(_auth.signInWithFacebook),
                    ),
                    _socialIconWithLabel(
                      iconWidget: const Center(
                        child: FaIcon(FontAwesomeIcons.apple, color: Colors.white, size: 32),
                      ),
                      label: "Apple",
                      bgColor: Colors.black,
                      radius: 32,
                      iconSize: 32,
                      onTap: () => _handleSocialLogin(_auth.signInWithApple),
                    ),
                  ],
                ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New here?"),
                  TextButton(
                    onPressed: _navigateToSignup,
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}