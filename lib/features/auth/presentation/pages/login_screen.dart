import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';
import 'package:zinko_app/features/password_change/presentation/pages/password_change_screen.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/features/auth/presentation/pages/register_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/home_screen.dart';
import 'package:zinko_app/features/auth/presentation/pages/login_form_bloc.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/di/service_locator.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';

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
  void initState() {
    super.initState();
    _clearLocalData();
  }

  Future<void> _clearLocalData() async {
    await sl<SharedPreferences>().clear();
  }

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
        child: ZinkoBackground(
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          // image: AssetImage('assets/images/cafe_hotel_bg.png'),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,

            // appBar: const ZinkoAppBar(
            //   title: 'Login',
            //   showBackButton: true,
            // ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ZinkoScrollBody(
                    padding: EdgeInsets.zero,
                    // physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: CommonUtil.pH24,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonUtil.vGap20,
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
                                  CommonUtil.vGap8,
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
                              CommonUtil.vGap48,
                              _buildGlassContainer(context),
                              CommonUtil.vGap32,
                              const _SignupFooter(),
                              CommonUtil.vGap20,
                            ],
                          ),
                        ),
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

  Widget _buildGlassContainer(BuildContext context) {
    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, formState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return ZinkoGlassBox(
              color: Colors.white.withValues(alpha: 0.2),
              padding: CommonUtil.pAll32,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('UserName Or Email'),
                    CommonUtil.vGap10,
                    _ModernTextField(
                      controller: _userNameController,
                      hint: 'Enter your user name Or Email',
                      icon: Icons.person_outline_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'User Name Or Email is required';
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
                    ),
                    CommonUtil.vGap20,
                    _buildFieldLabel('Password'),
                    CommonUtil.vGap10,
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                      ],
                    ),
                    CommonUtil.vGap12,
                    Row(
                      children: [
                        // SizedBox(
                        //   height: 24,
                        //   width: 24,
                        //   child: Checkbox(
                        //     value: formState.rememberMe,
                        //     onChanged: (v) => context.read<LoginFormBloc>().add(SetRememberMe(v ?? false)),
                        //     side: const BorderSide(color: Colors.white70),
                        //     activeColor: AppColors.primary,
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        // const Text(
                        //   'Remember me',
                        //   style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        // ),
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
                    CommonUtil.vGap28,
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
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
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
      inputFormatters: inputFormatters,
      scrollPadding: const EdgeInsets.only(bottom: 120),
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white60, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: CommonUtil.bRadius16,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: CommonUtil.bRadius16,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: CommonUtil.bRadius16,
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        contentPadding: CommonUtil.pH16V18,
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
          shape: RoundedRectangleBorder(borderRadius: CommonUtil.bRadius18),
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
          onTap: () => Navigator.pushNamedAndRemoveUntil(
            context,
            RegisterScreen.routeName,
            (route) => false,
          ),
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
