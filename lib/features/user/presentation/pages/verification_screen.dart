import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/features/auth/presentation/pages/otp_screen.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = '/verification';
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZinkoAppBar(
        title: 'VERIFICATION',
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
    return ZinkoCommonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
    );
  }
}

