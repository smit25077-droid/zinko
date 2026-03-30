import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';
import '../bloc/workspace_state.dart';
import 'workspace_detail_screen.dart';
import '../../../../utils/glass_theme.dart';

class AllWorkspacesScreen extends StatelessWidget {
  static const String routeName = '/all-workspaces';
  const AllWorkspacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cafe_hotel_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: GlassTheme.backgroundOverlay(context)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: GlassTheme.glassColor(context),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: GlassTheme.glassBorder(context)),
                        ),
                        child: TextField(
                          onChanged: (val) => context
                              .read<WorkspaceBloc>()
                              .add(SearchWorkspacesEvent(val)),
                          style: TextStyle(
                              color: GlassTheme.textColor(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: 'Search office, cafe, location...',
                            hintStyle: TextStyle(
                                color: GlassTheme.secondaryTextColor(context)
                                    .withOpacity(0.3),
                                fontSize: 13),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: GlassTheme.iconColor(context)
                                    .withOpacity(0.4),
                                size: 20),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
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
                        return Center(
                            child: CircularProgressIndicator(
                                color: GlassTheme.textColor(context)));
                      } else if (state is WorkspaceLoaded) {
                        final query = state.searchQuery.toLowerCase();
                        final filtered = state.workspaces
                            .where((p) =>
                                p.name.toLowerCase().contains(query) ||
                                p.location.toLowerCase().contains(query))
                            .toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text('No workspaces found',
                                style: TextStyle(
                                    color:
                                        GlassTheme.secondaryTextColor(context)
                                            .withOpacity(0.5))),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filtered.length,
                          itemBuilder: (ctx, i) {
                            final workspace = filtered[i];
                            return _WorkspaceCard(
                              workspace: workspace,
                              onFavTap: () => context.read<WorkspaceBloc>().add(
                                  ToggleFavoriteWorkspaceEvent(workspace.id)),
                            );
                          },
                        );
                      } else if (state is WorkspaceError) {
                        return Center(
                            child: Text(state.message,
                                style: TextStyle(
                                    color: GlassTheme.textColor(context))));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
      onTap: () => Navigator.pushNamed(context, WorkspaceDetailScreen.routeName,
          arguments: workspace),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: GlassTheme.glassBorder(context)),
              boxShadow: [GlassTheme.glassShadow(context)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        child: Image.network(
                          workspace.imageUrl,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              color: GlassTheme.glassColor(context),
                              height: 160),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _GlassFavButton(
                            isFavorite: workspace.isFavorite, onTap: onFavTap),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: GlassTheme.textColor(context),
                                      letterSpacing: -0.5))),
                          _RatingBadge(rating: workspace.rating),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14,
                              color: GlassTheme.secondaryTextColor(context)
                                  .withOpacity(0.4)),
                          const SizedBox(width: 4),
                          Text('${workspace.location} • ${workspace.distance}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: GlassTheme.secondaryTextColor(context)
                                      .withOpacity(0.4),
                                  fontWeight: FontWeight.w600)),
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
                                          color: GlassTheme.textColor(context)
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Icon(icon,
                                          size: 14,
                                          color: GlassTheme.iconColor(context)
                                              .withOpacity(0.7)),
                                    ))
                                .toList(),
                          ),
                          Text(
                            '${workspace.price}${workspace.priceUnit}',
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
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context).withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color:
                  isFavorite ? Colors.redAccent : GlassTheme.iconColor(context),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: GlassTheme.glassColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GlassTheme.glassBorder(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amberAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: GlassTheme.textColor(context)),
          ),
        ],
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}
