import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../password_change/presentation/pages/password_change_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../utils/zinko_flushbar.dart';
import './register_screen.dart';
import '../../../booking/presentation/pages/home_screen.dart';
import './login_form_bloc.dart';
import '../../data/models/auth_requests.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              deviceId: "MOBILE_DEVICE",
              deviceType: "MOBILE",
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ZinkoFlushbar.showSuccess(context: context, message: "Login Successful");
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        }
        if (state is AuthFailure) {
          ZinkoFlushbar.showError(context: context, message: state.message);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('assets/images/cafe_hotel_bg.png'),
                      fit: BoxFit.cover,
                      opacity: 0.5,
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
                              const Text(
                                'Welcome to Zinko',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10),
                                  ],
                                ),
                              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 8),
                              const Text(
                                'Login to continue your journey',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ).animate(delay: 200.ms).fadeIn(),
                            ],
                          ),
                          const SizedBox(height: 48),
                          _buildGlassContainer(context),
                          const SizedBox(height: 32),
                          const _SignupFooter(),
                          const SizedBox(height: 20),
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

  Widget _buildGlassContainer(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, formState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: -5,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.18),
                    Colors.white.withValues(alpha: 0.08),
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
                      obscureText: formState.obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () => context.read<LoginFormBloc>().add(TogglePasswordVisibility()),
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
                            value: formState.rememberMe,
                            onChanged: (v) => context.read<LoginFormBloc>().add(SetRememberMe(v ?? false)),
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
                          onPressed: () => Navigator.pushNamed(context, PasswordChangeScreen.routeName),
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
            );
          },
        );
      },
    ).animate(delay: 400.ms).fadeIn();
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
        fillColor: Colors.white.withValues(alpha: 0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white60, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
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
  const _SignupFooter();

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
