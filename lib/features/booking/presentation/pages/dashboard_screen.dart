import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/booking/presentation/pages/all_workspaces_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/workspace_detail_screen.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:zinko_app/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_bloc.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_event.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_state.dart';
import 'package:zinko_app/features/cafe/data/mappers/cafe_mapper.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_empty_state.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserInitial || userState is UserError) {
      context.read<UserBloc>().add(GetUserProfileEvent());
    }
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

  void _goSeeAll() => Navigator.pushNamed(context, AllWorkspacesScreen.routeName);

  @override
  Widget build(BuildContext context) {
    return ZinkoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
            buildWhen: (p, c) => c is WorkspaceLoading || c is WorkspaceLoaded || c is WorkspaceError,
            builder: (context, state) {
              if (state is WorkspaceLoading) return const _DashboardShimmer();

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                backgroundColor: GlassTheme.glassColor(context),
                child: ZinkoScrollBody(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        buildWhen: (p, c) => c is UserLoaded || c is UserError,
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
                                        border: Border.all(color: OptimizedColors.glassBorderLight, width: 1.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: OptimizedColors.black10,
                                            blurRadius: 10,
                                          )
                                        ],
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
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.backgroundDark,
                                          ),
                                          child: const Icon(Icons.person, color: AppColors.white)),
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
                      ),

                      Padding(
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
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Hero(
                          tag: 'search_bar',
                          child: Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: _goSeeAll,
                              child: ZinkoGlassBox(
                                blur: 15,
                                borderRadius: 18,
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search_rounded,
                                          color: GlassTheme.iconColor(context).withValues(alpha: 0.4), size: 20),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Search office, cafe, location...',
                                        style: TextStyle(
                                            color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.3),
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SectionHeader(title: 'RECOMMENDED', onSeeAll: _goSeeAll),
                      BlocBuilder<CafeBloc, CafeState>(
                        buildWhen: (p, c) => c is CafeLoading || c is CafeLoaded || c is CafeError,
                        builder: (context, cafeState) {
                          if (cafeState is CafeLoading) return const _HorizontalShimmer();
                          if (cafeState is CafeLoaded) {
                            if (cafeState.cafes.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: ZinkoEmptyState(
                                  title: 'No Recommendations',
                                  message: 'Check back later for curated spaces.',
                                ),
                              );
                            }
                            final recommended = cafeState.cafes.map((c) => CafeMapper.toWorkspaceEntity(c)).toList();
                            return _RecommendedList(
                              workspaces: recommended,
                              onFavTap: (id) {
                                final userState = context.read<UserBloc>().state;
                                if (userState is UserLoaded) {
                                  context.read<CafeBloc>().add(ToggleWishlistEvent(
                                        cafeId: int.parse(id),
                                        userCode: userState.user.userCode,
                                      ));
                                }
                              },
                            );
                          }
                          return const _HorizontalShimmer();
                        },
                      ),
                      const SizedBox(height: 12),
                      _SectionHeader(
                        title: 'NEARBY PLACES',
                        onSeeAll: _goSeeAll,
                        trailing: _FilterAction(
                          onTap: () {
                            // TODO: Implement filter bottom sheet
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<CafeBloc, CafeState>(
                        buildWhen: (p, c) => c is CafeLoading || c is CafeLoaded || c is CafeError,
                        builder: (context, cafeState) {
                          if (cafeState is CafeLoading) return const _VerticalShimmer();
                          if (cafeState is CafeLoaded) {
                            if (cafeState.cafes.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: ZinkoEmptyState(
                                  title: 'No Spaces Found',
                                  message: 'Check back later for newly added spots.',
                                ),
                              );
                            }

                            final nearbyEntities = cafeState.cafes.map((c) => CafeMapper.toWorkspaceEntity(c)).toList();
                            return _NearbyList(
                              nearby: nearbyEntities,
                              onFavTap: (id) {
                                final userState = context.read<UserBloc>().state;
                                if (userState is UserLoaded) {
                                  context.read<CafeBloc>().add(ToggleWishlistEvent(
                                        cafeId: int.parse(id),
                                        userCode: userState.user.userCode,
                                      ));
                                }
                              },
                            );
                          }

                          if (cafeState is CafeError) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child: ZinkoEmptyState(
                                title: 'Nothing Found',
                                message: 'We encountered an error loading spaces. Please try again.',
                              ),
                            );
                          }

                          return const _VerticalShimmer();
                        },
                      ),
                      if (_isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white)),
                        ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NearbyList extends StatelessWidget {
  final List<WorkspaceEntity> nearby;
  final Function(String)? onFavTap;

  const _NearbyList({required this.nearby, this.onFavTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(
          nearby.length > 8 ? 8 : nearby.length,
          (index) {
            final w = nearby[index];
            return _NearbyCard(
              workspace: w,
              onFavTap: () => onFavTap != null
                  ? onFavTap!(w.id)
                  : context.read<WorkspaceBloc>().add(ToggleFavoriteWorkspaceEvent(w.id)),
            ).animate().fadeIn(delay: (index * 30).ms);
          },
        ),
      ),
    );
  }
}


class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ZinkoCommonCard(
      width: 44,
      height: 44,
      borderRadius: 14,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Center(
        child: Icon(icon, color: AppColors.white, size: 22),
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final Widget? trailing;

  const _SectionHeader({required this.title, required this.onSeeAll, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: GlassTheme.textColor(context),
                      letterSpacing: 1.5)),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: workspaces.length,
        itemExtent: 300,
        addAutomaticKeepAlives: false,
        itemBuilder: (_, i) {
          final w = workspaces[i];
          return ZinkoCommonCard(
            width: 280,
            margin: const EdgeInsets.only(right: 20),
            padding: EdgeInsets.zero,
          onTap: () {
            final tag = 'hero_rec_${w.id}';
            Navigator.pushNamed(
              context,
              WorkspaceDetailScreen.routeName,
              arguments: {
                'workspace': w,
                'heroTag': tag,
              },
            );
          },
          child: Stack(
            children: [
              Hero(
                tag: 'hero_rec_${w.id}',
                child: ZinkoNetworkImage(imageUrl: w.imageUrl, width: 280, height: double.infinity, borderRadius: 24),
              ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [AppColors.transparent, AppColors.backgroundDark.withValues(alpha: 0.9)],
                      ),
                    ),
                  ),
                ),
                const SizedBox(),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'hero_rec_${w.id}_name',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(w.name,
                              style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppColors.white, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(w.location,
                                  style: const TextStyle(
                                      color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 8),
                          Text('£${w.price}',
                              style:
                                  const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
    return ZinkoCommonCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      onTap: () {
        final tag = 'hero_nearby_${workspace.id}';
        Navigator.pushNamed(
          context,
          WorkspaceDetailScreen.routeName,
          arguments: {
            'workspace': workspace,
            'heroTag': tag,
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Hero(
                    tag: 'hero_nearby_${workspace.id}',
                    child: ZinkoNetworkImage(
                        imageUrl: workspace.imageUrl, width: double.infinity, height: 140, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _GlassFavButton(isFavorite: workspace.isFavorite, onTap: onFavTap),
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
                        child: Hero(
                          tag: 'hero_nearby_${workspace.id}_name',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(workspace.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text('£${workspace.price}',
                            style:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.secondary),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )
                else
                  Hero(
                    tag: 'hero_nearby_${workspace.id}_name',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(workspace.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 12, color: OptimizedColors.white70),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(workspace.location,
                          style: const TextStyle(
                              fontSize: 13, color: OptimizedColors.white70, fontWeight: FontWeight.w600),
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
                          color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(icon, size: 14, color: AppColors.secondary),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
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
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite ? AppColors.error : AppColors.white,
            size: 18,
          ),
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
                    const SizedBox(height: 4),
                    _shimmerBox(120, 16, 4),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _shimmerBox(220, 60, 4),
          ),
          const SizedBox(height: 40),
          _shimmerHorizontalList(),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _shimmerBox(double.infinity, 120, 24),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(double w, double h, double r) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(r),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
  }

  Widget _shimmerHorizontalList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 3,
        itemExtent: 300,
        addAutomaticKeepAlives: false,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(right: 20),
          child: _shimmerBox(280, 200, 24),
        ),
      ),
    );
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
        itemExtent: 300,
        addAutomaticKeepAlives: false,
        itemBuilder: (_, __) => Container(
          width: 280,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: OptimizedColors.white04,
            borderRadius: BorderRadius.circular(24),
          ),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms),
      ),
    );
  }
}

class _VerticalShimmer extends StatelessWidget {
  const _VerticalShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(
            3,
            (index) => Container(
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms)),
      ),
    );
  }
}

class _FilterAction extends StatelessWidget {
  final VoidCallback onTap;

  const _FilterAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.tune_rounded, size: 14, color: AppColors.secondary),
      ),
    );
  }
}
