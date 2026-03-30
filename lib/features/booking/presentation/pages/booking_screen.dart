import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/optimized_colors.dart';
import '../../../../utils/glass_theme.dart';

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

  const BookingScreen({super.key, this.workspaceId, this.workspaceName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingSelectionBloc>(),
      child: _BookingScreenContent(workspaceId: workspaceId, workspaceName: workspaceName),
    );
  }
}

class _BookingScreenContent extends StatelessWidget {
  final String? workspaceId;
  final String? workspaceName;

  const _BookingScreenContent({this.workspaceId, this.workspaceName});

  static final List<String> _slots = [
    '09:00 AM – 01:00 PM',
    '01:00 PM – 05:00 PM',
    'Full Day (09:00 – 06:00)',
  ];

  static final List<bool> _tableOccupied = [false, true, false, false, true, false, false, false];

  bool _isSelectable(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final maxDate = today.add(const Duration(days: 14));
    final d = DateTime(day.year, day.month, day.day);
    return !d.isBefore(today) && !d.isAfter(maxDate);
  }

  bool _isSelected(DateTime day, DateTime selectedDate) => 
      day.year == selectedDate.year && day.month == selectedDate.month && day.day == selectedDate.day;

  double _computeSubtotal(WorkspaceEntity ws, String selectedSlot) {
    final priceStr = ws.price.replaceAll(RegExp(r'[^0-9.]'), '');
    final base = double.tryParse(priceStr) ?? 5.0;
    if (selectedSlot.contains('Full')) return base * 8;
    if (ws.priceUnit == '/hr') return base * 4;
    return base;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      builder: (context, wsState) {
        WorkspaceEntity? workspace;
        if (wsState is WorkspaceLoaded) {
          workspace = wsState.workspaces.firstWhere(
            (w) => w.id == workspaceId || w.name == workspaceName,
            orElse: () => wsState.workspaces.first,
          );
        }

        if (workspace == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.white)));
        }

        return BlocBuilder<BookingSelectionBloc, BookingSelectionState>(
          builder: (context, selState) {
            final subtotal = _computeSubtotal(workspace!, selState.selectedSlot);
            final tax = subtotal * 0.1;
            final total = subtotal + tax;
            final canContinue = selState.selectedTable != null;

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('BOOK A SEAT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    Text(workspace.name, style: TextStyle(color: OptimizedColors.white50, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset('assets/images/cafe_hotel_bg.png', fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(color: OptimizedColors.backgroundDark70),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Column(
                              children: [
                                _buildGlassCalendar(context, selState),
                                const SizedBox(height: 12),
                                _buildGlassSlotSelection(context, selState),
                                const SizedBox(height: 12),
                                _buildGlassTableSelection(context, selState),
                                const SizedBox(height: 12),
                                _buildGlassBillSummary(context, subtotal, tax, total),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                        _buildContinueAction(context, workspace, selState, subtotal, tax, total, canContinue),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGlassCalendar(BuildContext context, BookingSelectionState state) {
    final monthLabel = '${_monthName(state.displayMonth.month)} ${state.displayMonth.year}'.toUpperCase();
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
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: Colors.white),
                    onPressed: () => context.read<BookingSelectionBloc>().add(const ChangeMonthEvent(isNext: false)),
                  ),
                  Text(monthLabel, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white),
                    onPressed: () => context.read<BookingSelectionBloc>().add(const ChangeMonthEvent(isNext: true)),
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
    final firstDay = DateTime(state.displayMonth.year, state.displayMonth.month, 1);
    final startWeekday = firstDay.weekday % 7;
    final daysInMonth = DateTime(state.displayMonth.year, state.displayMonth.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
      itemCount: startWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < startWeekday) return const SizedBox();
        final dayNum = index - startWeekday + 1;
        final day = DateTime(state.displayMonth.year, state.displayMonth.month, dayNum);
        final selectable = _isSelectable(day);
        final selected = _isSelected(day, state.selectedDate);

        return GestureDetector(
          onTap: selectable ? () => context.read<BookingSelectionBloc>().add(SelectDateEvent(day)) : null,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: selected ? Colors.white : (selectable ? OptimizedColors.white08 : Colors.transparent),
              shape: BoxShape.circle,
              border: selected ? null : Border.all(color: selectable ? OptimizedColors.white12 : Colors.transparent),
            ),
            child: Center(
              child: Text(
                '$dayNum',
                style: TextStyle(
                  color: selected ? Colors.black : (selectable ? Colors.white : OptimizedColors.white20),
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

  Widget _buildGlassSlotSelection(BuildContext context, BookingSelectionState state) {
    return _buildSectionCard(
      context: context,
      title: 'TIME SLOT',
      child: Column(
        children: _slots.map((s) => _buildSlotCard(context, s, state.selectedSlot)).toList(),
      ),
    );
  }

  Widget _buildSlotCard(BuildContext context, String slot, String selectedSlot) {
    final selected = selectedSlot == slot;
    return GestureDetector(
      onTap: () => context.read<BookingSelectionBloc>().add(SelectSlotEvent(slot)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? OptimizedColors.white16 : OptimizedColors.white08,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? OptimizedColors.white40 : OptimizedColors.white10),
        ),
        child: Row(
          children: [
            Expanded(child: Text(slot, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: selected ? FontWeight.w800 : FontWeight.w500))),
            if (selected) const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassTableSelection(BuildContext context, BookingSelectionState state) {
    return _buildSectionCard(
      context: context,
      title: 'SELECT TABLE',
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: 8,
        itemBuilder: (context, i) {
          final label = 'T${i + 1}';
          final occupied = _tableOccupied[i];
          final selected = state.selectedTable == label;
          return GestureDetector(
            onTap: occupied ? null : () => context.read<BookingSelectionBloc>().add(SelectTableEvent(label)),
            child: Container(
              decoration: BoxDecoration(
                color: occupied ? OptimizedColors.white04 : (selected ? Colors.white : OptimizedColors.white12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: selected ? Colors.white : OptimizedColors.white12),
              ),
              child: Center(
                child: Text(label, style: TextStyle(color: selected ? Colors.black : (occupied ? OptimizedColors.white10 : Colors.white), fontSize: 14, fontWeight: FontWeight.w900)),
              ),
            ).animate(target: selected ? 1 : 0).scale(begin: const Offset(1,1), end: const Offset(1.05, 1.05), duration: 200.ms),
          );
        },
      ),
    );
  }

  Widget _buildGlassBillSummary(BuildContext context, double sub, double tax, double total) {
    return _buildSectionCard(
      context: context,
      title: 'BILL SUMMARY',
      child: Column(
        children: [
          _summaryRow('Subtotal', '£${sub.toStringAsFixed(2)}'),
          _summaryRow('Gst Tax (10%)', '£${tax.toStringAsFixed(2)}'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(color: OptimizedColors.white10)),
          _summaryRow('Total Pay', '£${total.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isBold ? Colors.white : OptimizedColors.white60, fontSize: isBold ? 14 : 12, fontWeight: isBold ? FontWeight.w900 : FontWeight.w600)),
          Text(value, style: TextStyle(color: isBold ? Colors.white : OptimizedColors.white80, fontSize: isBold ? 16 : 13, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required BuildContext context, required String title, required Widget child}) {
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
              Text(title, style: TextStyle(color: OptimizedColors.white30, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueAction(BuildContext context, WorkspaceEntity ws, BookingSelectionState state, double sub, double tax, double total, bool active) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: OptimizedColors.backgroundDark70,
            border: Border(top: BorderSide(color: OptimizedColors.white10)),
          ),
          child: GestureDetector(
            onTap: active ? () {
              Navigator.pushNamed(context, ReviewBookingScreen.routeName, arguments: {
                'workspace': ws, 
                'date': state.selectedDate, 
                'timeSlot': state.selectedSlot, 
                'table': state.selectedTable, 
                'subtotal': sub, 
                'tax': tax, 
                'total': total
              });
            } : null,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: active ? Colors.white : OptimizedColors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text('CONTINUE TO REVIEW', style: TextStyle(color: active ? Colors.black : OptimizedColors.white30, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return names[month];
  }
}
