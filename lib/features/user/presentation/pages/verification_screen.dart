import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import '../../../auth/presentation/pages/otp_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = '/verification';
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => AppRouter.safetyPop(context),
          ),
        ),
        title: Text(
          'VERIFICATION',
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ZinkoBackground(
        child: SafeArea(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              }
              if (state is UserError) {
                return Center(
                    child: Text(state.message,
                        style:
                            TextStyle(color: GlassTheme.textColor(context))));
              }
              if (state is UserLoaded) {
                final user = state.user;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'SECURE YOUR ACCOUNT',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: GlassTheme.secondaryTextColor(context)
                                .withValues(alpha: 0.5),
                            letterSpacing: 1.5),
                      ).animate().fadeIn(),
                      const SizedBox(height: 8),
                      Text(
                        'TRUST & SAFETY',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: GlassTheme.textColor(context),
                            letterSpacing: -1),
                      ).animate(delay: 100.ms).fadeIn(),
                      const SizedBox(height: 8),
                      Text(
                        'Verify your credentials to unlock all platform features and premium bookings.',
                        style: TextStyle(
                            fontSize: 13,
                            color: GlassTheme.secondaryTextColor(context)
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ).animate(delay: 200.ms).fadeIn(),
                      const SizedBox(height: 32),
                      _buildVerificationCard(
                        context,
                        icon: Icons.email_rounded,
                        title: 'EMAIL ADDRESS',
                        subtitle: user.email,
                        isVerified: user.isEmailVerified,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              type: 'Email',
                              target: user.email,
                              userCode: user.userCode.toString(),
                            ),
                          ),
                        ),
                      ).animate(delay: 400.ms).fadeIn(),
                      const SizedBox(height: 16),
                      _buildVerificationCard(
                        context,
                        icon: Icons.phone_android_rounded,
                        title: 'PHONE NUMBER',
                        subtitle: user.phone,
                        isVerified: user.isPhoneVerified,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              type: 'Phone',
                              target: user.phone,
                              userCode: user.userCode.toString(),
                            ),
                          ),
                        ),
                      ).animate(delay: 600.ms).fadeIn(),
                    ],
                  ),
                );
              }
              return Center(
                  child: Text('Data error',
                      style: TextStyle(color: GlassTheme.textColor(context))));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isVerified,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isVerified
                      ? Colors.green.withValues(alpha: 0.12)
                      : GlassTheme.textColor(context).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon,
                    color: isVerified
                        ? Colors.greenAccent
                        : GlassTheme.textColor(context).withValues(alpha: 0.5),
                    size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: GlassTheme.textColor(context),
                            letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11,
                            color: GlassTheme.secondaryTextColor(context)
                                .withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2)),
                  ],
                ),
              ),
              if (isVerified)
                const Row(
                  children: [
                    Icon(Icons.verified_rounded,
                        color: Colors.greenAccent, size: 16),
                    SizedBox(width: 6),
                    Text('SECURE',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1.0)),
                  ],
                )
              else
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('VERIFY',
                        style: TextStyle(
                            color: isDark ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.5)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassHeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}

