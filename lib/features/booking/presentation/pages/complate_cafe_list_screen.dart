import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/user_booking_entity.dart';
import 'otp_check_in_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';
import '../../../../widgets/zinko_network_image.dart';

class CompleteCafeListScreen extends StatefulWidget {
  static const String routeName = '/CompleteCafeListScreen';

  const CompleteCafeListScreen({super.key});

  @override
  State<CompleteCafeListScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<CompleteCafeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'COMPLETED BOOKINGS',
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ZinkoBackground(
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingError) {
              Flushbar(
                title: "Error",
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
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
                } else if (state is BookingsLoaded) {
                  final filteredBookings = state.bookings.where((b) {
                    final status = b.bookingStatus.toUpperCase();
                   return status != 'UPCOMING' && status != 'PENDING' && status != 'CONFIRMED';
                  }).toList();

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      // _buildTabs(context, state.tabIndex),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<BookingBloc>().add(GetBookingsEvent());
                          },
                          color: GlassTheme.textColor(context),
                          child: filteredBookings.isEmpty
                              ? _buildEmptyState(context)
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                  itemCount: filteredBookings.length,
                                  itemBuilder: (context, index) {
                                    return _BookingCard(
                                      booking: filteredBookings[index],
                                    ).animate().fadeIn(delay: (index * 80).ms);
                                  },
                                ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              shape: BoxShape.circle,
              border: Border.all(color: GlassTheme.glassBorder(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 40,
              color: GlassTheme.textColor(context).withValues(alpha: 0.4),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            'NO BOOKINGS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: GlassTheme.textColor(context),
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Your future reservations will appear here. Start exploring workspaces now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: GlassTheme.secondaryTextColor(context),
                height: 1.5,
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final UserBookingEntity booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    // Map status for display
    final status = booking.bookingStatus.toUpperCase();
    final isConfirmed = status == 'CONFIRMED';
    final isUpcoming = status == 'UPCOMING';
    final isPending = status == 'PENDING';
    // Fallback UI data
    final String cafeName = 'Cafe #${booking.cafeId}';
    final String location = 'Workspace #${booking.cafeWorkspacesId}';
    const String imageUrl = 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=200';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: GlassTheme.glassBorder(context)),
                      ),
                      child: ZinkoNetworkImage(
                        imageUrl: imageUrl,
                        width: 70,
                        height: 70,
                        borderRadius: 16,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cafeName,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: GlassTheme.textColor(context),
                                letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  size: 10, color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.5),
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: GlassTheme.textColor(context).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: GlassTheme.textColor(context).withValues(alpha: 0.8),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: GlassTheme.glassBorder(context).withValues(alpha: 0.1)),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CODE: ${booking.bookingCode}',
                            style: TextStyle(
                                fontSize: 8,
                                color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0)),
                        const SizedBox(height: 2),
                        Text(
                          booking.bookingDate != null
                              ? '${DateFormat('MMM d').format(booking.bookingDate!).toUpperCase()} • ${booking.tentativeCheckInDatetime.split('T').last.substring(0, 5)}'
                              : 'DATE TBD',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800, color: GlassTheme.textColor(context)),
                        ),
                      ],
                    ),
                    if (isConfirmed) _CheckInButton(booking: booking),
                    if (isUpcoming || isPending) _CancelButton(booking: booking),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final UserBookingEntity booking;

  const _CancelButton({required this.booking});

  void _showCancelDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 32),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'CANCEL BOOKING',
                          style: TextStyle(
                            color: GlassTheme.textColor(context),
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Are you sure you want to cancel this booking? This action cannot be undone.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.7),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('KEEP IT',
                                    style: TextStyle(
                                        color: GlassTheme.textColor(context).withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w800)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<BookingBloc>().add(CancelBookingEvent(booking.bookingCode));
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCancelDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
        ),
        child: const Text(
          'CANCEL',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

class _CheckInButton extends StatelessWidget {
  final UserBookingEntity booking;

  const _CheckInButton({required this.booking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, OTPCheckInScreen.routeName, arguments: {
          'bookingId': booking.bookingId.toString(),
          'bookingCode': booking.bookingCode,
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_person_rounded, size: 16, color: Colors.black),
            const SizedBox(width: 8),
            const Text(
              'CHECK IN',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassHeaderButton({required this.icon, required this.onTap});

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
