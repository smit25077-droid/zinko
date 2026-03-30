import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _GlassAppBarButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            'MEMBERSHIP',
            style: TextStyle(
              color: GlassTheme.textColor(context),
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
        ),
        body: ZinkoBackground(
          child: SafeArea(
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
                              .withOpacity(0.4),
                          letterSpacing: 2.0),
                    ).animate().fadeIn().slideX(begin: -0.1),
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
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
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
                        .slideY(begin: 0.1),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessOverlay(plan: plan),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }
}

class _SuccessOverlay extends StatelessWidget {
  final String plan;
  const _SuccessOverlay({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.85),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ...List.generate(
                    15,
                    (i) => Transform.translate(
                      offset: Offset((i % 2 == 0 ? 1 : -1) * (30 + i * 10),
                          (i % 3 == 0 ? 1 : -1) * (40 + i * 5)),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              i % 2 == 0 ? AppColors.gold : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(onPlay: (ctrl) => ctrl.repeat())
                          .moveY(
                              begin: 0,
                              end: -100,
                              duration: 1500.ms,
                              curve: Curves.easeOutCubic)
                          .fadeOut(),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Icon(Icons.workspace_premium_rounded,
                          color: AppColors.gold, size: 80),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'CONGRATULATIONS!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2),
              ).animate().fadeIn().slideY(begin: 0.3),
              const SizedBox(height: 12),
              Text(
                'YOU ARE NOW AN $plan MEMBER!',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1),
              ).animate(delay: 200.ms).fadeIn(),
              const SizedBox(height: 32),
              Text(
                'Thanks for join with Zinko',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 1000.ms)
                  .slideY(begin: 0.2),
            ],
          ),
        ),
      ).animate().fadeIn(),
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

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: GlassTheme.glassColor(context)
                    .withOpacity(isElite ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: isElite
                        ? accentColor.withOpacity(0.3)
                        : GlassTheme.glassBorder(context)),
                boxShadow: [
                  if (isElite)
                    BoxShadow(
                        color: accentColor.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: -10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: accentColor.withOpacity(0.4)),
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
                            Icon(Icons.star_rounded,
                                color: Colors.amber, size: 16),
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
                                  .withOpacity(0.4),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(description,
                      style: TextStyle(
                          fontSize: 13,
                          color: GlassTheme.secondaryTextColor(context)
                              .withOpacity(0.6),
                          height: 1.4,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: accentColor.withOpacity(0.7), size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(f,
                                    style: TextStyle(
                                        color: GlassTheme.textColor(context)
                                            .withOpacity(0.8),
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
                                  .withOpacity(0.3),
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
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassAppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassAppBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}
