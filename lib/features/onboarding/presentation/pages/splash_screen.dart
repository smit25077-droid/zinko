import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/booking/presentation/pages/home_screen.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/di/service_locator.dart';
import 'package:zinko_app/features/onboarding/presentation/bloc/splash_bloc.dart';
import 'package:zinko_app/features/onboarding/presentation/pages/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(),
      child: const _SplashContent(),
    );
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> {
  VideoPlayerController? _controller;
  bool _navigationHasStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Check if the controller was pre-initialized in ServiceLocator
    if (sl.isRegistered<VideoPlayerController>()) {
      _controller = sl<VideoPlayerController>();
      if (mounted && _controller != null) {
        context.read<SplashBloc>().add(SetSplashInitialized(true));
        _controller!.play();
        _controller!.setLooping(false);
        _controller!.addListener(_videoListener);
      }
      return;
    }

    final prefs = sl<SharedPreferences>();
    final showStartupVideo = prefs.getBool('show_startup_video') ?? true;

    if (!showStartupVideo) {
      context.read<SplashBloc>().add(SetSplashVideoFinished(true));
      _navigateToNext();
      return;
    }

    _controller = VideoPlayerController.asset('assets/images/zinko_video.mp4');
    final splashBloc = context.read<SplashBloc>();
    try {
      _controller!.setVolume(0.0);
      await _controller!.initialize().timeout(const Duration(seconds: 7));

      if (mounted) {
        if (_controller!.value.size.width > 0 &&
            _controller!.value.size.height > 0) {
          splashBloc.add(SetSplashInitialized(true));
          _controller!.play();
          _controller!.setLooping(false);
          _controller!.addListener(_videoListener);
        } else {
          throw Exception("Video has zero size");
        }
      }
    } catch (e) {
      debugPrint("Video initialization failed or timed out: $e");
      if (mounted) {
        splashBloc.add(SetSplashInitialized(false));
      }
      splashBloc.add(SetSplashVideoFinished(true));
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _navigateToNext();
      });
    }
  }

  void _videoListener() {
    if (_controller == null || !mounted) return;
    
    final bool isEnd = _controller!.value.position.inMilliseconds >= 
                      (_controller!.value.duration.inMilliseconds - 100);
                      
    if (isEnd && !context.read<SplashBloc>().state.videoFinished) {
      context.read<SplashBloc>().add(SetSplashVideoFinished(true));
      // Navigation is now handled by the MultiBlocListener
    }
  }

  void _navigateToNext() {
    if (!mounted) return;
    
    final splashState = context.read<SplashBloc>().state;
    if (_navigationHasStarted || !splashState.videoFinished) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthInitial || authState is AuthLoading) return;

    _navigationHasStarted = true;
    if (authState is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else if (authState is AuthUnauthenticated || authState is AuthFailure) {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    if (sl.isRegistered<VideoPlayerController>()) {
      sl.unregister<VideoPlayerController>();
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated ||
                state is AuthUnauthenticated ||
                state is AuthFailure) {
              _navigateToNext();
            }
          },
        ),
        BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state.videoFinished) {
              _navigateToNext();
            }
          },
        ),
      ],
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, splashState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.center,
              children: [
                if (splashState.isInitialized &&
                    _controller != null &&
                    _controller!.value.isInitialized)
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),

                // Fallback/Loading Logo shows while initializing or if video fails
                if (!splashState.isInitialized)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 40,
                                  spreadRadius: 10),
                            ],
                          ),
                          child: Image.asset('assets/images/zinkoLogo.png',
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.flash_on_rounded,
                                  color: Colors.white,
                                  size: 60)),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .shimmer(duration: 1500.ms, color: Colors.white24),
                        const SizedBox(height: 24),
                        const Text(
                          'ZINKO',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8),
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
