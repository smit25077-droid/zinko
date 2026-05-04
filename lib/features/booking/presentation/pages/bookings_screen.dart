import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

import 'package:zinko_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_state.dart';
import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';
import 'package:zinko_app/features/booking/presentation/pages/booking_details_screen.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_empty_state.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';

class BookingsScreen extends StatelessWidget {
  static const String routeName = '/bookings';

  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BookingsScreenContent();
  }
}

class _BookingsScreenContent extends StatefulWidget {
  const _BookingsScreenContent();

  @override
  State<_BookingsScreenContent> createState() => _BookingsScreenContentState();
}

class _BookingsScreenContentState extends State<_BookingsScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ZinkoAppBar(title: 'BOOKINGS'),
      // AppBar(
      //   title: Text(
      //     'BOOKINGS',
      //     style: TextStyle(
      //       color: GlassTheme.textColor(context),
      //       fontWeight: FontWeight.w900,
      //       fontSize: 15,
      //       letterSpacing: 1.5,
      //     ),
      //   ),
      //   centerTitle: true,
      //   leading: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: _GlassHeaderButton(
      //       icon: Icons.arrow_back_ios_new_rounded,
      //       onTap: () => Navigator.pop(context),
      //     ),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: ZinkoBackground(
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingError) {
              Flushbar(
                title: "Error",
                message: state.message,
                duration: const Duration(seconds: 4),
                flushbarPosition: FlushbarPosition.TOP,
                backgroundColor: OptimizedColors.applyAlpha(Colors.redAccent, 0.9),
                icon: const Icon(Icons.error_outline, color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                margin: const EdgeInsets.all(12),
              ).show(context);
            } else if (state is BookingOperationSuccess) {
              Flushbar(
                title: "Success",
                message: state.message,
                duration: const Duration(seconds: 3),
                flushbarPosition: FlushbarPosition.TOP,
                backgroundColor: OptimizedColors.applyAlpha(AppColors.success, 0.9),
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                margin: const EdgeInsets.all(12),
              ).show(context);
            }
          },
          child: SafeArea(
            child: BlocBuilder<BookingBloc, BookingState>(
              buildWhen: (previous, current) =>
                  current is BookingLoading || current is BookingsLoaded || current is BookingError,
              builder: (context, state) {
                if (state is BookingLoading) {
                  return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
                } else if (state is BookingsLoaded) {
                  final filteredBookings = state.bookings.where((b) {
                    final status = b.bookingStatus.toUpperCase();
                    if (state.tabIndex == 0) return status == 'UPCOMING';
                    if (state.tabIndex == 1) return status == 'PENDING';
                    if (state.tabIndex == 2) return status == 'CONFIRMED';
                    return false;
                  }).toList();

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildTabs(context, state.tabIndex),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<BookingBloc>().add(GetBookingsEvent());
                          },
                          color: GlassTheme.textColor(context),
                          child: filteredBookings.isEmpty
                              ? ZinkoEmptyState(
                                  title: 'NO BOOKINGS',
                                  message: 'Your future reservations will appear here. Start exploring workspaces now.',
                                )

                              // _buildEmptyState(context)
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                                  // physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                  itemCount: filteredBookings.length,
                                  itemExtent: 180,
                                  // Fixed height for booking cards
                                  addAutomaticKeepAlives: false,
                                  itemBuilder: (context, index) {
                                    return _BookingCard(
                                      booking: filteredBookings[index],
                                    ).animate().fadeIn(delay: (index * 30).ms, duration: 250.ms);
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

  Widget _buildTabs(BuildContext context, int selectedTab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ZinkoCommonCard(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            _TabItem(
                title: 'UPCOMING',
                isSelected: selectedTab == 0,
                onTap: () => context.read<BookingBloc>().add(FilterBookingsByTabEvent(0))),
            _TabItem(
                title: 'PENDING',
                isSelected: selectedTab == 1,
                onTap: () => context.read<BookingBloc>().add(FilterBookingsByTabEvent(1))),
            _TabItem(
                title: 'CONFIRMED',
                isSelected: selectedTab == 2,
                onTap: () => context.read<BookingBloc>().add(FilterBookingsByTabEvent(2))),
          ],
        ),
      ),
    );
  }

  // Widget _buildEmptyState(BuildContext context) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(24),
  //           decoration: BoxDecoration(
  //             color: AppColors.backgroundDark,
  //             shape: BoxShape.circle,
  //             border: Border.all(color: OptimizedColors.white10),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: OptimizedColors.applyAlpha(AppColors.secondary, 0.1),
  //                 blurRadius: 30,
  //                 offset: const Offset(0, 10),
  //               )
  //             ],
  //           ),
  //           child: Icon(
  //             Icons.event_busy_rounded,
  //             size: 40,
  //             color: AppColors.white50,
  //           ),
  //         ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
  //         const SizedBox(height: 24),
  //         Text(
  //           'NO BOOKINGS',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w900,
  //             color: GlassTheme.textColor(context),
  //             letterSpacing: -0.5,
  //           ),
  //         ).animate().fadeIn(delay: 150.ms, duration: 250.ms),
  //         const SizedBox(height: 8),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 48),
  //           child: Text(
  //             'Your future reservations will appear here. Start exploring workspaces now.',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 12,
  //               color: GlassTheme.secondaryTextColor(context),
  //               height: 1.5,
  //             ),
  //           ),
  //         ).animate().fadeIn(delay: 250.ms, duration: 250.ms),
  //       ],
  //     ),
  //   );
  // }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.black : Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
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
    // final isUpcoming = status == 'UPCOMING';
    // final isPending = status == 'PENDING';

    // Real UI data from API
    final String cafeName = booking.cafeName;
    final String location = booking.address;
    final String imageUrl = booking.venueImage;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, BookingDetailsScreen.routeName, arguments: booking),
      child: ZinkoCommonCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: OptimizedColors.white10),
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
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 10, color: OptimizedColors.white40),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                    fontSize: 11, color: OptimizedColors.white50, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: OptimizedColors.applyAlpha(isConfirmed ? AppColors.success : AppColors.white, 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: isConfirmed ? AppColors.success : AppColors.white50,
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
            Divider(height: 1, color: OptimizedColors.white05),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.bookingDate != null
                            ? '${DateFormat('d MMM').format(booking.bookingDate!).toUpperCase()} • ${booking.tentativeCheckInDatetime.split('T').last.substring(0, 5)}'
                            : 'DATE TBD',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.white),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: OptimizedColors.white30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _CancelButton extends StatelessWidget {
//   final UserBookingEntity booking;
//
//   const _CancelButton({required this.booking});
//
//   void _showCancelDialog(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       barrierColor: Colors.black.withValues(alpha: 0.7),
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, anim1, anim2) => const SizedBox(),
//       transitionBuilder: (context, anim1, anim2, child) {
//         return Transform.scale(
//           scale: anim1.value,
//           child: Opacity(
//             opacity: anim1.value,
//             child: AlertDialog(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               contentPadding: EdgeInsets.zero,
//               content: ClipRRect(
//                 borderRadius: BorderRadius.circular(24),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1A1A1A).withValues(alpha: 0.9),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.redAccent.withValues(alpha: 0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 32),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'CANCEL BOOKING',
//                           style: TextStyle(
//                             color: GlassTheme.textColor(context),
//                             fontWeight: FontWeight.w900,
//                             fontSize: 18,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           'Are you sure you want to cancel this booking? This action cannot be undone.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.7),
//                             fontSize: 13,
//                             height: 1.5,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('KEEP IT',
//                                     style: TextStyle(
//                                         color: GlassTheme.textColor(context).withValues(alpha: 0.5),
//                                         fontWeight: FontWeight.w800)),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   context.read<BookingBloc>().add(CancelBookingEvent(booking.bookingCode));
//                                   Navigator.pop(context);
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.redAccent,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   elevation: 0,
//                                 ),
//                                 child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showCancelDialog(context),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.redAccent.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
//         ),
//         child: const Text(
//           'CANCEL',
//           style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
//         ),
//       ),
//     );
//   }
// }
//
// class _CheckInButton extends StatelessWidget {
//   final UserBookingEntity booking;
//
//   const _CheckInButton({required this.booking});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, OTPCheckInScreen.routeName, arguments: [
//           booking.bookingCode, // Use code as ID if ID is missing
//           booking.bookingCode,
//         ]);
//         //     ]{
//         //   'bookingId': booking.bookingId.toString(),
//         //   'bookingCode': booking.bookingCode,
//         // });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.lock_person_rounded, size: 16, color: Colors.black),
//             const SizedBox(width: 8),
//             const Text(
//               'CHECK IN',
//               style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassHeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: OptimizedColors.white05,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OptimizedColors.white10),
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}
