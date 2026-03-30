import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../booking/presentation/pages/bookings_screen.dart';
import '../../../booking/presentation/pages/wishlist_screen.dart';
import '../../../onboarding/presentation/pages/splash_screen.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'edit_profile_screen.dart';
import 'subscription_plans_screen.dart';
import 'verification_screen.dart';
import 'wallet_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/optimized_colors.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              context.read<UserBloc>().add(GetUserProfileEvent());
            }
            if (state is UserLoading) {
              return Center(
                  child: CircularProgressIndicator(
                      color: GlassTheme.textColor(context)));
            }
            if (state is UserLoaded) {
              final user = state.user;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(context, user),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildMembershipCard(context, user),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'MY ACCOUNT'),
                          const SizedBox(height: 12),
                          _buildAccountCard(context, user),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'RECENT ACTIVITY'),
                          const SizedBox(height: 12),
                          _buildMenuGrid(context),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'PREFERENCES & SETTINGS'),
                          const SizedBox(height: 12),
                          _buildGeneralList(context),
                          const SizedBox(height: 32),
                          _buildLogoutBtn(context),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is UserError) {
              return Center(
                  child: Text(state.message,
                      style: TextStyle(color: GlassTheme.textColor(context))));
            }
            return Center(
                child: CircularProgressIndicator(
                    color: GlassTheme.textColor(context)));
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      shadowColor: AppColors.transparent,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      stretch: true,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        // collapseMode: CollapseMode.parallax,
        // centerTitle: true,
        // title: Text(
        //   'PROFILE',
        //   style: TextStyle(
        //     color: GlassTheme.textColor(context),
        //     fontWeight: FontWeight.w900,
        //     fontSize: 14,
        //     letterSpacing: 2.0,
        //   ),
        // ).animate().fadeIn(delay: 400.ms),
        background: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'profile_pic',
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: GlassTheme.glassBorder(context), width: 4),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.black.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 2)
                  ],
                  image: DecorationImage(
                      image: user.profileImage.startsWith('http')
                          ? NetworkImage(user.profileImage) as ImageProvider
                          : FileImage(File(
                              user.profileImage.replaceFirst('file://', ''))),
                      fit: BoxFit.cover),
                ),
              ),
            )
                .animate()
                .scale(curve: Curves.elasticOut, duration: 1000.ms)
                .rotate(begin: -0.05, end: 0),
            const SizedBox(height: 16),
            Text(
              user.name.toUpperCase(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: GlassTheme.textColor(context),
                  letterSpacing: -0.5),
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: GlassTheme.glassColor(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: GlassTheme.glassBorder(context)),
              ),
              child: const Text(
                'EXPERT USER',
                style: TextStyle(
                    fontSize: 9,
                    color: OptimizedColors.white50,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5),
              ),
            ).animate(delay: 350.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: OptimizedColors.white40,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, dynamic user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            children: [
              _buildAccountTile(
                  context, 'Email', user.email, Icons.email_outlined),
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.1)),
              _buildAccountTile(
                  context, 'Phone', user.phone, Icons.phone_android_rounded),
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.1)),
              _buildAccountTile(
                  context,
                  'Bio',
                  user.bio.isEmpty ? 'Not specified' : user.bio,
                  Icons.info_outline_rounded),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1);
  }

  Widget _buildAccountTile(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: OptimizedColors.white08, shape: BoxShape.circle),
            child: Icon(icon, color: OptimizedColors.white60, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: OptimizedColors.white40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, dynamic user) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, SubscriptionPlansScreen.routeName),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: GlassTheme.glassBorder(context), width: 1.5),
              boxShadow: [GlassTheme.glassShadow(context)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.gold.withOpacity(0.2),
                      AppColors.gold.withOpacity(0.05)
                    ]),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.stars_rounded,
                      color: AppColors.gold, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.membership.toUpperCase()} MEMBER',
                        style: TextStyle(
                            color: GlassTheme.textColor(context),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Premium Benefits Active',
                            style: TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.check_circle,
                              color: AppColors.success, size: 12),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.white, size: 14),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildMenuCard(context, 'BOOKINGS', Icons.calendar_today_rounded,
            BookingsScreen.routeName),
        _buildMenuCard(context, 'WALLET', Icons.account_balance_wallet_rounded,
            WalletScreen.routeName),
        _buildMenuCard(context, 'WISHLIST', Icons.favorite_rounded,
            WishlistScreen.routeName),
        _buildMenuCard(context, 'VERIFIED', Icons.verified_user_rounded,
            VerificationScreen.routeName),
      ],
    ).animate(delay: 550.ms).fadeIn();
  }

  Widget _buildMenuCard(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: GlassTheme.iconColor(context), size: 24),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: GlassTheme.textColor(context),
                      letterSpacing: 1.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralList(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            children: [
              _buildListTile(context, 'Edit Profile', Icons.person_rounded,
                  EditProfileScreen.routeName),
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.05)),
              _buildListTile(context, 'Account Settings',
                  Icons.settings_rounded, SettingsScreen.routeName),
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.05)),
              _buildListTile(
                  context, 'Security & Privacy', Icons.shield_rounded, ''),
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.05)),
              _buildListTile(
                  context, 'Help & Support', Icons.help_center_rounded, ''),
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.05)),
              _buildListTile(
                  context, 'App Feedback', Icons.feedback_rounded, ''),
            ],
          ),
        ),
      ),
    ).animate(delay: 600.ms).fadeIn();
  }

  Widget _buildListTile(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap:
          route.isNotEmpty ? () => Navigator.pushNamed(context, route) : null,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: OptimizedColors.white08,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: OptimizedColors.white70, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: OptimizedColors.white30, size: 18),
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppColors.error.withOpacity(0.25), width: 1.5),
          ),
          child: TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, SplashScreen.routeName, (route) => false),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              foregroundColor: AppColors.error,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'LOGOUT ACCOUNT',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: 700.ms).fadeIn();
  }
}
