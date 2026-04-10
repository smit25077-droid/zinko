import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';
import '../bloc/workspace_state.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../user/presentation/bloc/user_event.dart';
import 'all_workspaces_screen.dart';
import 'workspace_detail_screen.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../../notifications/presentation/pages/notifications_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/optimized_colors.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/cafe/presentation/bloc/cafe_bloc.dart';
import '../../../../features/cafe/presentation/bloc/cafe_event.dart';
import '../../../../features/cafe/presentation/bloc/cafe_state.dart';
import '../../../../features/cafe/data/mappers/cafe_mapper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final bool _isLoadingMore = false;

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
    context.read<UserBloc>().add(GetUserProfileEvent());
    context.read<WorkspaceBloc>().add(GetWorkspacesEvent());
    context.read<CafeBloc>().add(const SearchCafesEvent(keyword: ''));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<UserBloc>().add(GetUserProfileEvent());
    context.read<WorkspaceBloc>().add(GetWorkspacesEvent());
    context.read<CafeBloc>().add(const SearchCafesEvent(keyword: ''));
    await Future.delayed(const Duration(seconds: 1));
  }

  void _goSeeAll() =>
      Navigator.pushNamed(context, AllWorkspacesScreen.routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
          builder: (context, state) {
            if (state is WorkspaceLoading) return const _DashboardShimmer();

            final workspaces = state is WorkspaceLoaded
                ? state.workspaces
                : <WorkspaceEntity>[];
            final selectedCategory =
                state is WorkspaceLoaded ? state.selectedCategory : 'All';
            final bool isMainError = state is WorkspaceError ||
                (state is WorkspaceLoaded && workspaces.isEmpty);

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: Colors.white,
              backgroundColor: Colors.black87,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TopBar()
                          .animate()
                          .fadeIn(duration: 500.ms),
                      const SizedBox(height: 4),
                      const _Title()
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 100.ms),
                      const SizedBox(height: 8),
                      _SectionHeader(title: 'RECOMMENDED', onSeeAll: _goSeeAll)
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 200.ms),
                      BlocBuilder<CafeBloc, CafeState>(
                        builder: (context, cafeState) {
                          if (cafeState is CafeLoading) {
                            return const _HorizontalShimmer();
                          }

                          if (cafeState is CafeLoaded) {
                            if (cafeState.cafes.isEmpty) {
                              return const _EmptyView(
                                  message: 'No recommended cafes found');
                            }
                            final recommended = cafeState.cafes
                                .map((c) => CafeMapper.toWorkspaceEntity(c))
                                .toList();
                            return _RecommendedList(
                              workspaces: recommended,
                              onFavTap: (id) => context
                                  .read<WorkspaceBloc>()
                                  .add(ToggleFavoriteWorkspaceEvent(id)),
                            );
                          }

                          if (cafeState is CafeError) {
                            return const _EmptyView(
                                message: 'No cafes available right now');
                          }

                          return const _HorizontalShimmer();
                        },
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 400.ms),
                      _CategoryChips(
                        categories: _categories,
                        selected: selectedCategory,
                        onSelect: (cat) {
                          context
                              .read<WorkspaceBloc>()
                              .add(FilterWorkspacesByCategoryEvent(cat));
                          if (cat == 'Cafes' || cat == 'All') {
                            context
                                .read<CafeBloc>()
                                .add(const SearchCafesEvent(keyword: ''));
                          }
                        },
                      ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                      _SectionHeader(title: 'NEARBY PLACES', onSeeAll: _goSeeAll)
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 600.ms),
                      const SizedBox(height: 4),
                      if (selectedCategory == 'Cafes' ||
                          selectedCategory == 'All')
                        BlocBuilder<CafeBloc, CafeState>(
                          builder: (context, cafeState) {
                            if (cafeState is CafeLoading) {
                              return const _VerticalShimmer();
                            }

                            if (cafeState is CafeLoaded) {
                              if (cafeState.cafes.isEmpty) {
                                return const _EmptyView(
                                    message: 'No cafes nearby');
                              }

                              final cafes = cafeState.cafes
                                  .map((c) => CafeMapper.toWorkspaceEntity(c))
                                  .toList();
                              return _NearbyList(nearby: cafes);
                            } else if (cafeState is CafeError) {
                              return const _EmptyView(
                                  message: 'No cafes found nearby');
                            }
                            return const _VerticalShimmer();
                          },
                        )
                      else if (isMainError)
                        const _EmptyView(
                          message: 'No workspaces found',
                        )
                      else ...[
                        _NearbyList(
                          nearby: workspaces
                              .where((w) => w.type.name.toLowerCase().startsWith(
                                  selectedCategory.toLowerCase().substring(0, 3)))
                              .toList(),
                        ),
                      ],
                      if (_isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NearbyList extends StatelessWidget {
  final List<WorkspaceEntity> nearby;

  const _NearbyList({required this.nearby});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nearby.length > 8 ? 8 : nearby.length,
      itemBuilder: (context, index) {
        final w = nearby[index];
        return _NearbyCard(
          workspace: w,
          onFavTap: () => context
              .read<WorkspaceBloc>()
              .add(ToggleFavoriteWorkspaceEvent(w.id)),
        ).animate().fadeIn(delay: (index * 50).ms); 
      },
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
                      border: Border.all(
                          color: GlassTheme.glassBorder(context), width: 1.5),
                    ),
                    child: profileImage.isNotEmpty
                        ? ZinkoNetworkImage(
                            imageUrl: profileImage,
                            width: 44,
                            height: 44,
                            borderRadius: 22,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: GlassTheme.glassColor(context),
                            child: Icon(Icons.person,
                                color: GlassTheme.textColor(context))),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: GlassTheme.textColor(context))),
                    ],
                  ),
                ],
              ),
              _GlassIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen())),
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
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GlassTheme.glassBorder(context)),
        ),
        child: Icon(icon, color: GlassTheme.textColor(context), size: 22),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: GlassTheme.textColor(context),
                  letterSpacing: 1.5)),
          TextButton(
            onPressed: onSeeAll,
            child: Text('SEE ALL',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: GlassTheme.textColor(context))),
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
            onTap: () => Navigator.pushNamed(
                context, WorkspaceDetailScreen.routeName,
                arguments: w),
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    ZinkoNetworkImage(
                        imageUrl: w.imageUrl,
                        width: 280,
                        height: double.infinity,
                        borderRadius: 28),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 1.0],
                            colors: [
                              AppColors.transparent,
                              AppColors.black.withValues(alpha: 0.85)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: w.discount != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(w.discount!,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900)),
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
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: OptimizedColors.white70, size: 12),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: Text(w.location,
                                      style: const TextStyle(
                                          color: OptimizedColors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded,
                                  color: AppColors.gold, size: 14),
                              const SizedBox(width: 4),
                              Text(w.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800)),
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

  const _CategoryChips(
      {required this.categories,
      required this.selected,
      required this.onSelect});

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
                  color: isSelected
                      ? (isDark ? AppColors.white : AppColors.black)
                      : GlassTheme.glassColor(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: isSelected
                          ? (isDark ? AppColors.white : AppColors.black)
                          : GlassTheme.glassBorder(context)),
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
      onTap: () => Navigator.pushNamed(context, WorkspaceDetailScreen.routeName,
          arguments: workspace),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context).withValues(alpha: 0.2), 
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
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                    child: ZinkoNetworkImage(
                        imageUrl: workspace.imageUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _GlassFavButton(
                        isFavorite: workspace.isFavorite, onTap: onFavTap),
                  ),
                  if (workspace.isBooked)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('BOOKED',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900)),
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
                  if (workspace.price.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(workspace.name,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: GlassTheme.textColor(context),
                                  letterSpacing: -0.5),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Flexible(
                          child: Text(
                              '${workspace.price}${workspace.priceUnit}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: GlassTheme.textColor(context)),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )
                  else
                    Text(workspace.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: GlassTheme.textColor(context),
                            letterSpacing: -0.5),
                        overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 12, color: OptimizedColors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                            '${workspace.location}${workspace.distance.isNotEmpty ? ' • ${workspace.distance}' : ''}',
                            style: const TextStyle(
                                fontSize: 13,
                                color: OptimizedColors.white70,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: workspace.amenities.take(4).map((icon) {
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: GlassTheme.glassColor(context).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(icon,
                            size: 14, color: OptimizedColors.white80),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }
}

class _GlassFavButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _GlassFavButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Icon(
            isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isFavorite ? AppColors.error : AppColors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded,
                color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.5),
                size: 48),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: GlassTheme.secondaryTextColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _shimmerBox(44, 44, 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(60, 10, 4),
                    const SizedBox(height: 6),
                    _shimmerBox(120, 16, 4),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(200, 28, 4),
                const SizedBox(height: 8),
                _shimmerBox(150, 28, 4),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _HorizontalShimmer(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _shimmerBox(60, 34, 12),
                const SizedBox(width: 10),
                _shimmerBox(80, 34, 12),
                const SizedBox(width: 10),
                _shimmerBox(70, 34, 12),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _VerticalShimmer(),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height, double radius) {
    return Builder(builder: (context) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(radius),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          color: Colors.white.withValues(alpha: 0.3));
    });
  }
}

class _HorizontalShimmer extends StatelessWidget {
  const _HorizontalShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          width: 280,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(28),
          ),
        ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1200.ms,
            color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }
}

class _VerticalShimmer extends StatelessWidget {
  const _VerticalShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        height: 240,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(24),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          color: Colors.white.withValues(alpha: 0.3)),
    );
  }
}
