import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

class ZinkoSuccessOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onFinish;

  const ZinkoSuccessOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    this.onFinish,
  });

  @override
  State<ZinkoSuccessOverlay> createState() => _ZinkoSuccessOverlayState();

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onFinish,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ZinkoSuccessOverlay(
        title: title,
        subtitle: subtitle,
        onFinish: onFinish,
      ),
    );

    Future.delayed(duration, () {
      if (context.mounted) {
        Navigator.pop(context); // Close dialog
        if (onFinish != null) onFinish();
      }
    });
  }
}

class _ZinkoSuccessOverlayState extends State<ZinkoSuccessOverlay> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSuccessSound();
  }

  Future<void> _playSuccessSound() async {
    try {
      // Assuming a success sound exists in assets. 
      // If it doesn't, it will just fail silently or handle error.
      await _audioPlayer.play(AssetSource('audio/success_chime.mp3'));
    } catch (e) {
      debugPrint("Audio play failed: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background: Transitions from dark to Paytm blue
          Positioned.fill(
            child: Container().animate().custom(
                  duration: 600.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(
                      AppColors.backgroundDark.withValues(alpha: 0.95),
                      AppColors.primaryDark.withValues(alpha: 0.98),
                      value,
                    ),
                  ),
                ),
          ),

          // Particle Effects (Confetti)
          ...List.generate(20, (index) => _buildParticle(index)),

          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Paytm Style Tick Animation
                _buildPaytmTick(context),

                const SizedBox(height: 40),

                // Success Title
                Text(
                  widget.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 12),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPaytmTick(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: AppColors.primary,
          size: 90,
        )
            .animate()
            .scale(
              delay: 300.ms,
              duration: 500.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0, 0),
            )
            .shimmer(delay: 1.seconds, duration: 1.5.seconds),
      ),
    )
        .animate()
        .scale(
          duration: 600.ms,
          curve: Curves.easeOutBack,
          begin: const Offset(0, 0),
        )
        .then()
        .shake(duration: 400.ms, hz: 4);
  }

  Widget _buildParticle(int index) {
    // final random = (index * 7) % 360;
    // final angle = random * 3.1415 / 180;
    final speed = 100 + (index * 10) % 150;
    
    return Center(
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.white : AppColors.secondary,
          shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: index % 3 == 0 ? null : BorderRadius.circular(2),
        ),
      )
          .animate()
          .fadeOut(duration: 0.ms) // Start hidden
          .then(delay: 400.ms)
          .fadeIn(duration: 100.ms)
          .move(
            begin: Offset.zero,
            end: Offset(
              speed * 1.5 * (index % 2 == 0 ? 1 : -1) * (index % 5 / 5),
              -speed * 2.0 * (index % 3 / 3 + 0.5),
            ),
            duration: 1500.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeOut(delay: 800.ms, duration: 500.ms)
          .scale(begin: const Offset(1, 1), end: const Offset(0.2, 0.2)),
    );
  }
}
