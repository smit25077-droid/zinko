import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../utils/theme_provider.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: GlassTheme.textColor(context), size: 20),
          onPressed: () => Navigator.pop(context),
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
                  // _buildSectionTitle(context, 'DISPLAY'),
                  // const SizedBox(height: 16),
                  // _buildGlassTile(
                  //   context,
                  //   'Dark Mode',
                  //   'Elegant dark theme visual experience',
                  //   trailing: Switch.adaptive(
                  //     value: themeProvider.isDarkMode,
                  //     onChanged: (val) => themeProvider.toggleTheme(),
                  //     activeTrackColor: GlassTheme.textColor(context).withOpacity(0.3),
                  //     activeColor: GlassTheme.textColor(context),
                  //   ),
                  // ),
                  // const SizedBox(height: 32),
                  _buildSectionTitle(context, 'PREFERENCES'),
                  const SizedBox(height: 16),
                  _buildGlassGroup(
                    context,
                    [
                      _buildSwitchTile(
                        context,
                        'Push Notifications',
                        'Updates on bookings & events',
                        true,
                        (val) {},
                      ),
                      _buildDivider(context),
                      _buildSwitchTile(
                        context,
                        'Startup Sound',
                        'Play jingle on application launch',
                        true,
                        (val) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'GENERAL'),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 48),
                  _buildDangerousSection(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
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
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildGlassTile(BuildContext context, String title, String subtitle, {Widget? trailing}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context), width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: GlassTheme.textColor(context), fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: GlassTheme.secondaryTextColor(context), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    ).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildGlassGroup(BuildContext context, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: GlassTheme.glassBorder(context), width: 1.2),
          ),
          child: Column(children: children),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: GlassTheme.textColor(context), fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: GlassTheme.secondaryTextColor(context), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: GlassTheme.textColor(context).withOpacity(0.3),
            activeColor: GlassTheme.textColor(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GlassTheme.textColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: GlassTheme.textColor(context), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: GlassTheme.textColor(context), fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: GlassTheme.secondaryTextColor(context), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, color: GlassTheme.glassBorder(context), indent: 20, endIndent: 20);
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
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Please note that account deletion is irreversible. You will lose all your booking history and wallet balance.',
          textAlign: TextAlign.center,
          style: TextStyle(color: GlassTheme.tertiaryTextColor(context), fontSize: 11, fontWeight: FontWeight.w500),
        ).animate(delay: 500.ms).fadeIn(),
      ],
    );
  }
}
