import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zinko_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/event_success_bloc.dart';
import 'package:zinko_app/features/booking/presentation/pages/bookings_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/home_screen.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';

class EventRegistrationSuccessScreen extends StatelessWidget {
  static const String routeName = '/registration-success';

  const EventRegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventSuccessBloc(),
      child: const _EventSuccessContent(),
    );
  }
}

class _EventSuccessContent extends StatefulWidget {
  const _EventSuccessContent();

  @override
  State<_EventSuccessContent> createState() => _EventSuccessContentState();
}

class _EventSuccessContentState extends State<_EventSuccessContent> {
  void _onConfirmCheckIn(BuildContext context, String bookingId) async {
    context.read<BookingBloc>().add(CompleteBookingEvent(bookingId));
    context.read<EventSuccessBloc>().add(SetSuccessTransition(true));

    await Future.delayed(const Duration(seconds: 3));
    if (mounted && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, BookingsScreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isCheckIn = args?['isCheckIn'] as bool? ?? false;
    final bookingId = args?['bookingId'] as String?;

    return BlocBuilder<EventSuccessBloc, EventSuccessState>(
      builder: (context, successState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ZinkoBackground(
            child: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _buildGlassCircleIcon(isCheckIn),
                        const SizedBox(height: 48),
                        Text(
                          isCheckIn
                              ? 'READY TO CHECK IN!'
                              : 'SUCCESSFULLY REGISTERED!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: GlassTheme.textColor(context),
                              letterSpacing: 1.0),
                        ).animate().fadeIn(),
                        const SizedBox(height: 16),
                        Text(
                          isCheckIn
                              ? 'Welcome to the event! Please confirm your check-in to proceed to the venue.'
                              : 'You have successfully secured your spot. Your ticket and instructions have been sent to your registered email.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: GlassTheme.secondaryTextColor(context)
                                  .withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500),
                        ).animate(delay: 200.ms).fadeIn(),
                        const Spacer(),
                        _buildGlassActionButton(context, isCheckIn, bookingId),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                if (successState.isSuccessTransition) _buildSuccessOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassCircleIcon(bool isCheckIn) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: GlassTheme.glassColor(context),
        shape: BoxShape.circle,
        border: Border.all(color: GlassTheme.glassBorder(context)),
        boxShadow: [GlassTheme.glassShadow(context)],
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isCheckIn
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.green.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
                color: (isCheckIn ? Colors.blue : Colors.green)
                    .withValues(alpha: 0.4)),
          ),
          child: Icon(
            isCheckIn ? Icons.qr_code_scanner_rounded : Icons.check_rounded,
            color: isCheckIn ? Colors.blueAccent : Colors.greenAccent,
            size: 40,
          ),
        ),
      ),
    ).animate().scale(duration: 800.ms, curve: Curves.elasticOut);
  }

  Widget _buildGlassActionButton(
      BuildContext context, bool isCheckIn, String? bookingId) {
    return GestureDetector(
      onTap: () {
        if (isCheckIn && bookingId != null) {
          _onConfirmCheckIn(context, bookingId);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
      },
      child: _GlassButton(
        label: isCheckIn ? 'CONFIRM CHECK-IN' : 'BACK TO HOME',
      ),
    ).animate(delay: 500.ms).fadeIn().scale();
  }

  Widget _buildSuccessOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.greenAccent, size: 80),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 32),
            const Text('CHECKED IN!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2)).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 8),
            const Text('Enjoy the event!',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _GlassButton extends StatelessWidget {
  final String label;
  const _GlassButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
                color: isDark ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0),
          ),
        ),
      ),
    );
  }
}
