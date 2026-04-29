import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/auth/presentation/pages/otp_screen.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:zinko_app/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:zinko_app/features/settings/presentation/pages/reset_password_screen.dart';
import 'package:zinko_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/widgets/zinko_common_dialog.dart';
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/di/service_locator.dart';
import 'package:zinko_app/features/auth/presentation/pages/login_screen.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';


class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(LoadSettings()),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserDeleted) {
          context.read<AuthBloc>().add(LogoutRequested());
          Navigator.pushNamedAndRemoveUntil(
            context,
            SplashScreen.routeName,
            (route) => false,
          );
        } else if (state is UserError) {
          ZinkoFlushbar.showError(context: context, message: state.message);
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: ZinkoAppBar(title: 'SETTINGS'),
              body: ZinkoBackground(
                  child: SafeArea(
                child: ZinkoScrollBody(
                  // physics: const BouncingScrollPhysics(),
                  // padding: CommonUtil.pAll24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'PREFERENCES'),
                      CommonUtil.vGap12,
                      _buildGlassGroup(
                        context,
                        [
                          _buildSwitchTile(
                            context,
                            'Push Notifications',
                            'Updates on bookings & events',
                            settingsState.pushNotifications,
                            (v) => context.read<SettingsBloc>().add(TogglePushNotifications(v)),
                          ),
                          _buildDivider(context),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, userState) {
                              final userVisibility = userState is UserLoaded ? userState.user.userVisibility : false;
                              return _buildSwitchTile(
                                context,
                                'Public Visibility',
                                'Make your profile visible to others',
                                userVisibility,
                                (v) => context.read<UserBloc>().add(UpdateVisibilityEvent(v)),
                              );
                            },
                          ),
                          _buildDivider(context),
                          _buildSwitchTile(
                            context,
                            'Startup Video',
                            'Intro animation on application launch',
                            settingsState.showStartupVideo,
                            (v) => context.read<SettingsBloc>().add(ToggleStartupVideo(v)),
                          ),

                        ],
                      ),
                      CommonUtil.vGap24,
                      _buildSectionTitle(context, 'ACCOUNT SECURITY'),
                      CommonUtil.vGap12,
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          final email = state is UserLoaded ? state.user.email : 'Email not linked';
                          final isEmailVerified = state is UserLoaded ? state.user.isEmailVerified : false;
                          final phone = state is UserLoaded ? state.user.phone : 'Phone not linked';
                          final isPhoneVerified = state is UserLoaded ? state.user.isPhoneVerified : false;

                          return _buildGlassGroup(
                            context,
                            [
                              _buildActionTile(
                                context,
                                Icons.verified_user_rounded,
                                'Email Verification',
                                isEmailVerified ? 'Secure and verified' : email,
                                onTap: () {
                                  if (!isEmailVerified && state is UserLoaded) {
                                    final user = state.user;
                                    context.read<UserBloc>().add(SendEmailOtpEvent(email));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                          type: 'Email',
                                          target: email,
                                          userCode: user.userCode.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                trailing: isEmailVerified
                                    ? const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 20)
                                    : null,
                              ),
                              _buildDivider(context),
                              _buildActionTile(
                                context,
                                Icons.phone_iphone_rounded,
                                'Mobile Verification',
                                isPhoneVerified ? 'Securely linked: $phone' : 'Verification coming soon ($phone)',
                                onTap: () {},
                                trailing: isPhoneVerified
                                    ? const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 20)
                                    : null,
                              ),
                              _buildDivider(context),
                              _buildActionTile(
                                context,
                                Icons.lock_reset_rounded,
                                'Reset Password',
                                'Change your account password',
                                onTap: () => Navigator.pushNamed(context, ResetPasswordScreen.routeName),
                              ),
                            ],
                          );
                        },
                      ),
                      CommonUtil.vGap24,
                      _buildSectionTitle(context, 'GENERAL'),
                      CommonUtil.vGap12,
                      _buildGlassGroup(
                        context,
                        [
                          _buildActionTile(
                            context,
                            Icons.language_rounded,
                            'App Language',
                            'English (UK)',
                            onTap: () {},
                          ),
                          _buildDivider(context),
                          _buildActionTile(
                            context,
                            Icons.info_outline_rounded,
                            'About Zinko',
                            'Version 2.4.0 (Build 558)',
                            onTap: () {},
                          ),
                        ],
                      ),
                      CommonUtil.vGap32,
                      _buildDangerousSection(context),
                      CommonUtil.vGap24,
                      _buildLogoutBtn(context),
                      CommonUtil.vGap40,
                    ],
                  ),
                ),
              )));
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        letterSpacing: 1.5,
      ),
    ).animate().fadeIn();
  }

  Widget _buildGlassGroup(BuildContext context, List<Widget> children) {
    return ClipRRect(
      borderRadius: CommonUtil.bRadius24,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: CommonUtil.bRadius24,
            border: Border.all(color: GlassTheme.glassBorder(context), width: 1.2),
          ),
          child: Column(children: children),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: CommonUtil.pH16V12,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: GlassTheme.textColor(context), fontSize: 15, fontWeight: FontWeight.w700),
                ),
                CommonUtil.vGap2,
                Text(
                  subtitle,
                  style: TextStyle(
                      color: GlassTheme.secondaryTextColor(context), fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: GlassTheme.textColor(context).withValues(alpha: 0.3),
              activeThumbColor: GlassTheme.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String title, String subtitle,
      {required VoidCallback onTap, Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: CommonUtil.pHor16V12,
        child: Row(
          children: [
            Container(
              padding: CommonUtil.pAll8,
              decoration: BoxDecoration(
                color: GlassTheme.textColor(context).withValues(alpha: 0.08),
                borderRadius: CommonUtil.bRadius10,
              ),
              child: Icon(icon, color: GlassTheme.textColor(context), size: 18),
            ),
            CommonUtil.hGap14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: GlassTheme.textColor(context), fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  CommonUtil.vGap1,
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: GlassTheme.secondaryTextColor(context), fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios_rounded,
                    color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.3), size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, color: GlassTheme.glassBorder(context), indent: 16, endIndent: 16);
  }

  Widget _buildDangerousSection(BuildContext context) {
    return Column(
      children: [
        _buildGlassGroup(
          context,
          [
            _buildActionTile(
              context,
              Icons.delete_forever_rounded,
              'Delete Account',
              'Permanently remove all your Zinko data',
              onTap: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
        CommonUtil.vGap16,
        Text(
          'Please note that account deletion is irreversible. You will lose all your booking history and wallet balance.',
          textAlign: TextAlign.center,
          style: TextStyle(color: GlassTheme.tertiaryTextColor(context), fontSize: 11, fontWeight: FontWeight.w500),
        ).animate(delay: 500.ms).fadeIn(),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ZinkoCommonDialog.show(
      context: context,
      title: 'DELETE ACCOUNT?',
      message:
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
      icon: Icons.delete_forever_rounded,
      iconColor: AppColors.error,
      actionLabel: 'DELETE',
      actionColor: AppColors.error,
      onAction: () {
        final userState = context.read<UserBloc>().state;
        if (userState is UserLoaded) {
          context.read<UserBloc>().add(DeleteUserEvent(userState.user.userCode));
        }
        Navigator.pop(context);
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    ZinkoCommonDialog.show(
      context: context,
      title: 'CONFIRM LOGOUT',
      message: 'Are you sure you want to sign out from Zinko? All session data will be cleared.',
      icon: Icons.logout_rounded,
      iconColor: AppColors.error,
      actionLabel: 'LOGOUT',
      actionColor: AppColors.error,
      onAction: () async {
        // 1. Clear SharedPreferences
        await sl<SharedPreferences>().clear();

        // 2. Reset All relevant global Blocs
        if (context.mounted) {
          context.read<UserBloc>().add(ResetUserEvent());
          context.read<AuthBloc>().add(LogoutRequested());

          // 3. Navigate to Login
          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
        }
      },
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: OptimizedColors.red90,
        borderRadius: CommonUtil.bRadius18,
        border: Border.all(color: OptimizedColors.error25, width: 1.5),
      ),
      child: TextButton(
        onPressed: () => _showLogoutConfirmation(context),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: CommonUtil.bRadius18),
          foregroundColor: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 20),
            CommonUtil.hGap12,
            const Text(
              'LOGOUT ACCOUNT',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 250.ms);
  }
}
