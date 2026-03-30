import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

import '../../../event/presentation/pages/events_screen.dart';
import '../../../user/presentation/pages/profile_screen.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import '../../../community/presentation/pages/community_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/optimized_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/navigation/navigation_bloc.dart';
import '../../../../core/bloc/navigation/navigation_event.dart';
import '../../../../core/bloc/navigation/navigation_state.dart';
import '../../../../injection_container.dart' as di;

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
          return Scaffold(
            backgroundColor: AppColors.transparent, // Uses global background
            extendBody: true,
            body: IndexedStack(
              index: state.index,
              children: _screens,
            ),
            bottomNavigationBar: _iOSGlassBottomNav(
              currentIndex: state.index,
              onTap: (index) => context
                  .read<NavigationBloc>()
                  .add(NavigationTabChanged(index)),
            ),
          );
        },
      ),
    );
  }
}

class _iOSGlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _iOSGlassBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64 + bottomPadding,
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            border: Border(
                top: BorderSide(
                    color: GlassTheme.glassBorder(context), width: 0.5)),
            boxShadow: [
              BoxShadow(
                  color: OptimizedColors.black05,
                  blurRadius: 30,
                  offset: const Offset(0, -10))
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, 0, Icons.explore_rounded, 'EXPLORE'),
                _buildNavItem(context, 1, Icons.map_rounded, 'MAP'),
                _buildNavItem(
                    context, 2, Icons.calendar_today_rounded, 'EVENTS'),
                _buildNavItem(
                    context, 3, Icons.people_alt_rounded, 'COMMUNITY'),
                _buildNavItem(context, 4, Icons.person_rounded, 'PROFILE'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final activeColor = isDarkMode ? AppColors.white : AppColors.black;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: AppColors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                transform: isSelected 
                    ? (Matrix4.identity()..scale(1.1, 1.1))
                    : (Matrix4.identity()..scale(1.0, 1.0)),
                child: Icon(
                  icon,
                  color: isSelected ? activeColor : GlassTheme.iconColor(context, isSelected: false),
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                height: isSelected ? 10 : 0,
                child: Opacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: activeColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              if (!isSelected) const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
