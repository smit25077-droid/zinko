import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/booking_entity.dart';
import 'qr_scanner_screen.dart';
import '../../../../utils/glass_theme.dart';

class BookingsScreen extends StatelessWidget {
  static const String routeName = '/bookings';
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'BOOKINGS',
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cafe_hotel_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: GlassTheme.backgroundOverlay(context)),
            ),
          ),
          SafeArea(
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: GlassTheme.textColor(context)));
                } else if (state is BookingsLoaded) {
                  final filteredBookings = state.bookings.where((b) {
                    if (state.tabIndex == 0) return !b.isCompleted;
                    return b.isCompleted;
                  }).toList();

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildTabs(context, state.tabIndex),
                      Expanded(
                        child: filteredBookings.isEmpty
                            ? _buildEmptyState(context)
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 8, 20, 100),
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredBookings.length,
                                itemBuilder: (context, index) {
                                  return _BookingCard(
                                    booking: filteredBookings[index],
                                  )
                                      .animate()
                                      .fadeIn(delay: (index * 80).ms)
                                      .slideY(begin: 0.1);
                                },
                              ),
                      ),
                    ],
                  );
                } else if (state is BookingError) {
                  return Center(
                      child: Text(state.message,
                          style:
                              TextStyle(color: GlassTheme.textColor(context))));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, int selectedTab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Row(
              children: [
                _TabItem(
                    title: 'ACTIVE',
                    isSelected: selectedTab == 0,
                    onTap: () => context
                        .read<BookingBloc>()
                        .add(FilterBookingsByTabEvent(0))),
                _TabItem(
                    title: 'HISTORY',
                    isSelected: selectedTab == 1,
                    onTap: () => context
                        .read<BookingBloc>()
                        .add(FilterBookingsByTabEvent(1))),
              ],
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
          Icon(Icons.calendar_month_rounded,
              size: 56, color: GlassTheme.textColor(context).withOpacity(0.05)),
          const SizedBox(height: 12),
          Text(
            'YOU HAVE NO BOOKINGS',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: GlassTheme.textColor(context).withOpacity(0.5),
                letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem(
      {required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected
                  ? (isDark ? Colors.black : Colors.white)
                  : GlassTheme.textColor(context).withOpacity(0.4),
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
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
                        border:
                            Border.all(color: GlassTheme.glassBorder(context)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(booking.imageUrl,
                            width: 70, height: 70, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.placeName,
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
                                  size: 10,
                                  color: GlassTheme.secondaryTextColor(context)
                                      .withOpacity(0.4)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  booking.location,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          GlassTheme.secondaryTextColor(context)
                                              .withOpacity(0.5),
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: GlassTheme.textColor(context)
                                  .withOpacity(0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              booking.isCompleted ? 'COMPLETED' : 'CONFIRMED',
                              style: TextStyle(
                                color: GlassTheme.textColor(context)
                                    .withOpacity(
                                        booking.isCompleted ? 0.3 : 0.8),
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
              Divider(
                  height: 1,
                  color: GlassTheme.glassBorder(context).withOpacity(0.1)),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DATE & TIME',
                            style: TextStyle(
                                fontSize: 8,
                                color: GlassTheme.secondaryTextColor(context)
                                    .withOpacity(0.4),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0)),
                        const SizedBox(height: 2),
                        Text(
                          '${DateFormat('MMM d').format(booking.date).toUpperCase()} • ${booking.timeSlot.split(' ').first}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: GlassTheme.textColor(context)),
                        ),
                      ],
                    ),
                    if (!booking.isCompleted) _CheckInButton(booking: booking),
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

class _CheckInButton extends StatelessWidget {
  final BookingEntity booking;
  const _CheckInButton({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, QRScannerScreen.routeName, arguments: {
          'bookingId': booking.id,
          'placeType': booking.placeType
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.qr_code_scanner_rounded,
                size: 16, color: isDark ? Colors.black : Colors.white),
            const SizedBox(width: 8),
            Text(
              'CHECK IN',
              style: TextStyle(
                  color: isDark ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.5),
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
