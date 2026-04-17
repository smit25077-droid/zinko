import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'cafe_menu_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';
import '../../../../widgets/zinko_success_overlay.dart';

class OTPCheckInScreen extends StatefulWidget {
  static const String routeName = '/otp-check-in';

  const OTPCheckInScreen({super.key});

  @override
  State<OTPCheckInScreen> createState() => _OTPCheckInScreenState();
}

class _OTPCheckInScreenState extends State<OTPCheckInScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    final bookingId = args?[0] as String?;
    final bookingCode = args?[1] as String?;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: GlassTheme.textColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ZinkoBackground(
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingOperationSuccess) {
              ZinkoSuccessOverlay.show(
                context,
                title: 'CHECKED IN!',
                subtitle: state.message,
                onFinish: () {
                  Navigator.pushReplacementNamed(
                    context,
                    CafeMenuScreen.routeName,
                    arguments: {'bookingId': bookingId, 'bookingCode': bookingCode, 'isCheckIn': true},
                  );
                },
              );
            } else if (state is CheckInError) {
              Flushbar(
                title: "Check-In Failed",
                message: state.message,
                duration: const Duration(seconds: 4),
                flushbarPosition: FlushbarPosition.TOP,
                backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
                icon: const Icon(Icons.error_outline, color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                margin: const EdgeInsets.all(12),
              ).show(context);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.lock_person_rounded,
                      size: 80,
                      color: GlassTheme.textColor(context).withValues(alpha: 0.8),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 24),
                    Text(
                      'Verification Required',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: GlassTheme.textColor(context),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ask the cafe owner for the 6-digit OTP\nto confirm your check-in.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.6),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Pinput(
                      length: 6,
                      controller: _otpController,
                      focusNode: _focusNode,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 60,
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: GlassTheme.textColor(context),
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: BoxDecoration(
                          color: GlassTheme.glassColor(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: GlassTheme.glassBorder(context)),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: GlassTheme.glassColor(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: GlassTheme.textColor(context), width: 2),
                        ),
                      ),
                      onCompleted: (pin) {
                        if (bookingCode != null) {
                          context.read<BookingBloc>().add(
                                UserCheckInEvent(bookingCode: bookingCode, otp: pin),
                              );
                        }
                      },
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 40),
                    BlocBuilder<BookingBloc, BookingState>(
                      builder: (context, state) {
                        final isLoading = state is BookingCheckInLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_otpController.text.length != 6) {
                                      ZinkoFlushbar.showError(
                                          context: context, message: 'Please enter the 6-digit OTP');
                                    } else if (bookingCode == null) {
                                      ZinkoFlushbar.showError(context: context, message: 'Invalid booking information');
                                    } else if (_otpController.text.length == 6 && bookingCode != null) {
                                      context.read<BookingBloc>().add(
                                            UserCheckInEvent(
                                              bookingCode: bookingCode ?? '',
                                              otp: _otpController.text,
                                            ),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'VERIFY & CHECK IN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: GlassTheme.textColor(context).withValues(alpha: 0.5),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // Extra space for keyboard
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
