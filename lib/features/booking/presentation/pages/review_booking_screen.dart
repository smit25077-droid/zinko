import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_screen.dart';

import '../../domain/entities/workspace_entity.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/booking_entity.dart';
import '../../../../widgets/zinko_success_overlay.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/optimized_colors.dart';

class ReviewBookingScreen extends StatelessWidget {
  static const String routeName = '/review-booking';
  final Map<String, dynamic> bookingData;

  const ReviewBookingScreen({super.key, required this.bookingData});

  void _handlePayment(
      BuildContext context,
      WorkspaceEntity workspace,
      DateTime date,
      String timeSlot,
      String table,
      double subtotal,
      double tax,
      double total) {
    final booking = BookingEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      placeId: workspace.id,
      placeName: workspace.name,
      location: workspace.location,
      imageUrl: workspace.imageUrl,
      date: date,
      timeSlot: timeSlot,
      tableNumber: table,
      subtotal: subtotal,
      tax: tax,
      total: total,
      isCompleted: false,
      placeType: BookingPlaceType.coworking,
    );
    context.read<BookingBloc>().add(AddBookingEvent(booking));
  }

  @override
  Widget build(BuildContext context) {
    final WorkspaceEntity workspace = bookingData['workspace'];
    final DateTime date = bookingData['date'];
    final String timeSlot = bookingData['timeSlot'];
    final String table = bookingData['table'];
    final double subtotal = bookingData['subtotal'];
    final double tax = bookingData['tax'];
    final double total = bookingData['total'];

    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingsLoaded &&
            state.bookings
                .any((b) => b.placeName == workspace.name && b.date == date)) {
          ZinkoSuccessOverlay.show(
            context,
            title: 'BOOKED SUCCESSFULLY!',
            subtitle: 'Your seat at ${workspace.name} is reserved.',
            onFinish: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('REVIEW BOOKING',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                  child: Image.asset('assets/images/cafe_hotel_bg.png',
                      fit: BoxFit.cover)),
              Positioned.fill(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(color: GlassTheme.backgroundOverlay(context))),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGlassWorkspaceCard(context, workspace),
                            const SizedBox(height: 12),
                            _buildGlassDetailCard(context, date, timeSlot, table),
                            const SizedBox(height: 12),
                            _buildGlassPaymentCard(context, subtotal, tax, total),
                            const SizedBox(height: 12),
                            _buildGlassWalletInfo(context),
                          ],
                        ),
                      ),
                    ),
                    _buildConfirmAction(context, workspace, date, timeSlot,
                        table, subtotal, tax, total, state is BookingLoading),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassWorkspaceCard(BuildContext context, WorkspaceEntity workspace) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(workspace.imageUrl,
                      width: 84, height: 84, fit: BoxFit.cover),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(workspace.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.8)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 11, color: OptimizedColors.white60),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(workspace.location,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: OptimizedColors.white60,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded,
                                size: 12, color: AppColors.gold),
                            SizedBox(width: 4),
                            Text('VERIFIED SPACE',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildGlassDetailCard(BuildContext context, DateTime date, String timeSlot, String table) {
    return _buildGlassContainer(
      context: context,
      title: 'TIMING & LOCATION',
      child: Column(
        children: [
          _buildRow('Reservation Date', DateFormat('EEEE, MMM d, yyyy').format(date)),
          _buildRow('Selected Window', timeSlot),
          _buildRow('Assigned Desk/Table', table),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildGlassPaymentCard(BuildContext context, double sub, double tax, double total) {
    return _buildGlassContainer(
      context: context,
      title: 'SUMMARY OF CHARGES',
      child: Column(
        children: [
          _buildRow('Booking Subtotal', '£${sub.toStringAsFixed(0)}'),
          _buildRow('Service Fees & VAT', '£${tax.toStringAsFixed(0)}'),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: OptimizedColors.white12, height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL PAYABLE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2)),
              Text('£${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.0)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }

  Widget _buildGlassWalletInfo(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        double balance = 0;
        if (state is UserLoaded) balance = state.user.balance;
        return _buildGlassContainer(
          context: context,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: OptimizedColors.white30,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: OptimizedColors.white30),),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AVAILABLE BALANCE',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: OptimizedColors.white50,
                            letterSpacing: 1.2)),
                    Text('£${balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 22),
            ],
          ),
        );
      },
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05);
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: OptimizedColors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required BuildContext context, String? title, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(title,
                          style: const TextStyle(
                              color: OptimizedColors.white50,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                const SizedBox(height: 16),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmAction(
      BuildContext context,
      WorkspaceEntity ws,
      DateTime date,
      String time,
      String table,
      double subtotal,
      double tax,
      double total,
      bool loading) {
    return Container(
      padding: EdgeInsets.fromLTRB(28, 20, 28, 28 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: GestureDetector(
        onTap: loading
            ? null
            : () => _handlePayment(
                context, ws, date, time, table, subtotal, tax, total),
        child: AnimatedContainer(
          duration: 300.ms,
          height: 64,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF0F0F0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: AppColors.white.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10))
              ]),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: AppColors.black, strokeWidth: 2.5))
              : const Text('CONFIRM & PAY',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0)),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
      ),
    );
  }
}
