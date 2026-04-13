import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/auth/presentation/pages/login_screen.dart';
import '../../../../utils/zinko_flushbar.dart';
import '../../../../widgets/zinko_success_overlay.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../data/models/auth_requests.dart';
import './register_form_bloc.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterFormBloc(),
      child: const _RegisterContent(),
    );
  }
}

class _RegisterContent extends StatefulWidget {
  const _RegisterContent();

  @override
  State<_RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<_RegisterContent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
          RegisterSubmitted(
            RegisterRequest(
              userName: _userNameController.text.trim(),
              password: _passwordController.text,
              mobileNo: _phoneController.text.trim(),
              emailId: _emailController.text.trim(),
              referencesReferralCode: _referralController.text.trim().isNotEmpty
                  ? _referralController.text.trim()
                  : null,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ZinkoSuccessOverlay.show(
            context,
            title: "WELCOME!",
            subtitle: "Your account has been created successfully.",
            onFinish: () {
              if (mounted && context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (route) => false,
                );
              }
            },
          );
        }
        if (state is AuthFailure) {
          ZinkoFlushbar.showError(
            context: context,
            message: state.message,
            title: "Registration Failed",
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('assets/images/cafe_hotel_bg.png'),
                      fit: BoxFit.cover,
                      opacity: 0.45,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Column(
                            children: [
                              const Text(
                                'Register with Zinko',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 8),
                              const Text(
                                'Begin your journey with the finest experiences.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                              ).animate(delay: 200.ms).fadeIn(),
                            ],
                          ),
                          const SizedBox(height: 40),
                          _buildGlassRegisterCard(context),
                          const SizedBox(height: 32),
                          const _LoginFooter(),
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

  Widget _buildGlassRegisterCard(BuildContext context) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, formState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 35,
                    spreadRadius: -8,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Full Name'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _userNameController,
                      hint: 'Enter your name',
                      icon: Icons.person_outline_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('Email'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _emailController,
                      hint: 'Enter your email',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Enter valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('Phone Number'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _phoneController,
                      hint: 'Enter mobile number',
                      icon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Phone number is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
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
                        onPressed: () => context.read<RegisterFormBloc>().add(TogglePasswordVisibility()),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        if (value.length < 6) return 'Mini 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('Confirm Password'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _confirmPasswordController,
                      hint: 'Repeat your password',
                      icon: Icons.lock_reset_rounded,
                      obscureText: formState.obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () => context.read<RegisterFormBloc>().add(ToggleConfirmPasswordVisibility()),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Confirm your password';
                        if (value != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('Referral Code (Optional)'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _referralController,
                      hint: 'Enter referral code',
                      icon: Icons.card_giftcard_rounded,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 28),
                    _PremiumButton(
                      text: 'Create Account',
                      onPressed: () => _handleRegister(context),
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
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
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

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
          child: const Text(
            'Sign In',
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
