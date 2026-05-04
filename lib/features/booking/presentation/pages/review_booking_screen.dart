import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/features/booking/presentation/pages/home_screen.dart';

import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_details_entity.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';

import 'package:zinko_app/features/booking/presentation/bloc/create_booking/create_booking_bloc.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_request_entity.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_success_overlay.dart';
import 'package:zinko_app/widgets/zinko_common_dialog.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/core/di/service_locator.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:zinko_app/features/wallet/presentation/pages/wallet_screen.dart';

class ReviewBookingScreen extends StatelessWidget {
  static const String routeName = '/review-booking';
  final BookingDetailsEntity bookingData;

  const ReviewBookingScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CreateBookingBloc>()),
        BlocProvider(create: (_) => sl<WalletBloc>()..add(FetchWalletDataEvent())),
      ],
      child: _ReviewBookingScreenContent(bookingData: bookingData),
    );
  }
}

class _ReviewBookingScreenContent extends StatelessWidget {
  final BookingDetailsEntity bookingData;

  const _ReviewBookingScreenContent({required this.bookingData});

  void _handleConfirm(BuildContext context, WorkspaceEntity workspace, DateTime date, String checkIn, String checkOut,
      double duration, int slotId, int? tableId, double subtotal, double tax, double total) {
    // 1. Check Wallet Balance first
    final walletState = context.read<WalletBloc>().state;
    double currentBalance = 0;

    if (walletState is WalletLoaded) {
      currentBalance = walletState.balance.balance;
    } else if (context.read<UserBloc>().state is UserLoaded) {
      currentBalance = (context.read<UserBloc>().state as UserLoaded).user.balance;
    }

    if (currentBalance < total) {
      ZinkoCommonDialog.show(
        context: context,
        title: 'INSUFFICIENT BALANCE',
        message:
            'Your current balance (£${currentBalance.toStringAsFixed(2)}) is lower than the booking total (£${total.toStringAsFixed(0)}). Please add funds to continue.',
        icon: Icons.account_balance_wallet_rounded,
        iconColor: AppColors.error,
        actionLabel: 'ADD BALANCE',
        onAction: () {
          Navigator.pop(context); // Close dialog
          Navigator.pushNamed(context, WalletScreen.routeName);
        },
        cancelLabel: 'MAYBE LATER',
      );
      return;
    }

    // 2. Proceed with booking if balance is sufficient
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Convert "09:00 AM" to "09:00" or "01:00 PM" to "13:00"
      final timeParts = checkIn.split(' ');
      final hm = timeParts[0].split(':');
      int hour = int.parse(hm[0]);
      final ampm = timeParts[1].toUpperCase();
      if (ampm == 'PM' && hour != 12) hour += 12;
      if (ampm == 'AM' && hour == 12) hour = 0;
      final checkInTime24 = '${hour.toString().padLeft(2, '0')}:${hm[1]}';

      final checkInDateTime = '${dateStr}T$checkInTime24';

      final request = BookingRequestEntity(
        userId: authState.userData.userCode,
        cafeId: int.tryParse(workspace.id) ?? 1,
        bookingDate: dateStr,
        cafeTimeSlotsId: slotId,
        cafeWorkspacesId: (tableId ?? 1).toString(),
        durationHours: duration.ceil(),
        tentativeCheckInDatetime: checkInDateTime,
      );

      context.read<CreateBookingBloc>().add(CreateBookingSubmittedEvent(request));
    } else {
      ZinkoFlushbar.showError(context: context, message: 'Please login to continue');
    }
  }

  @override
  Widget build(BuildContext context) {
    final workspace = bookingData.workspace;
    final date = bookingData.date;
    final checkInTime = bookingData.checkInTime;
    final checkOutTime = bookingData.checkOutTime;
    final duration = bookingData.duration;
    final slotId = bookingData.timeSlotId;
    final table = bookingData.table;
    final tableId = bookingData.tableId;
    final subtotal = bookingData.subtotal;
    final tax = bookingData.tax;
    final total = bookingData.total;
    final peopleCount = bookingData.peopleCount;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateBookingBloc, CreateBookingState>(
          listener: (context, state) {
            if (state is CreateBookingSuccess) {
              ZinkoSuccessOverlay.show(
                context,
                title: 'BOOKED SUCCESSFULLY!',
                subtitle: 'Your seat at ${workspace.name} is reserved.\nBooking Code: ${state.response.bookingCode}',
                onFinish: () {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                },
              );
            } else if (state is CreateBookingError) {
              ZinkoFlushbar.showError(context: context, message: state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<CreateBookingBloc, CreateBookingState>(
        buildWhen: (previous, current) =>
            current is CreateBookingInitial ||
            current is CreateBookingLoading ||
            current is CreateBookingError ||
            current is CreateBookingSuccess,
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: ZinkoAppBar(title: 'REVIEW BOOKING'),
            body: ZinkoBackground(
              child: SafeArea(
                child: ZinkoScrollBody(
                  padding: CommonUtil.pAll16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGlassWorkspaceCard(context, workspace),
                      const SizedBox(height: 12),
                      _buildGlassDetailCard(context, date, checkInTime, checkOutTime, table, peopleCount),
                      const SizedBox(height: 12),
                      _buildGlassPaymentCard(context, subtotal, tax, total, duration),
                      const SizedBox(height: 12),
                      _buildGlassWalletInfo(context),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: _buildConfirmAction(context, workspace, date, checkInTime, checkOutTime, duration,
                slotId, tableId, subtotal, tax, total, state is CreateBookingLoading),
          );
        },
      ),
    );
  }

  Widget _buildGlassWorkspaceCard(BuildContext context, WorkspaceEntity workspace) {
    return ZinkoCommonCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ZinkoNetworkImage(
            imageUrl: workspace.imageUrl,
            width: 84,
            height: 84,
            borderRadius: 20,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workspace.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.8)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 11, color: OptimizedColors.white50),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(workspace.location,
                          style: const TextStyle(
                              fontSize: 12, color: OptimizedColors.white70, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildGlassDetailCard(
      BuildContext context, DateTime date, String checkIn, String checkOut, String table, int peopleCount) {
    return _buildGlassContainer(
      context: context,
      title: 'TIMING & LOCATION',
      child: Column(
        children: [
          _buildRow(context, 'Reservation Date', DateFormat('EEEE, MMM d, yyyy').format(date)),
          _buildRow(context, 'Number of People', '$peopleCount ${peopleCount == 1 ? 'Person' : 'People'}'),
          _buildRow(context, 'Check In', checkIn),
          _buildRow(context, 'Check Out', checkOut),
          _buildRow(context, 'Assigned Table', table),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildGlassPaymentCard(BuildContext context, double sub, double tax, double total, double dur) {
    return _buildGlassContainer(
      context: context,
      title: 'SUMMARY OF CHARGES',
      child: Column(
        children: [
          _buildRow(context, 'Booking Subtotal (${dur.toStringAsFixed(1)} hrs)', '£${sub.toStringAsFixed(0)}'),
          _buildRow(context, 'Service Fees & VAT', '£${tax.toStringAsFixed(0)}'),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: OptimizedColors.white12, height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL PAYABLE',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: 1.2)),
              Text('£${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -1.0)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildGlassWalletInfo(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      buildWhen: (previous, current) => current is WalletLoading || current is WalletLoaded || current is WalletError,
      builder: (context, walletState) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            double balance = 0;
            bool isLoading = walletState is WalletLoading;

            if (walletState is WalletLoaded) {
              balance = walletState.balance.balance;
            } else if (userState is UserLoaded) {
              balance = userState.user.balance;
            }

            return _buildGlassContainer(
              context: context,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: OptimizedColors.white10,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: OptimizedColors.white10),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                        : const Icon(Icons.account_balance_wallet_rounded, color: AppColors.white, size: 20),
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
                                color: OptimizedColors.white70,
                                letterSpacing: 1.2)),
                        Text('£${balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                                letterSpacing: -0.5)),
                      ],
                    ),
                  ),
                  if (!isLoading)
                    Icon(balance >= 0 ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                        color: balance >= 0 ? AppColors.success : AppColors.error, size: 22),
                ],
              ),
            );
          },
        );
      },
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: OptimizedColors.white70, fontSize: 13, fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required BuildContext context, String? title, required Widget child}) {
    return ZinkoCommonCard(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      borderRadius: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title,
                style: const TextStyle(
                    color: OptimizedColors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildConfirmAction(BuildContext context, WorkspaceEntity ws, DateTime date, String checkIn, String checkOut,
      double duration, int slotId, int? tableId, double subtotal, double tax, double total, bool loading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: OptimizedColors.applyAlpha(AppColors.backgroundDark, 0.95),
        border: Border(top: BorderSide(color: OptimizedColors.white10)),
      ),
      child: GestureDetector(
        onTap: loading
            ? null
            : () =>
                _handleConfirm(context, ws, date, checkIn, checkOut, duration, slotId, tableId, subtotal, tax, total),
        child: AnimatedContainer(
          duration: 300.ms,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2.5))
              : const Text('CONFIRM',
                  style:
                      TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
      ),
    );
  }
}
