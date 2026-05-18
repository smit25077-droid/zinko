import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_success_overlay.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import 'package:zinko_app/widgets/zinko_common_bottom_sheet.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  static const String routeName = '/subscription-plans';

  const SubscriptionPlansScreen({super.key});

  // void _onPlanSelected(BuildContext context, String planName) {
  //   context.read<UserBloc>().add(SetMembershipEvent(planName));
  // }

  void _showComingSoon(BuildContext context) {
    ZinkoCommonBottomSheet.show(
      context: context,
      title: 'COMING SOON',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            'We are currently refining these premium experiences to ensure they meet the highest standards of luxury and convenience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: GlassTheme.secondaryTextColor(context),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'NOTIFY ME',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserMembershipUpdateSuccess) {
          _showSuccessDialog(context, state.plan);
        }
      },
      child: ZinkoBackground(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.transparent,
          appBar: const ZinkoAppBar(
            title: 'Membership',
          ),
          body: SafeArea(
            child: ZinkoScrollBody(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
              child: Column(
                children: [
                  Text(
                    'UNLOCK PREMIUM',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: GlassTheme.textColor(context),
                        letterSpacing: -1),
                  ).animate(delay: 100.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
                  const SizedBox(height: 8),
                  Text(
                    'CHOOSE YOUR JOURNEY',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
                        letterSpacing: 2.0),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),
                  _SubscriptionCard(
                    title: 'PRO',
                    price: '£499',
                    period: '/ month',
                    description: 'Perfect for regular professionals needing a reliable hub.',
                    features: [
                      'Access to exclusive events',
                      '5% Discount on all bookings',
                      'Priority Support 24/7',
                      'Premium Badge Profile',
                    ],
                    accentColor: AppColors.primary,
                    onTap: () => _showComingSoon(context),
                    // onTap: () => _onPlanSelected(context, 'PRO'),
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 24),
                  _SubscriptionCard(
                    title: 'ELITE',
                    price: '£4,999',
                    period: '/ year',
                    description: 'The ultimate Zinko experience for industry leaders.',
                    features: [
                      'All PRO Plan features',
                      '10% Discount on all bookings',
                      'Free 1-day pass every month',
                      'VIP Lounge Access',
                      'Personal Concierge',
                    ],
                    accentColor: AppColors.elite,
                    isElite: true,
                    onTap: () => _showComingSoon(context),
                    // onTap: () => _onPlanSelected(context, 'ELITE'),
                  ).animate(delay: 200.ms).fadeIn(duration: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String plan) {
    ZinkoSuccessOverlay.show(
      context,
      title: 'CONGRATULATIONS!',
      subtitle: 'YOU ARE NOW AN $plan MEMBER!\nThanks for joining Zinko.',
      onFinish: () {
        AppRouter.safetyPop(context);
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String description;
  final List<String> features;
  final Color accentColor;
  final bool isElite;
  final VoidCallback onTap;

  const _SubscriptionCard({
    required this.title,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    required this.accentColor,
    this.isElite = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: isElite
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: -5,
                  offset: const Offset(0, 15),
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ZinkoGlassBox(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              if (isElite)
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.2),
                          accentColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

              // Content Layer
              Padding(
                padding: CommonUtil.pAll16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        if (isElite)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.amber, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'BEST CHOICE',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Pricing
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: GlassTheme.textColor(context),
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            period,
                            style: TextStyle(
                              fontSize: 16,
                              color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.65),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.8),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),
                    // Divider
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: GlassTheme.textColor(context).withValues(alpha: 0.08),
                    ),
                    const SizedBox(height: 12),

                    // Features List
                    ...features.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_rounded, color: accentColor, size: 14),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: GlassTheme.textColor(context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),

                    // Action Button
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: 52,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: isElite
                              ? LinearGradient(
                                  colors: [accentColor, accentColor.withValues(alpha: 0.85)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isElite ? null : (Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isElite ? accentColor : (Colors.black)).withValues(alpha: 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'GET STARTED',
                          style: TextStyle(
                            color: isElite ? Colors.white : (Colors.black),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
