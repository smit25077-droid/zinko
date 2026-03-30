import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../utils/theme_provider.dart';

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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/cafe_hotel_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('DISPLAY'),
                  const SizedBox(height: 16),
                  _buildGlassTile(
                    'Dark Mode',
                    'Elegant dark theme visual experience',
                    trailing: Switch.adaptive(
                      value: themeProvider.isDarkMode,
                      onChanged: (val) => themeProvider.toggleTheme(),
                      activeTrackColor: Colors.white,
                      activeColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('PREFERENCES'),
                  const SizedBox(height: 16),
                  _buildGlassGroup([
                    _buildSwitchTile(
                      'Push Notifications',
                      'Updates on bookings & events',
                      true,
                      (val) {},
                    ),
                    _buildDivider(),
                    _buildSwitchTile(
                      'Startup Sound',
                      'Play jingle on application launch',
                      true,
                      (val) {},
                    ),
                  ]),
                  const SizedBox(height: 32),
                  _buildSectionTitle('GENERAL'),
                  const SizedBox(height: 16),
                  _buildGlassGroup([
                    _buildActionTile(
                      Icons.language_rounded,
                      'App Language',
                      'English (UK)',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildActionTile(
                      Icons.info_outline_rounded,
                      'About Zinko',
                      'Version 2.4.0 (Build 558)',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 48),
                  _buildDangerousSection(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.white60,
        letterSpacing: 1.5,
      ),
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildGlassTile(String title, String subtitle, {Widget? trailing}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.w500),
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

  Widget _buildGlassGroup(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
          ),
          child: Column(children: children),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
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
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.white.withOpacity(0.3),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.2), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.white.withOpacity(0.1), indent: 20, endIndent: 20);
  }

  Widget _buildDangerousSection(BuildContext context) {
    return Column(
      children: [
        _buildGlassGroup([
          _buildActionTile(
            Icons.delete_forever_rounded,
            'Delete Account',
            'Permanently remove all your Zinko data',
            onTap: () {},
          ),
        ]),
        const SizedBox(height: 20),
        const Text(
          'Please note that account deletion is irreversible. You will lose all your booking history and wallet balance.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.w500),
        ).animate(delay: 500.ms).fadeIn(),
      ],
    );
  }
}
