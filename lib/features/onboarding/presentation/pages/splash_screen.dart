import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onboarding_screen.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController controller = VideoPlayerController.asset('assets/images/zinko_video.mp4');
    final ValueNotifier<bool> isInitialized = ValueNotifier<bool>(false);

    controller.initialize().then((_) {
      isInitialized.value = true;
      controller.play();
      controller.setLooping(false);
      
      Future.delayed(controller.value.duration + const Duration(milliseconds: 500), () {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
        }
      });
    }).catchError((error) {
       // Proceed to home even if intro video fails
      debugPrint("Video initialization failed: $error");
       Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
           Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isInitialized,
            builder: (context, initialized, _) {
              if (!initialized) return const SizedBox.shrink();
              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              );
            },
          ),
          // Fallback/Loading Logo
          ValueListenableBuilder<bool>(
            valueListenable: isInitialized,
            builder: (context, initialized, _) {
              return Center(
                child: AnimatedOpacity(
                  opacity: initialized ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
                          ],
                        ),
                        child: Image.asset('assets/images/zinkoLogo.png', errorBuilder: (_, __, ___) => const Icon(Icons.flash_on_rounded, color: Colors.white, size: 60)),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms, color: Colors.white24),
                      const SizedBox(height: 24),
                      const Text(
                        'ZINKO',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 8),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
