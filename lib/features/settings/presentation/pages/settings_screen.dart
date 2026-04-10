import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/user/presentation/bloc/user_bloc.dart';
import '../../../../features/user/presentation/bloc/user_state.dart';
import '../../../../features/user/presentation/bloc/user_event.dart';
import '../../../../features/auth/presentation/pages/otp_screen.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../onboarding/presentation/pages/splash_screen.dart';
import '../bloc/settings_bloc.dart';


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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: GlassTheme.textColor(context), size: 20),
              onPressed: () => AppRouter.safetyPop(context),
            ),
          ),
          title: Text(
            'SETTINGS',
            style: TextStyle(
              color: GlassTheme.textColor(context),
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
        ),
        body: ZinkoBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'PREFERENCES'),
                  const SizedBox(height: 12),
                  _buildGlassGroup(
                    context,
                    [
                      _buildSwitchTile(
                        context,
                        'Push Notifications',
                        'Updates on bookings & events',
                        settingsState.pushNotifications,
                        (v) => context
                            .read<SettingsBloc>()
                            .add(TogglePushNotifications(v)),
                      ),
                      _buildDivider(context),
                      _buildSwitchTile(
                        context,
                        'Startup Video',
                        'Intro animation on application launch',
                        settingsState.showStartupVideo,
                        (v) => context
                            .read<SettingsBloc>()
                            .add(ToggleStartupVideo(v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'ACCOUNT SECURITY'),
                  const SizedBox(height: 12),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      final email = state is UserLoaded
                          ? state.user.email
                          : 'Email not linked';
                      final isEmailVerified = state is UserLoaded
                          ? state.user.isEmailVerified
                          : false;
                      final phone = state is UserLoaded
                          ? state.user.phone
                          : 'Phone not linked';
                      final isPhoneVerified = state is UserLoaded
                          ? state.user.isPhoneVerified
                          : false;

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
                                context
                                    .read<UserBloc>()
                                    .add(SendEmailOtpEvent(email));
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
                                ? const Icon(Icons.check_circle_rounded,
                                    color: Colors.greenAccent, size: 20)
                                : null,
                          ),
                          _buildDivider(context),
                          _buildActionTile(
                            context,
                            Icons.phone_iphone_rounded,
                            'Mobile Verification',
                            isPhoneVerified
                                ? 'Securely linked: $phone'
                                : 'Verification coming soon ($phone)',
                            onTap: () {},
                            trailing: isPhoneVerified
                                ? const Icon(Icons.check_circle_rounded,
                                    color: Colors.greenAccent, size: 20)
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'GENERAL'),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 32),
                  _buildDangerousSection(context),
                  const SizedBox(height: 40),
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
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: GlassTheme.tertiaryTextColor(context),
        letterSpacing: 1.5,
      ),
    ).animate().fadeIn();
  }

  Widget _buildGlassGroup(BuildContext context, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: GlassTheme.glassBorder(context), width: 1.2),
          ),
          child: Column(children: children),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle,
      bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: GlassTheme.textColor(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: GlassTheme.secondaryTextColor(context),
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
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
              activeColor: GlassTheme.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, IconData icon, String title, String subtitle,
      {required VoidCallback onTap, Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: GlassTheme.textColor(context).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: GlassTheme.textColor(context), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: GlassTheme.secondaryTextColor(context),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios_rounded,
                    color:
                        GlassTheme.secondaryTextColor(context).withValues(alpha: 0.3),
                    size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
        height: 1,
        color: GlassTheme.glassBorder(context),
        indent: 16,
        endIndent: 16);
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
        const SizedBox(height: 16),
        Text(
          'Please note that account deletion is irreversible. You will lose all your booking history and wallet balance.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: GlassTheme.tertiaryTextColor(context),
              fontSize: 11,
              fontWeight: FontWeight.w500),
        ).animate(delay: 500.ms).fadeIn(),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: GlassTheme.glassColor(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Delete Account?',
            style: TextStyle(
                color: GlassTheme.textColor(context),
                fontWeight: FontWeight.w900),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(
                color: GlassTheme.secondaryTextColor(context),
                height: 1.5,
                fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'CANCEL',
                style: TextStyle(
                    color: GlassTheme.secondaryTextColor(context),
                    fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: () {
                final userState = context.read<UserBloc>().state;
                if (userState is UserLoaded) {
                  context
                      .read<UserBloc>()
                      .add(DeleteUserEvent(userState.user.userCode));
                }
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'DELETE',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

