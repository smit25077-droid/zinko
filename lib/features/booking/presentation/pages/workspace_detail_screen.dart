import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';
import '../bloc/workspace_state.dart';
import 'booking_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/optimized_colors.dart';

class WorkspaceDetailScreen extends StatefulWidget {
  static const String routeName = '/workspace-detail';
  final WorkspaceEntity? workspace;

  const WorkspaceDetailScreen({
    super.key,
    this.workspace,
  });

  @override
  State<WorkspaceDetailScreen> createState() => _WorkspaceDetailScreenState();
}

class _WorkspaceDetailScreenState extends State<WorkspaceDetailScreen> {
  late WorkspaceEntity _workspace;

  @override
  void initState() {
    super.initState();
    if (widget.workspace == null) {
      Navigator.pop(context);
    } else {
      _workspace = widget.workspace!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      builder: (context, state) {
        if (state is WorkspaceLoaded) {
          final updated = state.workspaces.firstWhere(
              (w) => w.id == _workspace.id,
              orElse: () => _workspace);
          _workspace = updated;
        }

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
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: GlassTheme.backgroundOverlay(context)),
                ),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGlassHeader(),
                          const SizedBox(height: 12),
                          _buildGlassStatsRow(),
                          const SizedBox(height: 12),
                          _buildGlassDescription(),
                          const SizedBox(height: 12),
                          _buildGlassPerks(),
                          const SizedBox(height: 12),
                          _buildGlassAmenities(),
                          const SizedBox(height: 12),
                          _buildGlassReviews(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildActionFAB(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
            boxShadow: [GlassTheme.glassShadow(context)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _workspace.name,
                      style: TextStyle(
                        fontSize: 22,
                        color: GlassTheme.textColor(context),
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.1),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 14, color: OptimizedColors.white60),
                        const SizedBox(width: 4),
                        Text(
                          '${_workspace.location} • ${_workspace.distance}',
                          style: TextStyle(
                            fontSize: 12,
                            color: OptimizedColors.white60,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildCompactRatingBadge(_workspace.rating),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassStatsRow() {
    return Row(
      children: [
        _buildStatCard('AVAL. TABLES', '${_workspace.tablesLeft}', Icons.chair_alt_rounded),
        const SizedBox(width: 12),
        _buildStatCard('TOTAL SLOTS', '${_workspace.totalSlots}', Icons.people_rounded),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: OptimizedColors.white60),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: TextStyle(color: GlassTheme.textColor(context), fontSize: 16, fontWeight: FontWeight.w900)),
                    Text(label, style: TextStyle(color: OptimizedColors.white50, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDescription() {
    return _buildSectionCard(
      title: 'ABOUT',
      child: Text(
        _workspace.description,
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: OptimizedColors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGlassPerks() {
    return _buildSectionCard(
      title: 'SPECIAL PERKS',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _workspace.perkTags.map((perk) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flash_on_rounded, size: 12, color: Colors.orange),
              const SizedBox(width: 4),
              Text(perk, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w800, fontSize: 10)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildGlassAmenities() {
    return _buildSectionCard(
      title: 'AMENITIES',
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _workspace.amenities.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: GlassTheme.textColor(context).withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Row(
              children: [
                Icon(_workspace.amenities[index], size: 14, color: OptimizedColors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_workspace.amenityNames[index], style: TextStyle(fontSize: 11, color: OptimizedColors.white90, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassReviews() {
    if (_workspace.reviews.isEmpty) return const SizedBox.shrink();
    return _buildSectionCard(
      title: 'REVIEWS',
      child: Column(
        children: _workspace.reviews.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GlassTheme.textColor(context).withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 14, backgroundImage: NetworkImage(r.avatarUrl)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.userName, style: TextStyle(color: GlassTheme.textColor(context), fontSize: 13, fontWeight: FontWeight.w800)),
                        Text(r.timeAgo, style: TextStyle(color: OptimizedColors.white50, fontSize: 9, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  _buildCompactRatingBadge(r.rating, isSmall: true),
                ],
              ),
              const SizedBox(height: 8),
              Text(r.comment, style: TextStyle(color: OptimizedColors.white80, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: OptimizedColors.white50, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _GlassAppBarButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassAppBarButton(
            icon: _workspace.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _workspace.isFavorite ? Colors.redAccent : null,
            onTap: () {
              context.read<WorkspaceBloc>().add(ToggleFavoriteWorkspaceEvent(_workspace.id));
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(_workspace.imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2)
                  ]
                )
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRatingBadge(double rating, {bool isSmall = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8, vertical: isSmall ? 3 : 5),
      decoration: BoxDecoration(
        color: GlassTheme.glassColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GlassTheme.glassBorder(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(color: GlassTheme.textColor(context), fontSize: isSmall ? 11 : 13, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFAB(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          decoration: BoxDecoration(
            color: GlassTheme.backgroundOverlay(context),
            border: Border(top: BorderSide(color: GlassTheme.glassBorder(context))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STARTING FROM', style: TextStyle(color: OptimizedColors.white50, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: _workspace.price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: GlassTheme.textColor(context))),
                          TextSpan(text: ' ${_workspace.priceUnit}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: OptimizedColors.white50)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, BookingScreen.routeName, arguments: {'workspaceId': _workspace.id, 'workspaceName': _workspace.name});
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: GlassTheme.textColor(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'BOOK NOW', 
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 1.0
                    )
                  ),
                ),
              ).animate().scale(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassAppBarButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  const _GlassAppBarButton({required this.icon, this.color, required this.onTap});

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
              color: GlassTheme.glassColor(context).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: color ?? GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}
