import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_success_overlay.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/core/routes/app_router.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  static const String routeName = '/subscription-plans';
  const SubscriptionPlansScreen({super.key});

  void _onPlanSelected(BuildContext context, String planName) {
    context.read<UserBloc>().add(SetMembershipEvent(planName));
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
              child: Column(
                children: [
                  Text(
                    'CHOOSE YOUR JOURNEY',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: GlassTheme.secondaryTextColor(context)
                            .withValues(alpha: 0.4),
                        letterSpacing: 2.0),
                  ).animate().fadeIn(),
                  const SizedBox(height: 8),
                  Text(
                    'UNLOCK PREMIUM',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: GlassTheme.textColor(context),
                        letterSpacing: -1),
                  )
                      .animate(delay: 100.ms)
                      .fadeIn()
                      .scale(begin: const Offset(0.9, 0.9)),
                  const SizedBox(height: 32),
                  _SubscriptionCard(
                    title: 'PRO',
                    price: '£499',
                    period: '/ month',
                    description:
                        'Perfect for regular professionals needing a reliable hub.',
                    features: [
                      'Access to exclusive events',
                      '5% Discount on all bookings',
                      'Priority Support 24/7',
                      'Premium Badge Profile',
                    ],
                    accentColor: AppColors.pro,
                    onTap: () => _onPlanSelected(context, 'PRO'),
                  ).animate().fadeIn(duration: 800.ms),
                  const SizedBox(height: 24),
                  _SubscriptionCard(
                    title: 'ELITE',
                    price: '£4,999',
                    period: '/ year',
                    description:
                        'The ultimate Zinko experience for industry leaders.',
                    features: [
                      'All PRO Plan features',
                      '10% Discount on all bookings',
                      'Free 1-day pass every month',
                      'VIP Lounge Access',
                      'Personal Concierge',
                    ],
                    accentColor: AppColors.elite,
                    isElite: true,
                    onTap: () => _onPlanSelected(context, 'ELITE'),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 800.ms)
                      ,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ZinkoCommonCard(
      padding: const EdgeInsets.all(24),
      borderColor: isElite ? accentColor.withValues(alpha: 0.3) : null,
      gradientColors: [
        GlassTheme.glassColor(context).withValues(alpha: isElite ? 0.3 : 0.15),
        GlassTheme.glassColor(context).withValues(alpha: isElite ? 0.2 : 0.1),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1.5),
                ),
              ),
              if (isElite)
                const Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text('BEST VALUE',
                        style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w900,
                            fontSize: 10)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price,
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: GlassTheme.textColor(context))),
              const SizedBox(width: 4),
              Text(period,
                  style: TextStyle(
                      fontSize: 14,
                      color: GlassTheme.secondaryTextColor(context)
                          .withValues(alpha: 0.4),
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description,
              style: TextStyle(
                  fontSize: 13,
                  color: GlassTheme.secondaryTextColor(context)
                      .withValues(alpha: 0.6),
                  height: 1.4,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: accentColor.withValues(alpha: 0.7), size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(f,
                            style: TextStyle(
                                color: GlassTheme.textColor(context)
                                    .withValues(alpha: 0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w600))),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isElite
                    ? accentColor
                    : (isDark ? Colors.white : Colors.black),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: (isElite
                              ? accentColor
                              : (isDark ? Colors.white : Colors.black))
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6)),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'GET STARTED',
                style: TextStyle(
                    color: isElite
                        ? Colors.white
                        : (isDark ? Colors.black : Colors.white),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


