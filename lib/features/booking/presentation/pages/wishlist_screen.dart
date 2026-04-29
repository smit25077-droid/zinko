import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/cafe/data/mappers/cafe_mapper.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_bloc.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_event.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_state.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';

import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_event.dart';
import 'package:zinko_app/features/booking/presentation/pages/cafe_detail_screen.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:auto_skeleton/auto_skeleton.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = '/wishlist';
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      context.read<CafeBloc>().add(GetWishlistEvent(userCode: userState.user.userCode));
    }
  }

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
          child: BlocBuilder<CafeBloc, CafeState>(
            builder: (context, state) {
              if (state is CafeLoading) {
                return _buildLoadingState(context);
              }
              if (state is CafeWishlistLoaded) {
                final favorites = state.wishlist;
                if (favorites.isEmpty) return _buildEmptyState(context);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  addAutomaticKeepAlives: false,
                  itemExtent: 112,
                  itemBuilder: (context, index) {
                    final cafe = favorites[index];
                    final workspace = CafeMapper.toWorkspaceEntity(cafe);
                    return GestureDetector(
                      onTap: () {
                        // Proactively fetch latest details for this workspace
                        context.read<WorkspaceBloc>().add(GetWorkspaceDetailEvent(int.parse(workspace.id)));
                        
                        Navigator.pushNamed(
                            context, WorkspaceDetailScreen.routeName,
                            arguments: workspace);
                      },
                      child: _WishlistCard(
                        workspace: workspace,
                        onRemove: () {
                          final userState = context.read<UserBloc>().state;
                          if (userState is UserLoaded) {
                            context.read<CafeBloc>().add(ToggleWishlistEvent(
                                  cafeId: cafe.cafeId,
                                  userCode: userState.user.userCode,
                                ));
                          }
                        },
                      ).animate().fadeIn(delay: (index * 80).ms),
                    );
                  },
                );
              }
              if (state is CafeError) {
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

  Widget _buildLoadingState(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: 5,
      addAutomaticKeepAlives: false,
      itemExtent: 136, // 120 height + 16 padding
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AutoSkeleton(
          enabled: true,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
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
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: OptimizedColors.primary15,
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
          color: OptimizedColors.white05,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OptimizedColors.white10),
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}

