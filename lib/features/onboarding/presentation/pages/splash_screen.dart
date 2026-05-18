import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zinko_app/features/booking/presentation/pages/home_screen.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/common_util.dart';

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
    _requestPermissions();
    _initializeVideo();
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
  }

  Future<void> _initializeVideo() async {
    final prefs = sl<SharedPreferences>();
    final showStartupVideo = prefs.getBool('show_startup_video') ?? true;

    if (!showStartupVideo) {
      // Show logo for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        context.read<SplashBloc>().add(SetSplashVideoFinished(true));
        _navigateToNext();
      }
      return;
    }

    // Check if the controller was pre-initialized in ServiceLocator
    if (sl.isRegistered<VideoPlayerController>()) {
      _controller = sl<VideoPlayerController>();
      if (mounted && _controller != null) {
        try {
          if (_controller!.value.isInitialized &&
              _controller!.value.size.width > 0 &&
              _controller!.value.size.height > 0) {
            _controller!.setVolume(0.0);
            await _controller!.seekTo(Duration.zero);
            if (!mounted) return;
            _controller!.play();
            _controller!.setLooping(false);
            _controller!.addListener(_videoListener);
            context.read<SplashBloc>().add(SetSplashInitialized(true));
            return;
          }
        } catch (e) {
          debugPrint("SL Video controller check failed: $e");
        }
        // If SL controller is not ready or failed, unregister and try manual init
        if (sl.isRegistered<VideoPlayerController>()) {
          sl.unregister<VideoPlayerController>();
        }
        _controller = null;
      }
    }

    _controller = VideoPlayerController.asset('assets/images/zinko_video.mp4');

    final splashBloc = context.read<SplashBloc>();
    try {
      _controller!.setVolume(0.0);
      await _controller!.initialize().timeout(const Duration(seconds: 7));
      if (!mounted) return;

      if (_controller!.value.size.width > 0 && _controller!.value.size.height > 0) {
        await _controller!.seekTo(Duration.zero);
        if (!mounted) return;
        splashBloc.add(SetSplashInitialized(true));
        _controller!.play();
        _controller!.setLooping(false);
        _controller!.addListener(_videoListener);
      } else {
        throw Exception("Video has zero size");
      }
    } catch (e) {
      debugPrint("Video initialization failed or timed out: $e");
      if (mounted) {
        splashBloc.add(SetSplashInitialized(false));
        splashBloc.add(SetSplashVideoFinished(true));
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _navigateToNext();
        });
      }
    }
  }

  void _videoListener() {
    if (_controller == null || !mounted) return;

    final bool isEnd = _controller!.value.position.inMilliseconds >= (_controller!.value.duration.inMilliseconds - 100);

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
            if (state is AuthAuthenticated || state is AuthUnauthenticated || state is AuthFailure) {
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
                if (splashState.isInitialized && _controller != null && _controller!.value.isInitialized)
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
                if (!splashState.isInitialized || _controller == null || !_controller!.value.isInitialized)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer Glow - Breathing
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.2),
                                      AppColors.primary.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                    begin: const Offset(0.8, 0.8),
                                    end: const Offset(1.1, 1.1),
                                    duration: 2.seconds,
                                    curve: Curves.easeInOut,
                                  ),

                              // Logo Container with Shimmer
                          
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(20),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.4),
                                          blurRadius: 30,
                                          spreadRadius: 5),
                                    ],
                                  ),
                                  child: Image.asset(
                                      'assets/images/zinkoLogo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.flash_on_rounded, color: Colors.white, size: 60),
                                    ),
                                  )
                                    .animate(onPlay: (c) => c.repeat(reverse: true))
                                    .scale(
                                      begin: const Offset(0.95, 0.95),
                                      end: const Offset(1.05, 1.05),
                                      duration: 2.5.seconds,
                                      curve: Curves.easeInOut,
                                    )
                                    .animate(onPlay: (c) => c.repeat())
                                    .shimmer(
                                      delay: 500.ms,
                                      duration: 2.seconds,
                                      color: Colors.white24,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        CommonUtil.vGap32,
                        const Text(
                          'ZINKO',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 12,
                              shadows: [
                                Shadow(color: AppColors.primary, blurRadius: 20),
                              ]),
                        ).animate().fadeIn(delay: 600.ms).moveY(begin: 10, end: 0, duration: 600.ms),
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
