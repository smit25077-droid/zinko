import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';
import '../bloc/workspace_state.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import 'all_workspaces_screen.dart';
import 'workspace_detail_screen.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../../notifications/presentation/pages/notifications_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/optimized_colors.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> _categories = const [
    'All',
    'Cafes',
    'Coworking',
    'Offices',
    'Studios',
  ];

  @override
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(GetWorkspacesEvent());
  }

  void _goSeeAll() => Navigator.pushNamed(context, AllWorkspacesScreen.routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent, // Persistent background is used
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
          builder: (context, state) {
            if (state is WorkspaceLoading) {
              return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
            } else if (state is WorkspaceError) {
              return Center(
                  child: Text('Error: ${state.message}', style: TextStyle(color: GlassTheme.textColor(context))));
            } else if (state is WorkspaceLoaded) {
              final workspaces = state.workspaces;
              final recommended = workspaces.where((p) => p.discount != null).toList();
              final selectedCategory = state.selectedCategory;

              List<WorkspaceEntity> nearby;
              if (selectedCategory == 'All') {
                nearby = workspaces;
              } else {
                final cat = selectedCategory.toLowerCase();
                nearby = workspaces.where((w) => w.type.name.toLowerCase().startsWith(cat.substring(0, 3))).toList();
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),
                    const _TopBar().animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
                    const SizedBox(height: 4),
                    const _Title().animate().fadeIn(duration: 500.ms, delay: 100.ms).slideX(begin: -0.1),
                    const SizedBox(height: 8),
                    _SectionHeader(title: 'RECOMMENDED', onSeeAll: _goSeeAll)
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms),
                    _RecommendedList(
                      workspaces: recommended,
                      onFavTap: (id) => context.read<WorkspaceBloc>().add(ToggleFavoriteWorkspaceEvent(id)),
                    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideX(begin: 0.1),
                    _CategoryChips(
                      categories: _categories,
                      selected: selectedCategory,
                      onSelect: (cat) => context.read<WorkspaceBloc>().add(FilterWorkspacesByCategoryEvent(cat)),
                    ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                    _SectionHeader(title: 'NEARBY PLACES', onSeeAll: _goSeeAll)
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 600.ms),
                    const SizedBox(height: 4),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nearby.length > 8 ? 8 : nearby.length,
                      itemBuilder: (context, index) {
                        final w = nearby[index];
                        return _NearbyCard(
                          workspace: w,
                          onFavTap: () => context.read<WorkspaceBloc>().add(ToggleFavoriteWorkspaceEvent(w.id)),
                        ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1);
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String firstName = 'Explorer';
        String profileImage = '';

        if (state is UserLoaded) {
          firstName = state.user.name.split(' ').first;
          profileImage = state.user.profileImage;
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: GlassTheme.glassBorder(context), width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: profileImage.isNotEmpty
                          ? Image.network(profileImage, fit: BoxFit.cover)
                          : Container(
                              color: GlassTheme.glassColor(context),
                              child: Icon(Icons.person, color: GlassTheme.textColor(context))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GOOD DAY',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: OptimizedColors.white50,
                              letterSpacing: 1.2)),
                      Text('${firstName.toUpperCase()} 👋',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900, color: GlassTheme.textColor(context))),
                    ],
                  ),
                ],
              ),
              _GlassIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: GlassTheme.textColor(context), size: 22),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      child: Text(
        'DISCOVER YOUR\nCREATIVE HAVEN',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: GlassTheme.textColor(context),
          height: 1.1,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w900, color: GlassTheme.textColor(context), letterSpacing: 1.5)),
          TextButton(
            onPressed: onSeeAll,
            child: Text('SEE ALL',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: GlassTheme.textColor(context))),
          ),
        ],
      ),
    );
  }
}

class _RecommendedList extends StatelessWidget {
  final List<WorkspaceEntity> workspaces;
  final void Function(String) onFavTap;

  const _RecommendedList({required this.workspaces, required this.onFavTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: workspaces.length,
        itemBuilder: (_, i) {
          final w = workspaces[i];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, WorkspaceDetailScreen.routeName, arguments: w),
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    ZinkoNetworkImage(imageUrl: w.imageUrl, width: 280, height: double.infinity, borderRadius: 28),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 1.0],
                            colors: [AppColors.transparent, AppColors.black.withOpacity(0.85)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: w.discount != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration:
                                  BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
                              child: Text(w.discount!,
                                  style: const TextStyle(
                                      color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                            )
                          : const SizedBox(),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.name,
                              style:
                                  const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: OptimizedColors.white70, size: 12),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: Text(w.location,
                                      style: const TextStyle(
                                          color: OptimizedColors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded, color: AppColors.gold, size: 14),
                              const SizedBox(width: 4),
                              Text(w.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ],
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

class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final void Function(String) onSelect;

  const _CategoryChips({required this.categories, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final cat = categories[i];
            final isSelected = cat == selected;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return GestureDetector(
              onTap: () => onSelect(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? (isDark ? AppColors.white : AppColors.black) : GlassTheme.glassColor(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color:
                          isSelected ? (isDark ? AppColors.white : AppColors.black) : GlassTheme.glassBorder(context)),
                ),
                alignment: Alignment.center,
                child: Text(
                  cat.toUpperCase(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? (isDark ? AppColors.black : AppColors.white)
                          : GlassTheme.secondaryTextColor(context),
                      letterSpacing: 0.5),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NearbyCard extends StatelessWidget {
  final WorkspaceEntity workspace;
  final VoidCallback onFavTap;

  const _NearbyCard({required this.workspace, required this.onFavTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, WorkspaceDetailScreen.routeName, arguments: workspace),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: ZinkoNetworkImage(
                            imageUrl: workspace.imageUrl, width: double.infinity, height: 140, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _GlassFavButton(isFavorite: workspace.isFavorite, onTap: onFavTap),
                      ),
                      if (workspace.isBooked)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                            child: const Text('BOOKED',
                                style: TextStyle(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(workspace.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: GlassTheme.textColor(context),
                                      letterSpacing: -0.5))),
                          Text('${workspace.price}${workspace.priceUnit}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900, color: GlassTheme.textColor(context))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 12, color: OptimizedColors.white70),
                          const SizedBox(width: 4),
                          Text('${workspace.location} • ${workspace.distance}',
                              style: const TextStyle(
                                  fontSize: 13, color: OptimizedColors.white70, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: workspace.amenities.take(4).map((icon) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: GlassTheme.glassColor(context), borderRadius: BorderRadius.circular(8)),
                            child: Icon(icon, size: 14, color: OptimizedColors.white80),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassFavButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _GlassFavButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white.withOpacity(0.1)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFavorite ? AppColors.error : AppColors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
