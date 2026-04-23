import 'package:flutter/material.dart';

import 'package:zinko_app/features/event/presentation/pages/events_screen.dart';
import 'package:zinko_app/features/user/presentation/pages/profile_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/dashboard_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/map_screen.dart';
import 'package:zinko_app/features/community/presentation/pages/community_screen.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';
import 'package:zinko_app/widgets/zinko_background.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_bloc.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_event.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_state.dart';
import 'package:zinko_app/injection_container.dart' as di;
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/widgets/zinko_profile_completion_dialog.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    DashboardScreen(),
    MapScreen(),
    EventsScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<NavigationBloc>(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return ZinkoBackground(
            child: PopScope(
              canPop: state.index == 0,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (state.index != 0) {
                  context.read<NavigationBloc>().add(const NavigationTabChanged(0));
                }
              },
              child: Scaffold(
                backgroundColor: AppColors.transparent,
                body: Stack(
                  children: [
                    IndexedStack(
                      index: state.index,
                      children: _screens,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _FloatingGlassDock(
                        currentIndex: state.index,
                        onTap: (index) {
                          if (index == 1 || index == 2 || index == 3) {
                            final userState = context.read<UserBloc>().state;
                            if (userState is UserLoaded && !userState.user.isProfileComplete) {
                              ZinkoProfileCompletionDialog.show(context, userState.user);
                              return;
                            }
                          }
                          context.read<NavigationBloc>().add(NavigationTabChanged(index));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FloatingGlassDock extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _FloatingGlassDock({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 10),
      child: ZinkoGlassBox.thick(
        blur: 25,
        borderRadius: 30,
        color: GlassTheme.glassColor(context).withValues(alpha: isDark ? 0.2 : 0.4),
        border: Border.all(color: GlassTheme.glassBorder(context), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ExpandingNavItem(
                    index: 0, current: currentIndex, icon: Icons.grid_view_rounded, label: 'HOME', onTap: onTap),
                _ExpandingNavItem(index: 1, current: currentIndex, icon: Icons.map_rounded, label: 'MAP', onTap: onTap),
                _ExpandingNavItem(
                    index: 2, current: currentIndex, icon: Icons.star_rounded, label: 'EVENTS', onTap: onTap),
                _ExpandingNavItem(
                    index: 3, current: currentIndex, icon: Icons.chat_bubble_rounded, label: 'COMMUNITY', onTap: onTap),
                _ExpandingNavItem(
                    index: 4, current: currentIndex, icon: Icons.person_rounded, label: 'PROFILE', onTap: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandingNavItem extends StatelessWidget {
  final int index;
  final int current;
  final IconData icon;
  final String label;
  final void Function(int) onTap;

  const _ExpandingNavItem({
    required this.index,
    required this.current,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == current;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? activeColor.withValues(alpha: 0.08) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : GlassTheme.iconColor(context, isSelected: false),
              size: 22,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: activeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
