import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cafe/cafe_menu_bloc.dart';
import '../bloc/cafe/cafe_menu_event.dart';
import '../bloc/cafe/cafe_menu_state.dart';
import 'bookings_screen.dart';
import '../../../../injection_container.dart';
import '../../../../widgets/zinko_success_overlay.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/optimized_colors.dart';
import '../../../../widgets/zinko_background.dart';

class CafeMenuScreen extends StatelessWidget {
  static const String routeName = '/cafe-menu';

  const CafeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CafeMenuBloc>(),
      child: const _CafeMenuContent(),
    );
  }
}

class _CafeMenuContent extends StatelessWidget {
  const _CafeMenuContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeMenuBloc, CafeMenuState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ZinkoSuccessOverlay.show(
            context,
            title: 'CHECKED IN!',
            subtitle: 'Order placed. Enjoy your workspace!',
            onFinish: () {
              Navigator.pushNamedAndRemoveUntil(context, BookingsScreen.routeName, (route) => false);
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'CAFE MENU',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
            centerTitle: true,
          ),
          body: ZinkoBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    color: GlassTheme.glassColor(context),
                    child: const Text(
                      'Select items to order with your check-in:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: OptimizedColors.white70),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      itemCount: state.menuItems.length,
                      itemBuilder: (context, index) {
                        final item = state.menuItems[index];
                        return _buildMenuItemCard(context, item, index);
                      },
                    ),
                  ),
                  _buildCheckoutSection(context, state.totalOrder),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItemCard(BuildContext context, Map<String, dynamic> item, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(item['image'], width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                    const SizedBox(height: 2),
                    Text('£${item['price']}', style: const TextStyle(fontSize: 14, color: OptimizedColors.white60, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildQtyBtn(context, Icons.remove_rounded, () {
                    context.read<CafeMenuBloc>().add(UpdateQuantityEvent(index, -1));
                  }),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${item['quantity']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                  _buildQtyBtn(context, Icons.add_rounded, () {
                    context.read<CafeMenuBloc>().add(UpdateQuantityEvent(index, 1));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.05);
  }

  Widget _buildQtyBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context),
          shape: BoxShape.circle,
          border: Border.all(color: GlassTheme.glassBorder(context)),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, double total) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          decoration: BoxDecoration(
            color: GlassTheme.backgroundOverlay(context),
            border: Border(top: BorderSide(color: GlassTheme.glassBorder(context))),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('TOTAL ORDER', style: const TextStyle(fontSize: 9, color: OptimizedColors.white60, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  const SizedBox(height: 2),
                  Text('£${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                      final bookingId = args?['bookingId'] as String?;
                      if (bookingId != null) {
                        context.read<CafeMenuBloc>().add(ConfirmCheckInEvent(bookingId));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('CONFIRM & CHECK IN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
