import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rehlatuk/forget_password_screen.dart';
import 'signup_screen.dart';
import 'admin_login_screen.dart';
import 'user_data.dart';
import 'app_validators.dart'; // ✅ استدعاء ملف التحقق

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>(); // ✅ نموذج للتحقق

  @override
  void initState() {
    super.initState();
    _loadRememberedUser();
  }

  Future<void> _loadRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedEmail = prefs.getString('remembered_email');
    final rememberedPassword = prefs.getString('remembered_password');

    if (rememberedEmail != null && rememberedPassword != null) {
      setState(() {
        _emailController.text = rememberedEmail;
        _passwordController.text = rememberedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveUserIfRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('remembered_email', _emailController.text);
      await prefs.setString('remembered_password', _passwordController.text);
    } else {
      await prefs.remove('remembered_email');
      await prefs.remove('remembered_password');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey, // ✅
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Log In',
                      style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- Email Field ---
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: buttonTextColor),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon:
                        Icon(Icons.email_outlined, color: Colors.grey),
                      ),
                      validator: AppValidators.validateEmail, // ✅
                    ),
                    const SizedBox(height: 16),

                    // --- Password Field ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: buttonTextColor),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: AppValidators.validatePassword, // ✅
                    ),
                    const SizedBox(height: 16),

                    // --- Remember Me & Forgot Password ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(color: buttonTextColor),
                                checkColor: containerColor,
                                fillColor:
                                MaterialStateProperty.resolveWith((states) =>
                                states.contains(MaterialState.selected)
                                    ? buttonTextColor
                                    : Colors.transparent),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Remember me',
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 12)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordScreen(
                                  email: _emailController.text.trim(), // 🔹 تمرير الإيميل الحالي
                                ),
                              ),
                            );
                          },
                          child: Text('Forgot password?',
                              style: TextStyle(
                                  color: buttonTextColor, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // ✅ SIGN IN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonTextColor,
                          foregroundColor: containerColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return; // ✅

                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          // --- Admin Login ---
                          if (email == 'admin' && password == 'admin') {
                            Navigator.pushReplacementNamed(
                                context, '/admin-dashboard');
                            return;
                          }

                          try {
                            final userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: email, password: password);
                            final user = userCredential.user!;

                            if (!user.emailVerified) {
                              await FirebaseAuth.instance.signOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please verify your email before logging in / يرجى تفعيل بريدك الإلكتروني أولاً'),
                                ),
                              );
                              return;
                            }

                            await clearLocalUserData();
                            await syncUserFromFirestore(user);

                            await _saveUserIfRemembered();
                            Navigator.pushReplacementNamed(
                                context, '/HomePage');
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${e.message ?? 'Login failed / فشل تسجيل الدخول'}')),
                            );
                          }
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: containerColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Admin Login ---
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const AdminLoginScreen()),
                          );
                        },
                        child: Text(
                          'Login as Admin',
                          style: TextStyle(
                            color: buttonTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // --- Sign Up Option ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                          TextStyle(color: buttonTextColor, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Logo top-right
            Positioned(
              top: 16,
              right: 16,
              child: Image.asset(
                'assets/logo.png',
                height: 70,
                width: 70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
