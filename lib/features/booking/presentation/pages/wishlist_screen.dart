import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';
import '../bloc/workspace_state.dart';
import 'workspace_detail_screen.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class WishlistScreen extends StatelessWidget {
  static const String routeName = '/wishlist';
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'WISHLIST',
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: ZinkoBackground(
        child: SafeArea(
          child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
            builder: (context, state) {
              if (state is WorkspaceLoading) {
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              }
              if (state is WorkspaceLoaded) {
                final favorites =
                    state.workspaces.where((w) => w.isFavorite).toList();
                if (favorites.isEmpty) return _buildEmptyState(context);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final workspace = favorites[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, WorkspaceDetailScreen.routeName,
                          arguments: workspace),
                      child: _WishlistCard(
                        workspace: workspace,
                        onRemove: () {
                          context
                              .read<WorkspaceBloc>()
                              .add(ToggleFavoriteWorkspaceEvent(workspace.id));
                        },
                      )
                          .animate()
                          .fadeIn(delay: (index * 80).ms)
                          ,
                    );
                  },
                );
              }
              if (state is WorkspaceError) {
                return Center(
                    child: Text(state.message,
                        style:
                            TextStyle(color: GlassTheme.textColor(context))));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_rounded,
              size: 56, color: OptimizedColors.white10),
          const SizedBox(height: 12),
          const Text(
            'EMPTY WISHLIST',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: OptimizedColors.white50,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your favorite spaces will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: OptimizedColors.white50,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Text(
                'EXPLORE SPACES',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: AppColors.white,
                    letterSpacing: 0.5),
              ),
            ),
          ).animate().scale(),
        ],
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final WorkspaceEntity workspace;
  final VoidCallback onRemove;

  const _WishlistCard({required this.workspace, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ZinkoCommonCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24)),
                  child: ZinkoNetworkImage(
                      imageUrl: workspace.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(workspace.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: OptimizedColors.white50,
                              size: 10),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(workspace.location,
                                  style: const TextStyle(
                                      color: OptimizedColors.white50,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(), // Placeholder since rating is removed
                          Text(
                            '£${workspace.price}',
                            style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: -0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.favorite_rounded,
                  color: Colors.redAccent, size: 20),
            ),
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
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}

