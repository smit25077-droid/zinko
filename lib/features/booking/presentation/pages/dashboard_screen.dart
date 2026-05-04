import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/booking/presentation/pages/search_cafe_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/cafe_detail_screen.dart';
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
    // Only fetch user profile if it's not already loaded or in progress
    final userState = context.read<UserBloc>().state;
    if (userState is UserInitial || userState is UserError) {
      context.read<UserBloc>().add(GetUserProfileEvent());
    }

    // Only fetch workspaces if it's the first time
    if (context.read<WorkspaceBloc>().state is WorkspaceInitial) {
      context.read<WorkspaceBloc>().add(GetWorkspacesEvent());
    }

    // Only fetch cafes if it's the first time
    if (context.read<CafeBloc>().state is CafeInitial) {
      context.read<CafeBloc>().add(const SearchCafesEvent(keyword: ''));
    }
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
                          String gender = 'male';

                          if (state is UserLoaded) {
                            firstName = state.user.name.split(' ').first;
                            profileImage = state.user.profileImage;
                            gender = state.user.gender.toLowerCase();
                          }

                          return Padding(
                            padding: CommonUtil.pHor24Ver8,
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadiusGeometry.all(Radius.circular(CommonUtil.s24)),
                                        child: Image.asset(
                                                gender == 'female'
                                                    ? 'assets/images/female_user.png'
                                                    : 'assets/images/male_user.png',
                                                width: 44,
                                                height: 44,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    CommonUtil.hGap12,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('GOOD DAY',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                color: OptimizedColors.white50,
                                                letterSpacing: 1.2)),
                                        Text(firstName.toUpperCase(),
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
                                      context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: CommonUtil.pH24,
                        child: Text(
                          'SKIP THE WAIT\nBOOK WITH ZINKO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: GlassTheme.textColor(context),
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      CommonUtil.vGap16,
                      Padding(
                        padding: CommonUtil.pH16,
                        child: Hero(
                          tag: 'search_bar',
                          child: Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: _goSeeAll,
                              child: ZinkoGlassBox(
                                blur: 15,
                                borderRadius: CommonUtil.r18,
                                child: Container(
                                  height: 52,
                                  padding: CommonUtil.pH16,
                                  child: Row(
                                    children: [
                                      Icon(Icons.search_rounded,
                                          color: OptimizedColors.white40, size: 20),
                                      CommonUtil.hGap12,
                                      Text(
                                        'Search office, cafe, location...',
                                        style: TextStyle(
                                            color: OptimizedColors.white30,
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
                      CommonUtil.vGap8,
                      _SectionHeader(
                        title: 'RECOMMENDED',
                      ),
                      BlocBuilder<CafeBloc, CafeState>(
                        buildWhen: (p, c) => c is CafeLoading || c is CafeLoaded || c is CafeError,
                        builder: (context, cafeState) {
                          if (cafeState is CafeLoading) return const _HorizontalShimmer();
                          if (cafeState is CafeLoaded) {
                            if (cafeState.cafes.isEmpty) {
                              return const Padding(
                                padding: CommonUtil.pV40,
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
                      CommonUtil.vGap12,
                      _SectionHeader(
                        title: 'NEARBY PLACES',
                      ),
                      CommonUtil.vGap4,
                      BlocBuilder<CafeBloc, CafeState>(
                        buildWhen: (p, c) => c is CafeLoading || c is CafeLoaded || c is CafeError,
                        builder: (context, cafeState) {
                          if (cafeState is CafeLoading) return const _VerticalShimmer();
                          if (cafeState is CafeLoaded) {
                            if (cafeState.cafes.isEmpty) {
                              return const Padding(
                                padding: CommonUtil.pV40,
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
                          padding: CommonUtil.pV24,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white)),
                        ),
                      CommonUtil.vGap100,
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
      padding: CommonUtil.pH16,
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
      borderRadius: CommonUtil.r14,
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
  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CommonUtil.pLTRB24_8_16_4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: GlassTheme.textColor(context),
                  letterSpacing: 1.5)),
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
        padding: CommonUtil.pH16,
        itemCount: workspaces.length,
        itemExtent: 300,
        addAutomaticKeepAlives: false,
        itemBuilder: (_, i) {
          final w = workspaces[i];
          return ZinkoCommonCard(
            width: 280,
            margin: CommonUtil.pRight20,
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
                  child: ZinkoNetworkImage(imageUrl: w.imageUrl, width: 280, height: double.infinity, borderRadius: CommonUtil.r24),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [AppColors.transparent, OptimizedColors.backgroundDark70],
                      ),
                    ),
                  ),
                ),
                const SizedBox(),
                Positioned(
                  bottom: CommonUtil.s20,
                  left: CommonUtil.s20,
                  right: CommonUtil.s20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'hero_rec_${w.id}_name',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(w.name,
                              style:
                                  const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        ),
                      ),
                      CommonUtil.vGap4,
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppColors.white, size: 12),
                          CommonUtil.hGap4,
                          Expanded(
                              child: Text(w.location,
                                  style: const TextStyle(
                                      color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis)),
                          CommonUtil.hGap8,
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
      margin: CommonUtil.pBottom16,
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
                  top: CommonUtil.s12,
                  right: CommonUtil.s12,
                  child: _GlassFavButton(isFavorite: workspace.isFavorite, onTap: onFavTap),
                ),
              ],
            ),
          ),
          Padding(
            padding: CommonUtil.pAll16,
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.white,
                                    letterSpacing: -0.5),
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
                CommonUtil.vGap6,
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 12, color: OptimizedColors.white70),
                    CommonUtil.hGap4,
                    Expanded(
                      child: Text(workspace.location,
                          style: const TextStyle(
                              fontSize: 13, color: OptimizedColors.white70, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ),
                  ],
                ),
                CommonUtil.vGap12,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: workspace.amenities.take(4).map((icon) {
                    return Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: OptimizedColors.primary08, borderRadius: CommonUtil.bRadius8),
                      child:  Icon(icon, size: 14, color: AppColors.secondary),
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
          CommonUtil.vGap20,
          Padding(
            padding: CommonUtil.pH16V12,
            child: Row(
              children: [
                _shimmerBox(44, 44, 22),
                CommonUtil.hGap12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(60, 10, 4),
                    CommonUtil.vGap4,
                    _shimmerBox(120, 16, 4),
                  ],
                ),
              ],
            ),
          ),
          CommonUtil.vGap32,
          Padding(
            padding: CommonUtil.pH24,
            child: _shimmerBox(220, 60, 4),
          ),
          CommonUtil.vGap40,
          _shimmerHorizontalList(),
          CommonUtil.vGap40,
          Padding(
            padding: CommonUtil.pH24,
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
        color: OptimizedColors.white05,
        borderRadius: BorderRadius.circular(r),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
  }

  Widget _shimmerHorizontalList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: CommonUtil.pH24,
        itemCount: 3,
        itemExtent: 300,
        addAutomaticKeepAlives: false,
        itemBuilder: (_, __) => Padding(
          padding: CommonUtil.pRight20,
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
        padding: CommonUtil.pH24,
        itemCount: 3,
        itemExtent: 300,
        addAutomaticKeepAlives: false,
        itemBuilder: (_, __) => Container(
          width: 280,
          margin: CommonUtil.pRight20,
          decoration: BoxDecoration(
            color: OptimizedColors.white04,
            borderRadius: CommonUtil.bRadius24,
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
      padding: CommonUtil.pH24,
      child: Column(
        children: List.generate(
            3,
            (index) => Container(
                  height: 180,
                  margin: CommonUtil.pBottom16,
                  decoration: BoxDecoration(
                    color: OptimizedColors.white05,
                    borderRadius: CommonUtil.bRadius24,
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms)),
      ),
    );
  }
}


