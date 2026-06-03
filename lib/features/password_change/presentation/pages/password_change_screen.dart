import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/features/password_change/presentation/bloc/password_change_bloc.dart';
import 'package:zinko_app/injection_container.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_success_overlay.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';

class PasswordChangeScreen extends StatefulWidget {
  static const String routeName = '/password-change';
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PasswordChangeBloc>(),
      child: BlocListener<PasswordChangeBloc, PasswordChangeState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            final navigator = Navigator.of(context);
            ZinkoSuccessOverlay.show(
              navigator.context,
              title: "SUCCESSFUL!",
              subtitle: state.successMessage!,
              onFinish: () => AppRouter.safetyPop(navigator.context),
            );
          } else if (state.error != null) { 
            ZinkoFlushbar.showError(
              context: context,
              message: state.error!,
            );
          }
        },
        child: BlocBuilder<PasswordChangeBloc, PasswordChangeState>(
          builder: (context, state) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              appBar: ZinkoAppBar(
                title: 'Forgot Password',
                onBackTap: () => AppRouter.safetyPop(context),
              ),
              body: ZinkoBackground(
                // backgroundColor: Colors.white.withValues(alpha: 0.05),
                image: AssetImage('assets/images/cafe_hotel_bg.png'),
                child: SafeArea(
                  child: ZinkoScrollBody(
                    // padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildStepIndicator(state.currentStep),
                        const SizedBox(height: 40),
                        _buildCurrentStepUI(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, "Email", currentStep),
        _buildStepLine(1, currentStep),
        _buildStepCircle(2, "OTP", currentStep),
        _buildStepLine(2, currentStep),
        _buildStepCircle(3, "Reset", currentStep),
      ],
    ).animate().fadeIn();
  }

  Widget _buildStepCircle(int step, String label, int currentStep) {
    bool isActive = currentStep >= step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? GlassTheme.textColor(context) : Colors.white24,
            border: Border.all(color: isActive ? Colors.transparent : Colors.white38),
          ),
          child: Center(
            child: isActive && currentStep > step
                ? const Icon(Icons.check, size: 16, color: Colors.black)
                : Text(
                    "$step",
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? GlassTheme.textColor(context) : Colors.white38,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int afterStep, int currentStep) {
    bool isActive = currentStep > afterStep;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      color: isActive ? GlassTheme.textColor(context) : Colors.white24,
    );
  }

  Widget _buildCurrentStepUI(BuildContext context, PasswordChangeState state) {
    switch (state.currentStep) {
      case 1:
        return _buildEmailStep(context, state);
      case 2:
        return _buildOtpStep(context, state);
      case 3:
        return _buildResetStep(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmailStep(BuildContext context, PasswordChangeState state) {
    return ZinkoCommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Email Address'),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your registered email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
            ],
          ),
          const SizedBox(height: 32),
          _PremiumButton(
            text: 'SEND OTP',
            onPressed: () {
              if (_emailController.text.isNotEmpty) {
                context.read<PasswordChangeBloc>().add(SendOtpEvent(_emailController.text.trim()));
              } else {
                ZinkoFlushbar.showError(context: context, message: "Please enter your email");
              }
            },
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep(BuildContext context, PasswordChangeState state) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter the 6-digit code sent to\n${state.email}",
            style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          _buildFieldLabel('Verification Code'),
          const SizedBox(height: 16),
          Center(
            child: Pinput(
              length: 6,
              controller: _otpController,
              keyboardType: TextInputType.number,
              defaultPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
              onCompleted: (pin) {
                context.read<PasswordChangeBloc>().add(VerifyOtpEvent(
                      email: state.email!,
                      otp: pin,
                    ));
              },
            ),
          ),
          const SizedBox(height: 32),
          _PremiumButton(
            text: 'VERIFY OTP',
            onPressed: () {
              if (_otpController.text.isNotEmpty) {
                context.read<PasswordChangeBloc>().add(VerifyOtpEvent(
                  email: state.email!,
                  otp: _otpController.text.trim(),
                ));
              } else {
                ZinkoFlushbar.showError(context: context, message: "Please enter the OTP");
              }
            },
            isLoading: state.isLoading,
          ),
          Center(
            child: TextButton(
              onPressed: () => context.read<PasswordChangeBloc>().add(SendOtpEvent(_emailController.text.trim())),
              child: Text(
                "Resend Code",
                style: TextStyle(color: GlassTheme.textColor(context), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetStep(BuildContext context, PasswordChangeState state) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('New Password'),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _passwordController,
            hint: 'Enter new password',
            icon: Icons.lock_outline_rounded,
            obscureText: state.obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(state.obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20),
              onPressed: () => context.read<PasswordChangeBloc>().add(TogglePasswordVisibilityEvent()),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
            ],
          ),
          const SizedBox(height: 20),
          _buildFieldLabel('Confirm Password'),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _confirmPasswordController,
            hint: 'Confirm your password',
            icon: Icons.lock_reset_rounded,
            obscureText: state.obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(state.obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20),
              onPressed: () => context.read<PasswordChangeBloc>().add(ToggleConfirmPasswordVisibilityEvent()),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
            ],
          ),
          const SizedBox(height: 32),
          _PremiumButton(
            text: 'RESET PASSWORD',
            onPressed: () {
              if (_passwordController.text.isEmpty) {
                ZinkoFlushbar.showError(context: context, message: "Please enter a new password");
              } else if (_passwordController.text != _confirmPasswordController.text) {
                ZinkoFlushbar.showError(context: context, message: "Passwords do not match");
              } else if (state.userCode != null) {
                context.read<PasswordChangeBloc>().add(ResetPasswordSubmittedEvent(
                  userCode: state.userCode!,
                  password: _passwordController.text,
                ));
              }
            },
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2),
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
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: child,
    ).animate().slideY(begin: 0.1, end: 0, duration: 400.ms).fadeIn();
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,  
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: 
      inputFormatters != null
      ? [...inputFormatters, FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))]
      :[
        FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
      ],
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.2),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const _PremiumButton({required this.text, required this.onPressed, this.isLoading = false});

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      ),
    );
  }
}
