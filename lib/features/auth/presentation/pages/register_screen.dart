import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/auth/presentation/pages/login_screen.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_success_overlay.dart';

import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/features/auth/presentation/pages/register_form_bloc.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';

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
              referencesReferralCode:
                  _referralController.text.trim().isNotEmpty ? _referralController.text.trim() : null,
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          // appBar: const ZinkoAppBar(
          //   title: 'Register',
          //   showBackButton: true,
          // ),
          body: ZinkoBackground(
            backgroundColor: OptimizedColors.white05,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ZinkoScrollBody(
                    padding: EdgeInsets.zero,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
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
                                  ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.1, end: 0),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Begin your journey with the finest experiences.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: OptimizedColors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                    ),
                                  ).animate(delay: 150.ms).fadeIn(duration: 250.ms),
                    
                              const SizedBox(height: 40),
                              _buildGlassRegisterCard(context),
                              const SizedBox(height: 32),
                              const _LoginFooter(),
                              const SizedBox(height: 40),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ])),
                      ),
                    ),
                  );
                },
              ),
            ),
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
            return ZinkoGlassBox(
              color: OptimizedColors.white20,
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Username'),
                    const SizedBox(height: 10),
                    _ModernTextField(
                      controller: _userNameController,
                      hint: 'Enter your username',
                      icon: Icons.person_outline_rounded,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@#&_.]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Username is required';
                        if (value.length < 3) return 'Username must be at least 3 characters';
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Phone number is required';
                        if (value.length < 10) return 'Enter valid 10-digit number';
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
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
    ).animate(delay: 250.ms).fadeIn(duration: 250.ms);
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
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
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.inputFormatters,
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
      inputFormatters: inputFormatters,
      scrollPadding: const EdgeInsets.only(bottom: 120),
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: OptimizedColors.white08,
        hintText: hint,
        hintStyle: const TextStyle(color: OptimizedColors.white30, fontSize: 14),
        prefixIcon:  Icon(icon, color: OptimizedColors.white60, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: OptimizedColors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: OptimizedColors.white10),
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
          style: TextStyle(color: OptimizedColors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
