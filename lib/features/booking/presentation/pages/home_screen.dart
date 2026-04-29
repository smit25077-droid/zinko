import 'package:flutter/material.dart';
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_bloc.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_event.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_state.dart';

import 'package:zinko_app/features/event/presentation/pages/events_screen.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/user/presentation/pages/profile_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/dashboard_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/map_screen.dart';
import 'package:zinko_app/features/community/presentation/pages/community_screen.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';
import 'package:zinko_app/widgets/zinko_background.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_bloc.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_event.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/widgets/zinko_profile_completion_dialog.dart';
import 'package:zinko_app/features/community/presentation/bloc/community_bloc.dart';
import 'package:zinko_app/features/community/presentation/bloc/community_event.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = const [
    DashboardScreen(),
    MapScreen(),
    EventsScreen(),
    // CommunityScreen(),
    ProfileScreen(),
  ];

  // Track visited tabs for lazy loading.
  // Initially only include the Dashboard (0).
  final Set<int> _visitedTabs = {0};

  @override
  void initState() {
    super.initState();
    // After the first frame, we can safely initialize the Map tab (1) in the background.
    // This avoids the 'RenderBox was not laid out' crash during startup.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visitedTabs.add(1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      buildWhen: (previous, current) => previous.index != current.index,
      builder: (context, state) {
        _visitedTabs.add(state.index);
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
                  // Use a manual Stack with Visibility for true lazy loading + background pre-loading
                  Stack(
                    children: List.generate(_screens.length, (index) {
                      final bool isVisited = _visitedTabs.contains(index);
                      final bool isSelected = state.index == index;

                      if (!isVisited) return const SizedBox.shrink();

                      return Visibility(
                        visible: isSelected,
                        maintainState: true,
                        child: _screens[index],
                      );
                    }),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _FloatingGlassDock(
                      currentIndex: state.index,
                      onTap: (index) {
                        if (index == 1 || index == 2 || index == 3 || index == 4) {
                          final userState = context.read<UserBloc>().state;
                          if (userState is UserLoaded && !userState.user.isProfileComplete) {
                            ZinkoProfileCompletionDialog.show(context, userState.user);
                            return;
                          }
                        }
                        
                        context.read<NavigationBloc>().add(NavigationTabChanged(index));
                        _triggerTabRefresh(context, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _triggerTabRefresh(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (context.read<WorkspaceBloc>().state is! WorkspaceLoading) {
           context.read<WorkspaceBloc>().add(GetWorkspacesEvent());
        }
        if (context.read<CafeBloc>().state is! CafeLoading) {
           context.read<CafeBloc>().add(const SearchCafesEvent());
        }
        break;
      case 1:
        context.read<BookingBloc>().add(GetBookingsEvent());
        break;
      case 2:
        final userState = context.read<UserBloc>().state;
        if (userState is UserLoaded) {
          context.read<CafeBloc>().add(GetWishlistEvent(userCode: userState.user.userCode));
        }
        break;
      // case 3:
      //   context.read<CommunityBloc>().add(GetCommunityDataEvent());
      //   break;
      case 3:
        context.read<UserBloc>().add(GetUserProfileEvent());
        break;
    }
  }
}

class _FloatingGlassDock extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _FloatingGlassDock({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(CommonUtil.s20, 0, CommonUtil.s20, bottomPadding + CommonUtil.s10),
      child: ZinkoGlassBox.thick(
        blur: 25,
        borderRadius: CommonUtil.r24,
        color: OptimizedColors.backgroundDark70,
        border: Border.all(color: OptimizedColors.glassBorderDark, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: OptimizedColors.black20,
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: CommonUtil.pH8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ExpandingNavItem(
                    index: 0, current: currentIndex, icon: Icons.grid_view_rounded, label: 'HOME', onTap: onTap),
                _ExpandingNavItem(index: 1, current: currentIndex, icon: Icons.map_rounded, label: 'MAP', onTap: onTap),
                _ExpandingNavItem(
                    index: 2, current: currentIndex, icon: Icons.star_rounded, label: 'EVENTS', onTap: onTap),
                // _ExpandingNavItem(
                //     index: 3, current: currentIndex, icon: Icons.chat_bubble_rounded, label: 'COMMUNITY', onTap: onTap),
                _ExpandingNavItem(
                    index: 3, current: currentIndex, icon: Icons.person_rounded, label: 'PROFILE', onTap: onTap),
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
    const activeColor = Colors.white;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: CommonUtil.pHor12Ver10,
        decoration: BoxDecoration(
          color: isSelected ? OptimizedColors.white12 : Colors.transparent,
          borderRadius: CommonUtil.bRadius50,
          border: Border.all(
            color: isSelected ? OptimizedColors.white10 : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : OptimizedColors.white50,
              size: 22,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
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
