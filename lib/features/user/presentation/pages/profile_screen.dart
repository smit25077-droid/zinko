import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/widgets/zinko_webview_screen.dart';

import 'package:zinko_app/utils/common_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/features/booking/presentation/pages/complate_cafe_list_screen.dart';
import 'package:zinko_app/features/user/domain/entities/user_entity.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

import 'package:zinko_app/features/booking/presentation/pages/bookings_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/wishlist_screen.dart';
import 'package:zinko_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/features/user/presentation/pages/edit_profile_screen.dart';
import 'package:zinko_app/features/user/presentation/pages/subscription_plans_screen.dart';
import 'package:zinko_app/features/wallet/presentation/pages/wallet_screen.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_profile_completion_dialog.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';

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
        // appBar: const ZinkoAppBar(
        //   title: 'Profile',
        //   showBackButton: false,
        //   leading: SizedBox.shrink(),
        // ),
        body: SafeArea(
          child: BlocBuilder<UserBloc, UserState>(
            buildWhen: (previous, current) => current is UserLoading || current is UserLoaded || current is UserError,
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
                child: ZinkoScrollBody(
                  // physics: const BouncingScrollPhysics(
                  //   parent: AlwaysScrollableScrollPhysics(),
                  // ),
                  padding: CommonUtil.pH20,
                  child: Column(
                    children: [
                      _buildHeader(context, user, isLoading),
                      if (isError) ...[
                        CommonUtil.vGap12,
                        _buildErrorBanner(context, (state).message),
                      ],
                      CommonUtil.vGap12,
                      // if (user != null) ...[
                      //   _buildCompletionCard(context, user),
                      //   CommonUtil.vGap12,
                      // ],
                      _buildMembershipCard(context, user),
                      CommonUtil.vGap12,
                      _buildSectionTitle(context, 'MY ACCOUNT'),
                      CommonUtil.vGap10,
                      _buildAccountCard(context, user),
                      CommonUtil.vGap20,
                      _buildSectionTitle(context, 'RECENT ACTIVITY'),
                      CommonUtil.vGap10,
                      _buildMenuGrid(context),
                      CommonUtil.vGap20,
                      _buildSectionTitle(context, 'PREFERENCES & SETTINGS'),
                      CommonUtil.vGap10,
                      _buildGeneralList(context, user),
                      CommonUtil.vGap24,
                      CommonUtil.vGap100,
                    ],
                  ),
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
      padding: CommonUtil.pAll16,
      decoration: BoxDecoration(
        color: OptimizedColors.error08,
        borderRadius: CommonUtil.bRadius20,
        border: Border.all(color: OptimizedColors.error25),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          CommonUtil.hGap12,
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => context.read<UserBloc>().add(GetUserProfileEvent()),
            child: const Text('RETRY', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user, bool isLoading) {
    final double percentage = user?.completionPercentage ?? 0.0;

    return Padding(
      padding: CommonUtil.pV30,
      child: Row(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Progress Ring Background (Inactive)
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: OptimizedColors.applyAlpha(AppColors.secondary, 0.1),
                        width: 4,
                      ),
                    ),
                  ),
                  // Animated Progress Ring
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: percentage),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return SizedBox(
                        width: 112,
                        height: 112,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 4,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            value >= 1.0 ? AppColors.success : AppColors.secondary,
                          ),
                        ),
                      );
                    },
                  ),
                  // Profile Image
                  Hero(
                    tag: 'profile_pic',
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: OptimizedColors.applyAlpha(
                                percentage >= 1.0 ? AppColors.success : AppColors.secondary, 0.2),
                            blurRadius: 20,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: GlassTheme.textColor(context),
                                  strokeWidth: 2,
                                ),
                              )
                            // : (user?.profileImage != null && user!.profileImage.isNotEmpty)
                            //     ? ZinkoNetworkImage(
                            //         imageUrl: user.profileImage,
                            //         width: 100,
                            //         height: 100,
                            //         fit: BoxFit.cover,
                            //       )
                                : Image.asset(
                                    user?.gender.toLowerCase() == 'female'
                                        ? 'assets/images/female_user.png'
                                        : 'assets/images/male_user.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),

                        // ZinkoNetworkImage(
                        //         imageUrl: user?.profileImage ?? '',
                        //         width: 100,
                        //         height: 100,
                        //         fit: BoxFit.cover,
                        //       ),
                      ),
                    ),
                  ).animate().scale(curve: Curves.easeOutBack, duration: 300.ms).slideX(begin: -0.2, end: 0),
                ],
              ),
              CommonUtil.vGap12,
              if (user != null)
                Container(
                  padding: CommonUtil.pHor8Ver4,
                  decoration: BoxDecoration(
                    color: OptimizedColors.applyAlpha(
                      user.isProfileComplete ? AppColors.success : AppColors.secondary,
                      0.5,
                    ),
                    borderRadius: CommonUtil.bRadius10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (user.isProfileComplete)
                        const Padding(
                          padding: CommonUtil.pRight4,
                          child: Icon(Icons.verified_rounded, size: 10, color: AppColors.success),
                        ),
                      Text(
                        user.isProfileComplete ? 'VERIFIED' : '${(user.completionPercentage * 100).toInt()}% COMPLETE',
                        style: TextStyle(
                          fontSize: 9,
                          color: user.isProfileComplete ? AppColors.success : GlassTheme.secondaryTextColor(context),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          CommonUtil.hGap24,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name.toUpperCase() ?? (isLoading ? 'LOADING...' : 'ME'),
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: GlassTheme.textColor(context),
                      letterSpacing: -0.5),
                ).animate(delay: 150.ms).fadeIn(duration: 250.ms).slideX(begin: 0.1, end: 0),
                CommonUtil.vGap4,
                Text(
                  user?.role ?? 'Zinko Professional',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: GlassTheme.secondaryTextColor(context)),
                ).animate(delay: 200.ms).fadeIn(duration: 250.ms),
                CommonUtil.vGap12,
                Row(
                  children: [
                    Container(
                      padding: CommonUtil.pHor12Ver4,
                      decoration: BoxDecoration(
                        color: GlassTheme.glassColor(context),
                        borderRadius: CommonUtil.bRadius10,
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: CommonUtil.pLeft4,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, dynamic user) {
    return Column(
      children: [
        ZinkoCommonCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildAccountTile(context, 'Email', user?.email ?? '--', Icons.email_outlined),
              Divider(height: 1, color: OptimizedColors.white05),
              _buildAccountTile(context, 'Phone', user?.phone ?? '--', Icons.phone_android_rounded),
              Divider(height: 1, color: OptimizedColors.white05),
              _buildAccountTile(context, 'Job Title', user?.role ?? 'Professional', Icons.work_outline_rounded),
              Divider(height: 1, color: OptimizedColors.white05),
              _buildAccountTile(context, 'Company', (user?.companyName ?? '').isEmpty ? '--' : user!.companyName,
                  Icons.business_center_outlined),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 250.ms),
        CommonUtil.vGap20,
        _buildSectionTitle(context, 'PERSONAL INFORMATION'),
        CommonUtil.vGap10,
        ZinkoCommonCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildAccountTile(
                  context, 'Gender', (user?.gender ?? '').isEmpty ? '--' : user!.gender, Icons.person_outline_rounded),
              Divider(height: 1, color: OptimizedColors.white05),
              _buildAccountTile(context, 'Birthday', (user?.birthdate ?? '').isEmpty ? '--' : user!.birthdate,
                  Icons.calendar_today_rounded),
              Divider(height: 1, color: OptimizedColors.white05),
              _buildAccountTile(
                  context,
                  'Address',
                  '${user?.city ?? ''} ${user?.state ?? ''}'.trim().isEmpty
                      ? '--'
                      : '${user?.city ?? ''}, ${user?.state ?? ''}',
                  Icons.location_on_outlined),
              Divider(height: 1, color: OptimizedColors.white05),
              _buildAccountTile(
                  context, 'Bio', (user?.bio ?? '').isEmpty ? 'Not specified' : user!.bio, Icons.info_outline_rounded),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 250.ms),
      ],
    );
  }

  Widget _buildAccountTile(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: CommonUtil.pH16V12,
      child: Row(
        children: [
          Container(
            padding: CommonUtil.pAll8,
            decoration: BoxDecoration(
                color: OptimizedColors.applyAlpha(GlassTheme.textColor(context), 0.08), shape: BoxShape.circle),
            child: Icon(icon, color: GlassTheme.secondaryTextColor(context), size: 18),
          ),
          CommonUtil.hGap16,
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
                CommonUtil.vGap4,
                Text(value,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlassTheme.textColor(context))),
              ],
            ),
          ),
        ],
      ),
    );
  } 
  
   Widget _buildMembershipCard(BuildContext context, UserEntity? user) {
    final bool isPro = user?.isPremium ?? false;
    final themeColor = isPro ? AppColors.gold : AppColors.secondary;
    
    return ZinkoCommonCard(
      onTap: () {
        if (user != null && !user.isProfileComplete) {
          ZinkoProfileCompletionDialog.show(context, user);
        } else {
          Navigator.pushNamed(context, SubscriptionPlansScreen.routeName);
        }
      },
      padding: CommonUtil.pAll20,
      child: Row(
        children: [
          Container(
            padding: CommonUtil.pAll12,
            decoration: BoxDecoration(
              color: OptimizedColors.applyAlpha(themeColor, 0.1),
              borderRadius: CommonUtil.bRadius16,
              border: Border.all(
                color: OptimizedColors.applyAlpha(themeColor, 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              isPro ? Icons.auto_awesome_rounded : Icons.star_rounded,
              color: themeColor,
              size: 28,
            ),
          ),
          CommonUtil.hGap20,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.membership.toUpperCase() ?? 'FREE'} MEMBER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: GlassTheme.textColor(context),
                    letterSpacing: -0.5,
                  ),
                ),
                CommonUtil.vGap4,
                Text(
                  isPro ? 'All premium benefits active' : 'View membership plans',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: GlassTheme.secondaryTextColor(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: OptimizedColors.white30,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      // padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: CommonUtil.s10,
      crossAxisSpacing: CommonUtil.s10,
      childAspectRatio: 1.8,

      children: [
        _buildMenuCard(context, 'BOOKINGS', Icons.calendar_today_rounded, BookingsScreen.routeName),
        _buildMenuCard(context, 'WALLET', Icons.account_balance_wallet_rounded, WalletScreen.routeName),
        _buildMenuCard(context, 'WISHLIST', Icons.favorite_rounded, WishlistScreen.routeName),
        _buildMenuCard(context, 'COMPLETE', Icons.event_available_rounded, CompleteCafeListScreen.routeName),
      ],
    ).animate(delay: 400.ms).fadeIn(duration: 250.ms);
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String route) {
    return ZinkoCommonCard(
      onTap: () => Navigator.pushNamed(context, route),
      padding: EdgeInsets.zero,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondary, size: 24),
            CommonUtil.vGap8,
            Text(
              title,
              style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: 1.0),
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
          _buildListTile(context, 'Edit Profile', Icons.person_rounded, EditProfileScreen.routeName),
          Divider(height: 1, color: OptimizedColors.white05),
          _buildListTile(context, 'Account Settings', Icons.settings_rounded, SettingsScreen.routeName),
          Divider(height: 1, color: OptimizedColors.white05),
          _buildListTile(context, 'Security & Privacy', Icons.shield_rounded, 'http://www.zinko.io/site/privacy-policy'),
          Divider(height: 1, color: OptimizedColors.white05),

          // _buildListTile(context, 'Help & Support', Icons.help_center_rounded, ''),
          // Divider(height: 1, color: AppColors.white.withValues(alpha: 0.05)),
          // _buildListTile(context, 'App Feedback', Icons.feedback_rounded, ''),
        ],
      ),
    ).animate(delay: 450.ms).fadeIn(duration: 250.ms);
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      dense: true,
      contentPadding: CommonUtil.pH20V4,
      onTap: route.isNotEmpty
          ? () async {
              if (route.startsWith('http')) {
                Navigator.pushNamed(
                  context,
                  ZinkoWebViewScreen.routeName,
                  arguments: {
                    'title': title,
                    'url': route,
                  },
                );
              } else {
                Navigator.pushNamed(context, route);
              }
            }
          : null,


      leading: Container(
        padding: CommonUtil.pAll8,
        decoration: BoxDecoration(
            color: OptimizedColors.white08, borderRadius: CommonUtil.bRadius10),
        child: Icon(icon, color: OptimizedColors.white70, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlassTheme.textColor(context)),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: OptimizedColors.applyAlpha(GlassTheme.tertiaryTextColor(context), 0.3), size: 18),
    );
  }
}
