import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/widgets/zinko_empty_state.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';
import 'package:zinko_app/features/booking/presentation/pages/workspace_detail_screen.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_glass_box.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';

class AllWorkspacesScreen extends StatefulWidget {
  static const String routeName = '/all-workspaces';
  const AllWorkspacesScreen({super.key});

  @override
  State<AllWorkspacesScreen> createState() => _AllWorkspacesScreenState();
}

class _AllWorkspacesScreenState extends State<AllWorkspacesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkspaceBloc>().add(const SearchWorkspacesEvent(''));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ZinkoBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _GlassHeaderButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'ALL WORKSPACES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: GlassTheme.textColor(context),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Hero(
                  tag: 'search_bar',
                  child: Material(
                    color: Colors.transparent,
                    child: ZinkoGlassBox(
                      blur: 15,
                      borderRadius: 18,
                      child: SizedBox(
                        height: 52,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => context.read<WorkspaceBloc>().add(SearchWorkspacesEvent(val)),
                          style: TextStyle(
                              color: GlassTheme.textColor(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: 'Search office, cafe, location...',
                            hintStyle: TextStyle(
                                color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.3),
                                fontSize: 13),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: GlassTheme.iconColor(context).withValues(alpha: 0.4),
                                size: 20),
                            suffixIcon: ValueListenableBuilder(
                              valueListenable: _searchController,
                              builder: (context, value, _) {
                                return value.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear_rounded,
                                            color: GlassTheme.iconColor(context).withValues(alpha: 0.4),
                                            size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          context.read<WorkspaceBloc>().add(const SearchWorkspacesEvent(''));
                                        },
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
                  builder: (context, state) {
                    if (state is WorkspaceLoading) {
                      return const _WorkspaceShimmer();
                    } else if (state is WorkspaceLoaded) {
                      final query = state.searchQuery.toLowerCase();
                      final bool useLocalFiltering = query.isNotEmpty && query.length < 3;

                      final filtered = useLocalFiltering
                          ? state.workspaces
                              .where((p) =>
                                  p.name.toLowerCase().contains(query) ||
                                  p.location.toLowerCase().contains(query))
                              .toList()
                          : state.workspaces;

                      if (filtered.isEmpty) {
                        return ZinkoEmptyState(
                          title: 'NO MATCHES FOUND',
                          message: 'We couldn\'t find anything matching "${state.searchQuery}".',
                          onRetry: () {
                             _searchController.clear();
                             context.read<WorkspaceBloc>().add(const SearchWorkspacesEvent(''));
                          },
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final workspace = filtered[i];
                          return _WorkspaceCard(
                            workspace: workspace,
                            onFavTap: () => context
                                .read<WorkspaceBloc>()
                                .add(ToggleFavoriteWorkspaceEvent(workspace.id)),
                          );
                        },
                      );
                    } else if (state is WorkspaceError) {
                      return ZinkoEmptyState(
                        title: 'OOPS!',
                        message: state.message,
                        icon: Icons.error_outline_rounded,
                        onRetry: () => context
                                  .read<WorkspaceBloc>()
                                  .add(const SearchWorkspacesEvent('')),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspaceShimmer extends StatelessWidget {
  const _WorkspaceShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ZinkoGlassBox.light(
        useBlur: false,
        child: SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
              ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                  duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 200,
                      decoration: BoxDecoration(
                        color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                        duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(height: 10),
                    Container(
                      height: 14,
                      width: 150,
                      decoration: BoxDecoration(
                        color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                        duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                              3,
                              (index) => Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                                      duration: 1200.ms,
                                      color: Colors.white.withValues(alpha: 0.3))),
                        ),
                        Container(
                          height: 20,
                          width: 60,
                          decoration: BoxDecoration(
                            color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                            duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3)),
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
  }
}

class _WorkspaceCard extends StatelessWidget {
  final WorkspaceEntity workspace;
  final VoidCallback onFavTap;

  const _WorkspaceCard({required this.workspace, required this.onFavTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final tag = 'hero_all_${workspace.id}';
        Navigator.pushNamed(
          context,
          WorkspaceDetailScreen.routeName,
          arguments: {
            'workspace': workspace,
            'heroTag': tag,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ZinkoGlassBox.light(
          useBlur: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'hero_all_${workspace.id}',
                      child: ZinkoNetworkImage(
                        imageUrl: workspace.imageUrl,
                        width: double.infinity,
                        height: 160,
                        borderRadius: 24,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Hero(
                          tag: 'hero_all_${workspace.id}_name',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(workspace.name,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: GlassTheme.textColor(context),
                                    letterSpacing: -0.5)),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 14,
                            color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(workspace.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: workspace.amenities
                              .take(3)
                              .map((icon) => Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: GlassTheme.textColor(context).withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(icon,
                                        size: 14, color: GlassTheme.iconColor(context).withValues(alpha: 0.7)),
                                  ))
                              .toList(),
                        ),
                        Text(
                          '£${workspace.price}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: GlassTheme.textColor(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}

class _GlassFavButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const _GlassFavButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite ? Colors.redAccent : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}



class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassHeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ZinkoGlassBox.light(
        borderRadius: 12,
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
        ),
      ),
    );
  }
}
