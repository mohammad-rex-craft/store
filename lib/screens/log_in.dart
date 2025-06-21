import 'dart:ui';
import 'package:flutter/material.dart';
import '../utility/hooks.dart';
import '../database/auth/log_in_out.dart';
import '../widget/common/input.dart';
import '../widget/common/btn.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogInOut _logInOut = LogInOut();
  bool isLoading = false;
  bool showPassword = false;
  String? errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      await _logInOut.signIn(
        context,
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'فشل تسجيل الدخول. تحقق من البيانات وحاول مرة أخرى.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color glassTextColor = Colors.black87;
    final Color glassHintColor = Colors.white;
    final Color glassIconColor = Colors.white;
    final Color glassBorderColor = const Color.fromARGB(66, 97, 72, 72);
    final Color glassErrorBg =
        Colors.red[50]?.withOpacity(0.35) ?? Colors.red.withOpacity(0.15);
    final Color glassErrorBorder =
        Colors.red[200]?.withOpacity(0.45) ?? Colors.red.withOpacity(0.25);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.white.withOpacity(0.08)),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: CircleAvatar(
                        radius: 48,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/logo.jpg',
                            fit: BoxFit.contain,
                            height: 70,
                            width: 70,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.lock,
                              size: 48,
                              color: Colors.blue[200],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      ' Welcome to StoreFlow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please log in to continue',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (errorMessage != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: glassErrorBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: glassErrorBorder,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.withOpacity(0.9),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Input(
                            controller: emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            borderRadius: 16,
                          ),
                          const SizedBox(height: 20),
                          Input(
                            controller: passwordController,
                            labelText: 'Password',
                            prefixIcon: Icons.lock_rounded,
                            obscureText: !showPassword,
                            suffixIcon: showPassword ? Icons.visibility : Icons.visibility_off,
                            onSuffixPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            backgroundColor: Colors.white.withOpacity(0.1),
                            borderRadius: 16,
                          ),
                          const SizedBox(height: 10),
                          Btn(
                            title: 'Log In',
                            btnType: BtnType.primary,
                            width: double.infinity,
                            height: 48,
                            isLoading: isLoading,
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1976D2),
                                Color(0xFF64B5F6),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            onTap: isLoading ? null : () => signIn(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'All rights reserved © 2025',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.13), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.13),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
