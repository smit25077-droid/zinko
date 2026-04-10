import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_state.dart';
import 'review_booking_screen.dart';

import '../bloc/selection/booking_selection_bloc.dart';
import '../bloc/selection/booking_selection_event.dart';
import '../bloc/selection/booking_selection_state.dart';
import '../../../../injection_container.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = '/booking';
  final String? workspaceId;
  final String? workspaceName;
  final WorkspaceEntity? workspace;

  const BookingScreen({
    super.key,
    this.workspaceId,
    this.workspaceName,
    this.workspace,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingSelectionBloc>(),
      child: _BookingScreenContent(
        workspaceId: workspaceId,
        workspaceName: workspaceName,
        initialWorkspace: workspace,
      ),
    );
  }
}

class _BookingScreenContent extends StatelessWidget {
  final String? workspaceId;
  final String? workspaceName;
  final WorkspaceEntity? initialWorkspace;

  const _BookingScreenContent({
    this.workspaceId,
    this.workspaceName,
    this.initialWorkspace,
  });

  bool _isSelectable(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final maxDate = today.add(const Duration(days: 14));
    final d = DateTime(day.year, day.month, day.day);
    return !d.isBefore(today) && !d.isAfter(maxDate);
  }

  bool _isSelected(DateTime day, DateTime selectedDate) =>
      day.year == selectedDate.year &&
      day.month == selectedDate.month &&
      day.day == selectedDate.day;

  // Map DateTime.weekday (1=Mon, 7=Sun) to API's weekDay string
  String _getWeekDayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thrusday'; // Matching API spelling
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  CafeTimeSlot? _getSlotForDate(WorkspaceEntity workspace, DateTime date) {
    final dayStr = _getWeekDayString(date.weekday);
    try {
      return workspace.cafeTimeSlots.firstWhere((s) {
        // Simple case-insensitive comparison or trim if needed
        return s.weekDay.trim().toLowerCase() == dayStr.toLowerCase();
      });
    } catch (_) {
      return workspace.cafeTimeSlots.isNotEmpty
          ? workspace.cafeTimeSlots.first
          : null;
    }
  }

  List<String> _generateStartTimeIntervals(
      String start, String end, double durationHours) {
    final List<String> times = [];
    try {
      final startTime = _parseTime(start);
      // The latest you can start is endTime - duration
      final endTime = _parseTime(end)
          .subtract(Duration(minutes: (durationHours * 60).round()));

      var current = startTime;
      while (!current.isAfter(endTime)) {
        times.add(_formatTime(current));
        current = current.add(const Duration(minutes: 30));
      }
    } catch (_) {
      return [
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '12:00 PM',
        '01:00 PM',
        '02:00 PM',
        '03:00 PM',
        '04:00 PM',
        '05:00 PM'
      ];
    }
    return times;
  }

  DateTime _parseTime(String timeStr) {
    final parts = timeStr.trim().split(' ');
    final hm = parts[0].split(':');
    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);
    final ampm = parts[1].toUpperCase();

    if (ampm == 'PM' && hour != 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;

    return DateTime(2000, 1, 1, hour, minute);
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    String ampm = 'AM';
    if (hour >= 12) {
      ampm = 'PM';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;
    final h = hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m $ampm';
  }

  double _computeSubtotal(WorkspaceEntity ws, double hours) {
    final priceStr = ws.price.replaceAll(RegExp(r'[^0-9.]'), '');
    final base = double.tryParse(priceStr) ?? 0.0;
    return base * hours;
  }

  @override
  Widget build(BuildContext context) {
    if (initialWorkspace != null) {
      return _buildMainContent(context, initialWorkspace!);
    }

    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      builder: (context, wsState) {
        WorkspaceEntity? workspace;
        if (wsState is WorkspaceLoaded) {
          if (wsState.workspaces.isNotEmpty) {
            workspace = wsState.workspaces.firstWhere(
              (w) => w.id == workspaceId || w.name == workspaceName,
              orElse: () => wsState.workspaces.first,
            );
          }
        }

        if (workspace == null) {
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                      color: GlassTheme.textColor(context))));
        }

        return _buildMainContent(context, workspace);
      },
    );
  }

  Widget _buildMainContent(BuildContext context, WorkspaceEntity workspace) {
    return BlocBuilder<BookingSelectionBloc, BookingSelectionState>(
      builder: (context, selState) {
        final subtotal = _computeSubtotal(workspace, selState.durationHours);
        const tax = 0.0;
        final total = subtotal;
        final canContinue = selState.selectedTable != null;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: GlassTheme.textColor(context), size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BOOK A SEAT',
                    style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                Text(workspace.name,
                    style: TextStyle(
                        color: GlassTheme.secondaryTextColor(context),
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          body: ZinkoBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          _buildGlassCalendar(context, selState),
                          const SizedBox(height: 12),
                          _buildPeopleSelection(context, selState, workspace),
                          const SizedBox(height: 12),
                          _buildDynamicTimeSelection(
                              context, workspace, selState),
                          const SizedBox(height: 12),
                          _buildDynamicTableSelection(
                              context, workspace, selState),
                          const SizedBox(height: 12),
                          _buildGlassBillSummary(context, subtotal, tax, total,
                              selState.durationHours),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _buildContinueAction(context, workspace, selState, subtotal,
                      tax, total, canContinue),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassCalendar(
      BuildContext context, BookingSelectionState state) {
    final monthLabel =
        '${_monthName(state.displayMonth.month)} ${state.displayMonth.year}'
            .toUpperCase();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        size: 16, color: GlassTheme.textColor(context)),
                    onPressed: () => context
                        .read<BookingSelectionBloc>()
                        .add(const ChangeMonthEvent(isNext: false)),
                  ),
                  Text(monthLabel,
                      style: TextStyle(
                          color: GlassTheme.textColor(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0)),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: GlassTheme.textColor(context)),
                    onPressed: () => context
                        .read<BookingSelectionBloc>()
                        .add(const ChangeMonthEvent(isNext: true)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDateGrid(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateGrid(BuildContext context, BookingSelectionState state) {
    final firstDay =
        DateTime(state.displayMonth.year, state.displayMonth.month, 1);
    final startWeekday = firstDay.weekday % 7;
    final daysInMonth =
        DateTime(state.displayMonth.year, state.displayMonth.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, childAspectRatio: 1),
      itemCount: startWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < startWeekday) return const SizedBox();
        final dayNum = index - startWeekday + 1;
        final day =
            DateTime(state.displayMonth.year, state.displayMonth.month, dayNum);
        final selectable = _isSelectable(day);
        final selected = _isSelected(day, state.selectedDate);

        return GestureDetector(
          onTap: selectable
              ? () =>
                  context.read<BookingSelectionBloc>().add(SelectDateEvent(day))
              : null,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: selected
                  ? GlassTheme.textColor(context)
                  : (selectable
                      ? GlassTheme.textColor(context).withValues(alpha: 0.08)
                      : Colors.transparent),
              shape: BoxShape.circle,
              border: selected
                  ? null
                  : Border.all(
                      color: selectable
                          ? GlassTheme.textColor(context).withValues(alpha: 0.12)
                          : Colors.transparent),
            ),
            child: Center(
              child: Text(
                '$dayNum',
                style: TextStyle(
                  color: selected
                      ? (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white)
                      : (selectable
                          ? GlassTheme.textColor(context)
                          : GlassTheme.textColor(context).withValues(alpha: 0.2)),
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicTimeSelection(BuildContext context,
      WorkspaceEntity workspace, BookingSelectionState state) {
    final slot = _getSlotForDate(workspace, state.selectedDate);
    final startTimeString = slot?.startTime ?? '09:00 AM';
    final endTimeString = slot?.endTime ?? '10:00 PM';

    final startTimeIntervals = _generateStartTimeIntervals(
        startTimeString, endTimeString, state.durationHours);

    return _buildSectionCard(
      context: context,
      title: 'BOOKING TIME',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDurationRow(context, state.durationHours),
          const SizedBox(height: 16),
          _buildTimeRow(context, 'START TIME (CHECK-IN)', startTimeIntervals,
              state.checkInTime, true),
          const SizedBox(height: 16),
          _buildCheckoutSummary(context, state.checkOutTime),
        ],
      ),
    );
  }

  Widget _buildDurationRow(BuildContext context, double currentHours) {
    final List<double> durations = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HOW MANY HOURS?',
            style: TextStyle(
                color: GlassTheme.secondaryTextColor(context),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: durations.length,
            itemBuilder: (context, i) {
              final h = durations[i];
              final selected = h == currentHours;
              final label = h == 1.0 ? '1 Hr' : '${h.toInt()} Hrs';
              return GestureDetector(
                onTap: () => context
                    .read<BookingSelectionBloc>()
                    .add(SelectDurationEvent(h)),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected
                        ? GlassTheme.textColor(context)
                        : GlassTheme.textColor(context).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selected
                            ? GlassTheme.textColor(context)
                            : GlassTheme.textColor(context).withValues(alpha: 0.1)),
                  ),
                  alignment: Alignment.center,
                  child: Text(label,
                      style: TextStyle(
                          color: selected
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white)
                              : GlassTheme.textColor(context),
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.w600)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, String checkout) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GlassTheme.textColor(context).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: GlassTheme.textColor(context).withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('AUTOMATIC CHECK-OUT AT',
              style: TextStyle(
                  color: GlassTheme.secondaryTextColor(context),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
          Text(checkout,
              style: TextStyle(
                  color: GlassTheme.textColor(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTimeRow(BuildContext context, String label, List<String> times,
      String selectedTime, bool isCheckIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: GlassTheme.secondaryTextColor(context),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: times.length,
            itemBuilder: (context, i) {
              final t = times[i];
              final selected = t == selectedTime;
              return GestureDetector(
                onTap: () => context
                    .read<BookingSelectionBloc>()
                    .add(SelectTimeEvent(t, isCheckIn: isCheckIn)),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected
                        ? GlassTheme.textColor(context)
                        : GlassTheme.textColor(context).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selected
                            ? GlassTheme.textColor(context)
                            : GlassTheme.textColor(context).withValues(alpha: 0.1)),
                  ),
                  alignment: Alignment.center,
                  child: Text(t,
                      style: TextStyle(
                          color: selected
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white)
                              : GlassTheme.textColor(context),
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.w600)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleSelection(BuildContext context,
      BookingSelectionState state, WorkspaceEntity workspace) {
    final currentCount = state.peopleCount;
    return _buildSectionCard(
      context: context,
      title: 'NUMBER OF PEOPLE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('How many people are joining?',
                  style: TextStyle(
                      color: GlassTheme.secondaryTextColor(context),
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$currentCount PEOPLE',
                    style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontSize: 10,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: GlassTheme.textColor(context),
              inactiveTrackColor:
                  GlassTheme.textColor(context).withValues(alpha: 0.1),
              thumbColor: GlassTheme.textColor(context),
              overlayColor: GlassTheme.textColor(context).withValues(alpha: 0.2),
              trackHeight: 4,
              valueIndicatorTextStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            child: Slider(
              value: currentCount.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$currentCount',
              onChanged: (val) {
                final int count = val.toInt();
                int? capacity;
                if (state.selectedTableId != null &&
                    state.selectedTableId != 0) {
                  for (final t in workspace.cafeWorkSpaces) {
                    if (t.id == state.selectedTableId) {
                      capacity = t.totalSeats;
                      break;
                    }
                  }
                }
                context.read<BookingSelectionBloc>().add(
                    SelectPeopleEvent(count, currentTableCapacity: capacity));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTableSelection(BuildContext context,
      WorkspaceEntity workspace, BookingSelectionState state) {
    final areas = workspace.cafeWorkSpaces;
    return _buildSectionCard(
      context: context,
      title: 'SELECT TABLE',
      child: areas.isEmpty
          ? Center(
              child: Text('No tables available',
                  style: TextStyle(
                      color: GlassTheme.secondaryTextColor(context),
                      fontSize: 11)))
          : GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.2),
              itemCount: areas.length,
              itemBuilder: (context, i) {
                final ws = areas[i];
                final label = ws.tableName;
                final selected = state.selectedTableId == ws.id;
                final capacityEnough = ws.totalSeats >= state.peopleCount;
                final occupied = !ws.isActive || !capacityEnough;

                return GestureDetector(
                  onTap: occupied
                      ? null
                      : () => context
                          .read<BookingSelectionBloc>()
                          .add(SelectTableEvent(label, ws.id)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: occupied
                          ? GlassTheme.textColor(context).withValues(alpha: 0.04)
                          : (selected
                              ? GlassTheme.textColor(context)
                              : GlassTheme.textColor(context)
                                  .withValues(alpha: 0.08)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: selected
                              ? GlassTheme.textColor(context)
                              : GlassTheme.textColor(context).withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(label,
                            style: TextStyle(
                                color: selected
                                    ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white)
                                    : (occupied
                                        ? GlassTheme.textColor(context)
                                            .withValues(alpha: 0.2)
                                        : GlassTheme.textColor(context)),
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                        Text('${ws.totalSeats} seats',
                            style: TextStyle(
                                color: selected
                                    ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black.withValues(alpha: 0.6)
                                        : Colors.white.withValues(alpha: 0.6))
                                    : (occupied
                                        ? GlassTheme.secondaryTextColor(context)
                                            .withValues(alpha: 0.1)
                                        : GlassTheme.secondaryTextColor(context)
                                            .withValues(alpha: 0.5)),
                                fontSize: 8,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ).animate(target: selected ? 1 : 0).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      duration: 200.ms),
                );
              },
            ),
    );
  }

  Widget _buildGlassBillSummary(BuildContext context, double sub, double tax,
      double total, double hours) {
    final hourlyRate = hours > 0 ? sub / hours : 0.0;
    return _buildSectionCard(
      context: context,
      title: 'BILL SUMMARY',
      child: Column(
        children: [
          _summaryRow(context, '1 Hour Charge', hourlyRate.toStringAsFixed(0)),
          _summaryRow(context, 'Total Selected Hours',
              '${hours.toStringAsFixed(1)} hrs'),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Divider(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.1))),
          _summaryRow(context, 'Total Pay', total.toStringAsFixed(0),
              isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isBold
                      ? GlassTheme.textColor(context)
                      : GlassTheme.secondaryTextColor(context),
                  fontSize: isBold ? 14 : 12,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.w600)),
          Text(value,
              style: TextStyle(
                  color: isBold
                      ? GlassTheme.textColor(context)
                      : GlassTheme.textColor(context).withValues(alpha: 0.8),
                  fontSize: isBold ? 16 : 13,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      {required BuildContext context,
      required String title,
      required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: GlassTheme.tertiaryTextColor(context),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueAction(
      BuildContext context,
      WorkspaceEntity ws,
      BookingSelectionState state,
      double sub,
      double tax,
      double total,
      bool active) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: GlassTheme.backgroundOverlay(context),
            border: Border(
                top: BorderSide(
                    color: GlassTheme.textColor(context).withValues(alpha: 0.1))),
          ),
          child: GestureDetector(
            onTap: active
                ? () {
                    final slot = _getSlotForDate(ws, state.selectedDate);
                    Navigator.pushNamed(context, ReviewBookingScreen.routeName,
                        arguments: {
                          'workspace': ws,
                          'date': state.selectedDate,
                          'checkInTime': state.checkInTime,
                          'checkOutTime': state.checkOutTime,
                          'duration': state.durationHours,
                          'timeSlotId': slot?.id ?? 0,
                          'table': state.selectedTable,
                          'tableId': state.selectedTableId,
                          'subtotal': sub,
                          'tax': tax,
                          'total': total,
                          'peopleCount': state.peopleCount,
                        });
                  }
                : null,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: active
                    ? GlassTheme.textColor(context)
                    : GlassTheme.textColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text('CONTINUE TO REVIEW',
                  style: TextStyle(
                      color: active
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white)
                          : GlassTheme.secondaryTextColor(context),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0)),
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[month];
  }
}
