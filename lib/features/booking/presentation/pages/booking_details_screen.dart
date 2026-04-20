import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';
import '../../../../widgets/zinko_common_card.dart';
import '../../../../widgets/zinko_common_dialog.dart';
import '../../../../widgets/zinko_common_bottom_sheet.dart';
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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _GlassHeaderButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: Text(
            'RESERVATION DETAILS',
            style: TextStyle(
              color: GlassTheme.textColor(context),
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 2.0,
            ),
          ),
        ),
        body: ZinkoBackground(
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 100, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPremiumHeader(context),
                          const SizedBox(height: 24),
                          _buildStatusCard(context),
                          const SizedBox(height: 24),
                          _buildInfoSection(context, 'MAIN INFORMATION', [
                            _DetailItem(label: 'BOOKING CODE', value: booking.bookingCode, icon: Icons.qr_code_2_rounded),
                            _DetailItem(label: 'WORKSPACE', value: booking.seatType, icon: Icons.work_outline_rounded),
                            _DetailItem(label: 'PERSONS', value: '${booking.noOfPersons} Persons', icon: Icons.person_outline_rounded),
                          ]),
                          const SizedBox(height: 16),
                          _buildInfoSection(context, 'SCHEDULE & TIME', [
                            _DetailItem(
                              label: 'DATE',
                              value: booking.bookingDate != null 
                                ? DateFormat('EEEE, d MMMM yyyy').format(booking.bookingDate!)
                                : 'TBD',
                              icon: Icons.calendar_today_rounded,
                            ),
                            _DetailItem(label: 'TIME SLOT', value: booking.timeSlot, icon: Icons.access_time_rounded),
                            _DetailItem(label: 'TOTAL DURATION', value: '${booking.totalHours} Hours', icon: Icons.timelapse_rounded),
                          ]),
                          const SizedBox(height: 16),
                          _buildInfoSection(context, 'CHECK-IN/OUT LOGS', [
                            _DetailItem(label: 'TENTATIVE IN', value: _formatTime(booking.tentativeCheckInDatetime), icon: Icons.login_rounded),
                            _DetailItem(label: 'TENTATIVE OUT', value: _formatTime(booking.tentativeCheckOutDatetime), icon: Icons.logout_rounded),
                            _DetailItem(
                              label: 'ACTUAL IN', 
                              value: (booking.checkInDatetime?.isNotEmpty ?? false) ? _formatTime(booking.checkInDatetime!) : '--:--', 
                              icon: Icons.check_circle_outline_rounded,
                              valueColor: (booking.checkInDatetime?.isNotEmpty ?? false) ? AppColors.success : null,
                            ),
                          ]),
                          const SizedBox(height: 16),
                          _buildPriceCard(context),
                          const SizedBox(height: 140), // Bottom padding for action bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: ZinkoNetworkImage(
            imageUrl: booking.venueImage,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          booking.cafeName,
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: 14, color: GlassTheme.textColor(context).withValues(alpha: 0.5)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                booking.address,
                style: TextStyle(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildStatusCard(BuildContext context) {
    final status = booking.bookingStatus.toUpperCase();
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'CONFIRMED':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'PENDING':
        statusColor = AppColors.warning;
        statusIcon = Icons.pending_rounded;
        break;
      case 'CHECKIN':
        statusColor = AppColors.primaryBlue;
        statusIcon = Icons.login_rounded;
        break;
      case 'CANCELLED':
        statusColor = AppColors.error;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.white54;
        statusIcon = Icons.info_outline_rounded;
    }

    return ZinkoCommonCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BOOKING STATUS',
                style: TextStyle(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<_DetailItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: GlassTheme.textColor(context).withValues(alpha: 0.4),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ZinkoCommonCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  _buildDetailRow(context, entry.value),
                  if (!isLast)
                    Divider(height: 32, color: Colors.white.withValues(alpha: 0.05)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, _DetailItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 18, color: GlassTheme.textColor(context).withValues(alpha: 0.4)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.3),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: TextStyle(
                  color: item.valueColor ?? GlassTheme.textColor(context).withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard(BuildContext context) {
    return ZinkoCommonCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL INVESTMENT',
                style: TextStyle(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '£${booking.totalAmount}',
                style: TextStyle(
                  color: GlassTheme.textColor(context),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.token_rounded, size: 14, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  '${booking.tentativeToken}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final status = booking.bookingStatus.toUpperCase();
    final isConfirmed = status == 'CONFIRMED';
    final isUpcoming = status == 'UPCOMING';
    final isPending = status == 'PENDING';
    final isCompleted = status == 'COMPLETED';

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isConfirmed)
                _PrimaryButton(
                  label: 'CHECK IN AT CENTRE',
                  onTap: () => Navigator.pushNamed(context, OTPCheckInScreen.routeName, arguments: [
                    booking.bookingCode,
                    booking.bookingCode,
                  ]),
                ),
              if (isUpcoming || isPending)
                _SecondaryButton(
                  label: 'CANCEL RESERVATION',
                  color: AppColors.error,
                  onTap: () => _showCancelDialog(context),
                ),
              if (isCompleted) ...[
                _SecondaryButton(
                  label: 'VIEW REVIEWS',
                  color: AppColors.primaryBlue,
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
                      child: _SecondaryButton(
                        label: 'Add Review',
                        color: Colors.amber,
                        onTap: () => _showReviewBottomSheet(context, booking),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SecondaryButton(
                        label: 'SUGGESTION',
                        color: Colors.white.withValues(alpha: 0.1),
                        onTap: () => _showSuggestionBottomSheet(context, booking),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
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

  // Helper Methods & Dialogs remain similar but with updated Glass styles
  String _formatTime(String datetime) {
    if (!datetime.contains('T')) return datetime;
    try {
      return datetime.split('T').last.substring(0, 5);
    } catch (_) {
      return datetime;
    }
  }

  void _showCancelDialog(BuildContext context) {
    ZinkoCommonDialog.show(
      context: context,
      title: 'CANCEL BOOKING',
      message: 'Are you sure you want to cancel this reservation? This cannot be undone.',
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      actionLabel: 'YES, CANCEL',
      actionColor: AppColors.error,
      onAction: () {
        context.read<BookingBloc>().add(CancelBookingEvent(booking.bookingCode));
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _showReviewBottomSheet(BuildContext context, UserBookingEntity booking) {
    final textController = TextEditingController();
    double currentRating = 5.0;

    ZinkoCommonBottomSheet.show(
      context: context,
      title: 'RATE YOUR EXPERIENCE',
      child: StatefulBuilder(
        builder: (context, setModalState) {
          String ratingLabel;
          Color labelColor;
          if (currentRating <= 1) { ratingLabel = "TERRIBLE"; labelColor = Colors.red; }
          else if (currentRating <= 2) { ratingLabel = "POOR"; labelColor = Colors.orange; }
          else if (currentRating <= 3) { ratingLabel = "AVERAGE"; labelColor = Colors.amber; }
          else if (currentRating <= 4) { ratingLabel = "GOOD"; labelColor = Colors.lightGreen; }
          else { ratingLabel = "EXCELLENT"; labelColor = AppColors.success; }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                ratingLabel,
                style: TextStyle(color: labelColor, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 46,
                glow: true,
                glowColor: Colors.amber.withValues(alpha: 0.3),
                itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
                onRatingUpdate: (val) {
                  setModalState(() => currentRating = val);
                },
              ),
              const SizedBox(height: 32),
              TextField(
                controller: textController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tell us more about your visit...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _PrimaryButton(
                label: 'SUBMIT REVIEW',
                onTap: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<FeedbackBloc>().add(SubmitReviewEvent(
                      cafeId: booking.cafeId,
                      reviewText: textController.text,
                      reviewStar: currentRating.toString(),
                      userId: authState.userData.userCode.toString(),
                    ));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSuggestionBottomSheet(BuildContext context, UserBookingEntity booking) {
    final textController = TextEditingController();

    ZinkoCommonBottomSheet.show(
      context: context,
      title: 'ANY SUGGESTIONS?',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            'Your feedback helps us improve the service for everyone.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: textController,
            maxLines: 6,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Share your thoughts here...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _PrimaryButton(
            label: 'SEND FEEDBACK',
            onTap: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                context.read<FeedbackBloc>().add(SubmitSuggestionEvent(
                  userCode: authState.userData.userCode,
                  suggestionData: textController.text,
                  cafeId: booking.cafeId,
                ));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  _DetailItem({required this.label, required this.value, required this.icon, this.valueColor});
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
      ),
    ).animate().scale(delay: 200.ms);
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
            ),
          ),
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
