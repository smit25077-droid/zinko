import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/zinko_glass_box.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../feedback/presentation/bloc/feedback_bloc.dart';
import '../../../feedback/presentation/bloc/feedback_event.dart';
import '../../../feedback/presentation/bloc/feedback_state.dart';
import '../../../feedback/presentation/pages/cafe_reviews_screen.dart';
import '../../domain/entities/user_booking_entity.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'otp_check_in_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  static const String routeName = '/booking-details';
  final UserBookingEntity booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingError) {
              _showFlushbar(context, "Error", state.message, Colors.redAccent);
            } else if (state is BookingOperationSuccess) {
              _showFlushbar(context, "Success", state.message, AppColors.success);
            }
          },
        ),
        BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackError) {
              _showFlushbar(context, "Error", state.message, Colors.redAccent);
            } else if (state is FeedbackSuccess) {
              _showFlushbar(context, "Success", state.message, AppColors.success);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Image Header (300px)
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: AppColors.backgroundDark,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _CircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: ZinkoNetworkImage(
                      imageUrl: booking.venueImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                // Details List
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainInfo(context),
                        const SizedBox(height: 32),
                        _buildSectionTitle(context, 'BOOKING SUMMARY'),
                        const SizedBox(height: 16),
                        _buildDetailedInfoList(),
                        const SizedBox(height: 160), // Space for action bar
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Action Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildUKActionButtonBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildClassicHeader(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         _CircleIconButton(
  //           icon: Icons.arrow_back_ios_new_rounded,
  //           onTap: () => Navigator.pop(context),
  //         ),
  //         Text(
  //           'RESERVATION',
  //           style: TextStyle(
  //             color: Colors.white.withValues(alpha: 0.5),
  //             fontWeight: FontWeight.w900,
  //             fontSize: 12,
  //             letterSpacing: 4.0,
  //           ),
  //         ),
  //         const SizedBox(width: 44), // Alignment balancer
  //       ],
  //     ),
  //   ).animate().fadeIn(duration: 400.ms);
  // }

  Widget _buildPremiumBadge(BuildContext context) {
    final status = booking.bookingStatus.toUpperCase();
    Color color;
    switch (status) {
      case 'CONFIRMED': color = const Color(0xFF004225); break; // British Racing Green
      case 'CHECKIN': color = const Color(0xFF002366); break; // Royal Blue
      case 'COMPLETED': color = Colors.purpleAccent; break;
      case 'PENDING': color = Colors.orangeAccent; break;
      case 'CANCELLED': color = Colors.redAccent; break;
      default: color = Colors.white24;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    ).animate().slideX(begin: -0.2).fadeIn();
  }

  Widget _buildMainInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildCafeTitle(context)),
            _buildPremiumBadge(context),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 14, color: Colors.white54),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                booking.address,
                style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCafeTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          booking.cafeName,
          style: const TextStyle(
            fontSize: 24,
            height: 1.1,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildDetailedInfoList() {
    return Column(
      children: [
        _DetailsCard(
          title: 'GENERAL INFORMATION',
          items: [
            _InfoRow(label: 'BOOKING STATUS', value: booking.bookingStatus.toUpperCase(), icon: Icons.info_outline_rounded),
            _InfoRow(label: 'BOOKING ID', value: booking.bookingCode, icon: Icons.qr_code_rounded),
            _InfoRow(label: 'TENTATIVE TOKEN', value: '£${booking.tentativeToken}', icon: Icons.token_rounded),
          ],
        ),
        const SizedBox(height: 16),
        _DetailsCard(
          title: 'SCHEDULE & DURATION',
          items: [
            _InfoRow(
              label: 'BOOKING DATE',
              value: booking.bookingDate != null ? DateFormat('d MMM yyyy').format(booking.bookingDate!) : 'TBD',
              icon: Icons.calendar_today_rounded,
            ),
            _InfoRow(label: 'TIME SLOT', value: booking.timeSlot, icon: Icons.access_time_rounded),
            _InfoRow(label: 'DURATION', value: '${booking.durationHours} HOURS', icon: Icons.timer_rounded),
            _InfoRow(label: 'TOTAL DURATION', value: '${booking.totalHours} HOURS', icon: Icons.av_timer_rounded),
          ],
        ),
        const SizedBox(height: 16),
        _DetailsCard(
          title: 'CHECK-IN/OUT LOGS',
          items: [
            _InfoRow(label: 'TENTATIVE CHECK-IN', value: _formatTime(booking.tentativeCheckInDatetime), icon: Icons.login_rounded),
            _InfoRow(label: 'TENTATIVE CHECK-OUT', value: _formatTime(booking.tentativeCheckOutDatetime), icon: Icons.logout_rounded),
            _InfoRow(
              label: 'ACTUAL CHECK-IN',
              value: booking.checkInDatetime != null && booking.checkInDatetime!.isNotEmpty ? _formatTime(booking.checkInDatetime!) : '--:--',
              icon: Icons.check_circle_outline_rounded,
            ),
            _InfoRow(
              label: 'ACTUAL CHECK-OUT',
              value: booking.checkOutDatetime != null && booking.checkOutDatetime!.isNotEmpty ? _formatTime(booking.checkOutDatetime!) : '--:--',
              icon: Icons.exit_to_app_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DetailsCard(
          title: 'RESERVATION DETAILS',
          items: [
            _InfoRow(label: 'WORKSPACE TYPE', value: booking.seatType, icon: Icons.work_outline_rounded),
            _InfoRow(label: 'NO. OF PERSONS', value: '${booking.noOfPersons} GUESTS', icon: Icons.group_rounded),
            _InfoRow(label: 'TOTAL INVESTMENT', value: '£${booking.totalAmount}', icon: Icons.account_balance_wallet_outlined, isPrice: true),
          ],
        ),
      ],
    );
  }

  String _formatTime(String datetime) {
    if (!datetime.contains('T')) return datetime;
    try {
      final time = datetime.split('T').last.substring(0, 5);
      return time;
    } catch (_) {
      return datetime;
    }}

  // Widget _buildDivider() {
  //   return Container(
  //     height: 1,
  //     width: double.infinity,
  //     color: Colors.white.withValues(alpha: 0.05),
  //   );
  // }

  Widget _buildUKActionButtonBar(BuildContext context) {
    final status = booking.bookingStatus.toUpperCase();
    final isConfirmed = status == 'CONFIRMED';
    final isUpcoming = status == 'UPCOMING';
    final isPending = status == 'PENDING';
    final isCompleted = status == 'COMPLETED';

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isConfirmed)
                _PremiumUKButton(
                  label: 'CHECK IN AT CENTRE',
                  color: const Color(0xFF004225), // British Racing Green
                  onTap: () => Navigator.pushNamed(context, OTPCheckInScreen.routeName, arguments: [
                    booking.bookingCode,
                    booking.bookingCode,
                  ]),
                ),
              if (isUpcoming || isPending)
                _PremiumUKButton(
                  label: 'CANCEL RESERVATION',
                  color: Colors.redAccent.withValues(alpha: 0.2),
                  textColor: Colors.redAccent,
                  isOutlined: true,
                  onTap: () => _showCancelDialog(context),
                ),
              if (isCompleted) ...[
                _PremiumUKButton(
                  label: 'VIEW REVIEWS',
                  color: const Color(0xFF002366),
                  onTap: () => Navigator.pushNamed(
                    context,
                    CafeReviewsScreen.routeName,
                    arguments: {
                      'cafeId': booking.cafeId,
                      'cafeName': booking.cafeName,
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PremiumUKButton(
                        label: 'RATE EXPERIENCE',
                        color: Colors.amber,
                        textColor: Colors.black,
                        onTap: () => _showReviewDialog(context, booking),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PremiumUKButton(
                        label: 'SUGGESTION',
                        color: Colors.white10,
                        onTap: () => _showSuggestionDialog(context, booking),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: 600.ms, curve: Curves.easeOutQuart);
  }

  void _showFlushbar(BuildContext context, String title, String message, Color color) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
    ).show(context);
  }

  void _showCancelDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.8),
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
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline_rounded, color: Colors.redAccent, size: 40),
                        const SizedBox(height: 24),
                        const Text(
                          'CANCEL RESERVATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Are you sure you wish to cancel this booking? This action cannot be reversed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('DISMISS',
                                    style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w800)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<BookingBloc>().add(CancelBookingEvent(booking.bookingCode));
                                  Navigator.pop(context);
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

  void _showReviewDialog(BuildContext context, UserBookingEntity booking) {
    final textController = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF111111).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'RATE CENTRE',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2),
                  ),
                  const SizedBox(height: 24),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 32,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
                    onRatingUpdate: (val) => rating = val,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: textController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Describe your experience...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('CANCEL',
                              style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PremiumUKButton(
                          label: 'SUBMIT',
                          color: const Color(0xFF004225),
                          onTap: () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is AuthAuthenticated) {
                              context.read<FeedbackBloc>().add(SubmitReviewEvent(
                                    cafeId: booking.cafeId,
                                    reviewText: textController.text,
                                    reviewStar: rating.toString(),
                                    userId: authState.userData.userCode.toString(),
                                  ));
                              Navigator.pop(dialogContext);
                            }
                          },
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
    );
  }

  void _showSuggestionDialog(BuildContext context, UserBookingEntity booking) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF111111).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SUBMIT FEEDBACK',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: textController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'How can we improve our services?',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('CANCEL',
                              style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PremiumUKButton(
                          label: 'SEND',
                          color: const Color(0xFF002366),
                          onTap: () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is AuthAuthenticated) {
                              context.read<FeedbackBloc>().add(SubmitSuggestionEvent(
                                    userCode: authState.userData.userCode,
                                    suggestionData: textController.text,
                                    cafeId: booking.cafeId,
                                  ));
                              Navigator.pop(dialogContext);
                            }
                          },
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
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _DetailsCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return ZinkoGlassBox(
      opacity: 0.1,
      blur: 20,
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final isLast = idx == items.length - 1;
            return Column(
              children: [
                entry.value,
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isPrice;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: Colors.white70),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: isPrice ? Colors.white : Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PremiumUKButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;
  final bool isOutlined;

  const _PremiumUKButton({
    required this.label,
    required this.color,
    this.textColor,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined ? Border.all(color: color) : null,
          boxShadow: isOutlined
              ? []
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
