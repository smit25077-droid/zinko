import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/widgets/zinko_empty_state.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_state.dart';
import 'package:zinko_app/features/booking/presentation/pages/booking_details_screen.dart';

class CompleteCafeListScreen extends StatefulWidget {
  static const String routeName = '/CompleteCafeListScreen';

  const CompleteCafeListScreen({super.key});

  @override
  State<CompleteCafeListScreen> createState() => _CompleteCafeListScreenState();
}

class _CompleteCafeListScreenState extends State<CompleteCafeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetBookingsEvent());
    context.read<BookingBloc>().add(FilterBookingsByTabEvent(0)); // Start with CHECKIN
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'BOOKING HISTORY',
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
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
            } else if (state is BookingsLoaded) {
              final filteredBookings = state.bookings.where((b) {
                final status = b.bookingStatus.toUpperCase();
                if (state.tabIndex == 0) return status == 'CHECKIN';
                if (state.tabIndex == 1) return status == 'COMPLETED';
                return false;
              }).toList();

              return SafeArea(
                child: Column(
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
                                    ?
                        ZinkoEmptyState(
                          title: 'NO BOOKINGS',
                          message: 'Your future reservations will appear here. Start exploring workspaces now.',
                        )
                        // _buildEmptyState(context)
                                    : ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                        itemCount: filteredBookings.length,
                                        addAutomaticKeepAlives: false,
                                        itemExtent: 163, // Calculated height of _BookingCard
                                        itemBuilder: (context, index) {
                                  return _BookingCard(
                                    booking: filteredBookings[index],
                                  ).animate().fadeIn(delay: (index * 80).ms);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
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
  //             color: GlassTheme.glassColor(context),
  //             shape: BoxShape.circle,
  //             border: Border.all(color: GlassTheme.glassBorder(context)),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: OptimizedColors.black20,
  //                 blurRadius: 30,
  //                 offset: const Offset(0, 10),
  //               )
  //             ],
  //           ),
  //           child: Icon(
  //             Icons.event_busy_rounded,
  //             size: 40,
  //             color: OptimizedColors.white40,
  //           ),
  //         ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
  //         const SizedBox(height: 24),
  //         Text(
  //           'NO RECORDS FOUND',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w900,
  //             color: GlassTheme.textColor(context),
  //             letterSpacing: -0.5,
  //           ),
  //         ).animate().fadeIn(delay: 200.ms),
  //         const SizedBox(height: 8),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 48),
  //           child: Text(
  //             'Your history will appear here. Start exploring workspaces now.',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 12,
  //               color: GlassTheme.secondaryTextColor(context),
  //               height: 1.5,
  //             ),
  //           ),
  //         ).animate().fadeIn(delay: 400.ms),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTabs(BuildContext context, int selectedTab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ZinkoCommonCard(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabItem(
                title: 'CHECKIN',
                isSelected: selectedTab == 0,
                onTap: () => context.read<BookingBloc>().add(FilterBookingsByTabEvent(0))),
            _TabItem(
                title: 'COMPLETED',
                isSelected: selectedTab == 1,
                onTap: () => context.read<BookingBloc>().add(FilterBookingsByTabEvent(1))),
          ],
        ),
      ),
    );
  }
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
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.black : OptimizedColors.white40,
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
    final status = booking.bookingStatus.toUpperCase();
    final isCompleted = status == 'COMPLETED';

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
                      imageUrl: booking.venueImage,
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
                          booking.cafeName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 10, color: AppColors.white.withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking.address,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.white.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isCompleted ? AppColors.success : AppColors.primary).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: isCompleted ? AppColors.success : AppColors.primary,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            booking.bookingDate != null ? DateFormat('d MMM').format(booking.bookingDate!) : 'TBD',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.white),
                          ),
                        ],
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
