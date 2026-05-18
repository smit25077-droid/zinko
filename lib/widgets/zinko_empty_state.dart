import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

class ZinkoEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const ZinkoEmptyState({
    super.key,
    required this.title,
     this.message,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ZinkoCommonCard(
          borderRadius: 32,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image with floating animation and glowing background
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/empty_state.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                        begin: 0,
                        end: -15,
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Title - Bold and Letter Spaced
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 16),
              
              // Message - Muted and Readability focused
              message?.isNotEmpty == true ?
              Text(
                message ?? '',
                style: TextStyle(
                  color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.6),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0)
              : SizedBox(),
              if (onRetry != null) ...[
                const SizedBox(height: 48),
                // Premium Styled Retry Button
                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      retryLabel ?? 'RETRY NOW',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
