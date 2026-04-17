import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/features/booking/presentation/pages/complate_cafe_list_screen.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

import '../../../booking/presentation/pages/bookings_screen.dart';
import '../../../booking/presentation/pages/wishlist_screen.dart';
import '../../../onboarding/presentation/pages/splash_screen.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'edit_profile_screen.dart';
import 'subscription_plans_screen.dart';
import '../../../wallet/presentation/pages/wallet_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../widgets/zinko_background.dart';
import '../../../../widgets/zinko_app_bar.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../domain/entities/user_entity.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final state = context.read<UserBloc>().state;
    if (state is UserInitial || state is UserError) {
      context.read<UserBloc>().add(GetUserProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZinkoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const ZinkoAppBar(
          title: 'Profile',
          showBackButton: false,
        ),
        body: SafeArea(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              final user = state is UserLoaded ? state.user : null;
              final isLoading = state is UserLoading;
              final isError = state is UserError;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(GetUserProfileEvent());
                },
                color: AppColors.primary,
                backgroundColor: GlassTheme.glassColor(context),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    _buildHeader(context, user, isLoading),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if (isError) ...[
                              const SizedBox(height: 12),
                              _buildErrorBanner(context, (state).message),
                            ],
                            const SizedBox(height: 12),
                            if (user != null) ...[
                              _buildCompletionCard(context, user),
                              const SizedBox(height: 12),
                            ],
                            _buildMembershipCard(context, user),
                            const SizedBox(height: 12),
                            _buildSectionTitle(context, 'MY ACCOUNT'),
                            const SizedBox(height: 10),
                            _buildAccountCard(context, user),
                            const SizedBox(height: 20),
                            _buildSectionTitle(context, 'RECENT ACTIVITY'),
                            const SizedBox(height: 10),
                            _buildMenuGrid(context),
                            const SizedBox(height: 20),
                            _buildSectionTitle(context, 'PREFERENCES & SETTINGS'),
                            const SizedBox(height: 10),
                            _buildGeneralList(context, user),
                            const SizedBox(height: 24),
                            _buildLogoutBtn(context),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<UserBloc>().add(GetUserProfileEvent()),
            child: const Text('RETRY',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user, bool isLoading) {
    return SliverAppBar(
      expandedHeight: 170,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      shadowColor: AppColors.transparent,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      stretch: true,
      centerTitle: true,
      leading: const SizedBox(),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'profile_pic',
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.brightBlue.withValues(alpha: 0.5), width: 3.5),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.brightBlue.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 1)
                  ],
                ),
                child: ClipOval(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: GlassTheme.textColor(context),
                              strokeWidth: 2))
                      : ZinkoNetworkImage(
                          imageUrl: user?.profileImage ?? '',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            )
                .animate()
                .scale(curve: Curves.elasticOut, duration: 1000.ms)
                .rotate(begin: -0.05, end: 0),
            const SizedBox(height: 12),
            Text(
              user?.name.toUpperCase() ?? (isLoading ? 'LOADING...' : 'ME'),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: GlassTheme.textColor(context),
                  letterSpacing: -0.5),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: GlassTheme.glassColor(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: GlassTheme.glassBorder(context)),
              ),
              child: Text(
                'EXPERT USER',
                style: TextStyle(
                    fontSize: 9,
                    color: GlassTheme.secondaryTextColor(context),
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
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: GlassTheme.tertiaryTextColor(context),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, dynamic user) {
    return ZinkoCommonCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildAccountTile(
              context, 'Email', user?.email ?? '--', Icons.email_outlined),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildAccountTile(context, 'Phone', user?.phone ?? '--',
              Icons.phone_android_rounded),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildAccountTile(
              context,
              'Bio',
              (user?.bio ?? '').isEmpty ? 'Not specified' : user!.bio,
              Icons.info_outline_rounded),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms);
  }

  Widget _buildAccountTile(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: GlassTheme.textColor(context).withValues(alpha: 0.08),
                shape: BoxShape.circle),
            child: Icon(icon,
                color: GlassTheme.secondaryTextColor(context), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: GlassTheme.tertiaryTextColor(context),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: GlassTheme.textColor(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, dynamic user) {
    return ZinkoCommonCard(
      onTap: () =>
          Navigator.pushNamed(context, SubscriptionPlansScreen.routeName),
      backgroundColor: AppColors.royalBlue,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.gold.withValues(alpha: 0.2),
                AppColors.gold.withValues(alpha: 0.05)
              ]),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
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
                  '${user?.membership.toUpperCase() ?? 'FREE'} MEMBER',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      user != null
                          ? 'Premium Benefits Active'
                          : 'Join our premium club',
                      style: TextStyle(
                          color: user != null
                              ? AppColors.success
                              : AppColors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 4),
                    if (user != null)
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
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      // padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.8,

      children: [
        _buildMenuCard(context, 'BOOKINGS', Icons.calendar_today_rounded,
            BookingsScreen.routeName),
        _buildMenuCard(context, 'WALLET', Icons.account_balance_wallet_rounded,
            WalletScreen.routeName),
        _buildMenuCard(context, 'WISHLIST', Icons.favorite_rounded,
            WishlistScreen.routeName),
        _buildMenuCard(context, 'COMPLETE', Icons.event_available_rounded,
            CompleteCafeListScreen.routeName),
      ],
    ).animate(delay: 550.ms).fadeIn();
  }

  Widget _buildMenuCard(
      BuildContext context, String title, IconData icon, String route) {
    return ZinkoCommonCard(
      onTap: () => Navigator.pushNamed(context, route),
      padding: EdgeInsets.zero,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.brightBlue, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralList(BuildContext context, dynamic user) {
    return ZinkoCommonCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildToggleTile(
              context,
              'Public Visibility',
              Icons.visibility_rounded,
              user?.userVisibility ?? false, (val) {
            context.read<UserBloc>().add(UpdateVisibilityEvent(val));
          }),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildListTile(context, 'Edit Profile', Icons.person_rounded,
              EditProfileScreen.routeName),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildListTile(context, 'Account Settings',
              Icons.settings_rounded, SettingsScreen.routeName),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildListTile(
              context, 'Security & Privacy', Icons.shield_rounded, ''),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildListTile(
              context, 'Help & Support', Icons.help_center_rounded, ''),
          Divider(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05)),
          _buildListTile(
              context, 'App Feedback', Icons.feedback_rounded, ''),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn();
  }

  Widget _buildToggleTile(BuildContext context, String title, IconData icon,
      bool value, Function(bool) onChanged) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: GlassTheme.textColor(context).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: GlassTheme.textColor(context), size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: GlassTheme.textColor(context)),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: GlassTheme.textColor(context),
        activeTrackColor: GlassTheme.textColor(context).withValues(alpha: 0.3),
      ),
    );
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
            color: GlassTheme.textColor(context).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10)),
        child:
            Icon(icon, color: GlassTheme.secondaryTextColor(context), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: GlassTheme.textColor(context)),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: GlassTheme.tertiaryTextColor(context).withValues(alpha: 0.3),
          size: 18),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: GlassTheme.glassColor(context),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(color: GlassTheme.glassBorder(context))),
          title: Text(
            'Confirm Logout',
            style: TextStyle(
                color: GlassTheme.textColor(context),
                fontWeight: FontWeight.w900,
                fontSize: 22),
          ),
          content: Text(
            'Are you sure you want to sign out from Zinko? All session data will be cleared.',
            style: TextStyle(
                color: GlassTheme.secondaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: TextStyle(
                    color: GlassTheme.tertiaryTextColor(context),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: -5)
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pushNamedAndRemoveUntil(
                      context, SplashScreen.routeName, (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'LOGOUT',
                  style:
                      TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.error.withValues(alpha: 0.25), width: 1.5),
      ),
      child: TextButton(
        onPressed: () => _showLogoutConfirmation(context),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          foregroundColor: AppColors.error,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 12),
            Text(
              'LOGOUT ACCOUNT',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    ).animate(delay: 700.ms).fadeIn();
  }

  Widget _buildCompletionCard(BuildContext context, UserEntity user) {
    final double percentage = user.completionPercentage;
    final bool isComplete = user.isProfileComplete;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GlassTheme.glassColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: GlassTheme.glassBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isComplete ? 'PROFILE VERIFIED' : 'COMPLETE PROFILE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isComplete ? AppColors.success : theme.primaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isComplete ? 'Your identity is fully secure' : 'Secure your account now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: GlassTheme.textColor(context).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isComplete ? AppColors.success : theme.primaryColor).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    color: isComplete ? AppColors.success : theme.primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: OptimizedColors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? AppColors.success : theme.primaryColor,
              ),
            ),
          ),
          if (!isComplete) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, EditProfileScreen.routeName),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'FINISH SETUP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

