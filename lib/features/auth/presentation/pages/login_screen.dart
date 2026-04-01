import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../data/models/auth_requests.dart';
import './register_screen.dart';
import '../../../booking/presentation/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
          LoginSubmitted(
            LoginRequest(
              userName: _userNameController.text.trim(),
              password: _passwordController.text,
              deviceId: "MOBILE_DEVICE", // Could be dynamic
              deviceType: "MOBILE", // Could be dynamic
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/cafe_hotel_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Text(
                                'Welcome to Zinko',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Where every sip and stay feels like home.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 48),
                          _buildGlassLoginCard(context, isDark),
                          const SizedBox(height: 32),
                          _SignupFooter(isDark: isDark).animate(delay: 600.ms).fadeIn(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassLoginCard(BuildContext context, bool isDark) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('UserName'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _userNameController,
                      hint: 'Enter your user name',
                      icon: Icons.person_outline_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'User Name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Password'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _passwordController,
                      hint: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) => setState(() => _rememberMe = v ?? false),
                            side: const BorderSide(color: Colors.white70),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Remember me',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _PremiumButton(
                      text: 'Sign In',
                      onPressed: () => _handleLogin(context),
                      isLoading: state is AuthLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white60, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const _PremiumButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
              )
            : Text(
                text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
      ),
    ).animate(target: isLoading ? 0.9 : 1.0).scale(duration: 200.ms);
  }
}

class _SignupFooter extends StatelessWidget {
  final bool isDark;
  const _SignupFooter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
          child: const Text(
            'Join Zinko',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
