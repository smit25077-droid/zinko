import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:zinko_app/features/auth/presentation/pages/login_screen.dart';
import 'package:zinko_app/utils/common_util.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

    final List<_OnboardingPage> pages = [
      const _OnboardingPage(
        imageUrl: '',
        image: 'assets/images/on_board_one.png',
        title: 'Find Your\nPerfect Space',
        subtitle: 'Discover aesthetic workspaces, cafes, and studios tailored for your creativity.',
      ),
      const _OnboardingPage(
        imageUrl: '',
        image: 'assets/images/on_board_two.png',
        title: 'Connect &\nCollaborate',
        subtitle: 'Join a vibrant community of professionals. Network, share ideas, and grow together.',
      ),
      const _OnboardingPage(
        imageUrl: '',
        image: 'assets/images/on_board_three.png',
        title: 'Work Without\nBoundaries',
        subtitle: 'Flexible bookings, premium amenities, and a seamless experience. Just bring your laptop.',
      ),
    ];

    void goToLogin() => Navigator.pushReplacementNamed(context, LoginScreen.routeName);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: (index) => currentPage.value = index,
              itemCount: pages.length,
              itemBuilder: (context, index) => _PageBackground(page: pages[index]),
            ),
            const _DarkOverlay(),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: CommonUtil.pHor24Ver16,
                      child: GestureDetector(
                        onTap: goToLogin,
                        child: const Text('SKIP',
                            style: TextStyle(
                                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const Spacer(),
                  Padding(
                    padding: CommonUtil.pHor32,
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentPage,
                      builder: (context, index, _) {
                        return Column(
                          key: ValueKey(index),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: CommonUtil.pHor16Ver8,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: CommonUtil.bRadius30,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                              ),
                              child: const Text('ZINKO PREMIUM',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5)),
                            ).animate().fadeIn(duration: 600.ms),
                            CommonUtil.vGap20,
                            Text(pages[index].title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 44,
                                        fontWeight: FontWeight.w900,
                                        height: 1.0,
                                        letterSpacing: -1.5))
                                .animate(delay: 200.ms)
                                .fadeIn(duration: 600.ms),
                            CommonUtil.vGap16,
                            Text(pages[index].subtitle,
                                    style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                        letterSpacing: 0.1))
                                .animate(delay: 400.ms)
                                .fadeIn(duration: 600.ms),
                          ],
                        );
                      },
                    ),
                  ),
                  CommonUtil.vGap48,
                  Padding(
                    padding: CommonUtil.pHor32Ver40Bottom,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<int>(
                          valueListenable: currentPage,
                          builder: (context, index, _) {
                            return Row(
                              children: List.generate(pages.length, (i) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.fastOutSlowIn,
                                  margin: const EdgeInsets.only(right: 8),
                                  width: index == i ? 36 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: index == i ? Colors.white : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: currentPage,
                          builder: (context, index, _) {
                            final isLastPage = index == pages.length - 1;
                            return isLastPage
                                ? _GetStartedButton(onTap: goToLogin)
                                : _ArrowButton(onTap: () {
                                    pageController.nextPage(duration: 600.ms, curve: Curves.easeInOutCubic);
                                  });
                          },
                        ),
                      ],
                    ),
                  ).animate(delay: 600.ms).fadeIn(duration: 600.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String imageUrl;
  final String? image;
  final String title;
  final String subtitle;

  const _OnboardingPage({required this.imageUrl, required this.title, required this.subtitle, this.image});
}

class _PageBackground extends StatelessWidget {
  final _OnboardingPage page;

  const _PageBackground({required this.page});

  @override
  Widget build(BuildContext context) {
    return page.image != null
        ? Image.asset(page.image!, fit: BoxFit.cover)
        : ZinkoNetworkImage(
            imageUrl: page.imageUrl,
            fit: BoxFit.cover,
          );
  }
}

class _DarkOverlay extends StatelessWidget {
  const _DarkOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.7, 1.0],
          colors: [
            Colors.black.withValues(alpha: 0.2),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.5),
            Colors.black.withValues(alpha: 0.9),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ArrowButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 24),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1000.ms);
  }
}

class _GetStartedButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GetStartedButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: CommonUtil.pHor32Ver20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: CommonUtil.bRadius20,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: const Text('GET STARTED',
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      ),
    )
        .animate()
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 800.ms);
  }
}
