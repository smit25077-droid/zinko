import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_bloc.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_event.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_state.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/widgets/zinko_profile_completion_dialog.dart';
import 'dart:io' show Platform;

import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';
import 'package:zinko_app/features/booking/presentation/pages/booking_screen.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_common_bottom_sheet.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_detail_bloc.dart';

import 'package:collection/collection.dart';

class WorkspaceDetailScreen extends StatelessWidget {
  static const String routeName = '/workspace-detail';
  final WorkspaceEntity? workspace;
  final String? heroTag;

  const WorkspaceDetailScreen({
    super.key,
    this.workspace,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (workspace == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (context) => WorkspaceDetailBloc(),
      child: _DetailContent(workspace: workspace!, heroTag: heroTag),
    );
  }
}

class _DetailContent extends StatefulWidget {
  final WorkspaceEntity workspace;
  final String? heroTag;

  const _DetailContent({required this.workspace, this.heroTag});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> with WidgetsBindingObserver {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspaceDetailBloc, WorkspaceDetailState>(
      listenWhen: (prev, curr) => prev.currentPage != curr.currentPage,
      listener: (context, state) {
        if (_pageController.hasClients) {
          final currentPage = _pageController.page?.round() ?? 0;
          if (currentPage != state.currentPage) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            );
          }
        }
      },
      child: BlocBuilder<WorkspaceBloc, WorkspaceState>(
        builder: (context, state) {
          final workspace = widget.workspace;
          return Scaffold(
            extendBodyBehindAppBar: false,
            appBar: ZinkoAppBar(
              title: workspace.name,
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.2)),
                    ),
                    child: BlocBuilder<CafeBloc, CafeState>(
                      builder: (context, cafeState) {
                        bool isLiked = workspace.isFavorite;
                        if (cafeState is CafeLoaded) {
                          final c = cafeState.cafes.firstWhereOrNull(
                              (e) => e.cafeId.toString() == workspace.id);
                          if (c != null) isLiked = c.isLiked;
                        } else if (cafeState is CafeWishlistLoaded) {
                          final c = cafeState.wishlist.firstWhereOrNull(
                              (e) => e.cafeId.toString() == workspace.id);
                          if (c != null) isLiked = c.isLiked;
                        }

                        return Icon(
                          isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isLiked ? Colors.redAccent : Colors.white,
                          size: 20,
                        );
                      },
                    ),
                  ),
                  onPressed: () {
                    final userState = context.read<UserBloc>().state;
                    if (userState is UserLoaded) {
                      context.read<CafeBloc>().add(ToggleWishlistEvent(
                            cafeId: int.parse(workspace.id),
                            userCode: userState.user.userCode,
                          ));
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: ZinkoBackground(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildImageCarousel(context),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGlassHeader(),
                              if (workspace.description.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildGlassDescription(),
                              ],
                              if (workspace.amenities.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildGlassAmenities(),
                              ],
                              if (workspace.lat != 0) ...[
                                const SizedBox(height: 12),
                                _buildGlassMap(),
                              ],
                              if (workspace.reviews.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildGlassReviews(),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildActionFAB(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassHeader() {
    final workspace = widget.workspace;
    return ZinkoCommonCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${widget.heroTag ?? 'workspace_image_${workspace.id}'}_name',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      workspace.name,
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: AppColors.white50),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        workspace.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassDescription() {
    return _buildSectionCard(
      title: 'ABOUT',
      child: Text(
        widget.workspace.description,
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  Widget _buildGlassAmenities() {
    final workspace = widget.workspace;
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
        itemCount: workspace.amenities.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Icon(workspace.amenities[index], size: 14, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(workspace.amenityNames[index],
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassMap() {
    final workspace = widget.workspace;
    final position = LatLng(workspace.lat, workspace.lng);
    return _buildSectionCard(
      title: 'LOCATION',
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: position,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('workspace_pos'),
                        position: position,
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () async {
                        final encodedName = Uri.encodeComponent(workspace.name);
                        final googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=${workspace.lat},${workspace.lng}&query_place_id=$encodedName';
                        final appleUrl = 'https://maps.apple.com/?q=$encodedName&ll=${workspace.lat},${workspace.lng}';

                        if (Platform.isIOS) {
                          if (await canLaunchUrl(Uri.parse(appleUrl))) {
                            await launchUrl(Uri.parse(appleUrl));
                          }
                        } else {
                          if (await canLaunchUrl(Uri.parse(googleUrl))) {
                            await launchUrl(Uri.parse(googleUrl));
                          }
                        }
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.directions_rounded, size: 16, color: AppColors.secondary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tap to get directions in your map app',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: OptimizedColors.white50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassReviews() {
    final workspace = widget.workspace;
    if (workspace.reviews.isEmpty) return const SizedBox.shrink();
    final reviewsToShow = workspace.reviews.take(3).toList();
    final hasMore = workspace.reviews.length > 3;

    return _buildSectionCard(
      title: 'REVIEWS',
      child: Column(
        children: [
          ...reviewsToShow.map((r) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: GlassTheme.textColor(context).withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: GlassTheme.glassBorder(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(r.avatarUrl),
                          backgroundColor: AppColors.backgroundDark,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.userName,
                                  style: TextStyle(
                                      color: GlassTheme.textColor(context),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800)),
                              Text(r.date,
                                  style: TextStyle(
                                      color: GlassTheme.tertiaryTextColor(context),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        _buildCompactRatingBadge(r.rating, isSmall: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(r.comment,
                        style: TextStyle(
                            color: GlassTheme.textColor(context).withValues(alpha: 0.8),
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
          if (hasMore) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _showAllReviews(context, workspace.reviews),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                ),
                child: Center(
                  child: Text(
                    'SEE ALL ${workspace.reviews.length} REVIEWS',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(),
          ],
        ],
      ),
    );
  }

  void _showAllReviews(BuildContext context, List<WorkspaceReviewEntity> reviews) {
    ZinkoCommonBottomSheet.show(
      context: context,
      title: 'ALL REVIEWS',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${reviews.length} total',
                style: TextStyle(
                  color: AppColors.white50,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              physics: const BouncingScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final r = reviews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(r.avatarUrl),
                            backgroundColor: AppColors.backgroundDark,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.userName,
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800)),
                                Text(r.date,
                                    style: TextStyle(
                                        color: OptimizedColors.white50,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          _buildCompactRatingBadge(r.rating, isSmall: true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(r.comment,
                          style: TextStyle(
                              color: AppColors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return ZinkoCommonCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    final workspace = widget.workspace;
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => context
                .read<WorkspaceDetailBloc>()
                .add(UpdatePageIndex(index)),
            itemCount: workspace.images.isEmpty ? 1 : workspace.images.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: widget.heroTag ?? 'workspace_image_${workspace.id}',
                child: ZinkoNetworkImage(
                  imageUrl: workspace.images.isEmpty
                      ? workspace.imageUrl
                      : workspace.images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          if (workspace.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: BlocBuilder<WorkspaceDetailBloc, WorkspaceDetailState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: workspace.images.asMap().entries.map((entry) {
                      bool isSelected = state.currentPage == entry.key;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 24 : 8,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      blurRadius: 4)
                                ]
                              : [],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactRatingBadge(double rating, {bool isSmall = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8, vertical: isSmall ? 3 : 5),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
                color: AppColors.white, fontSize: isSmall ? 11 : 13, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFAB(BuildContext context) {
    final workspace = widget.workspace;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          if (workspace.price.isNotEmpty)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STARTING FROM',
                      style: TextStyle(
                          color: AppColors.white50,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0)),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '£${workspace.price}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.white)),
                        TextSpan(
                            text: ' /h',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white50)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              final userState = context.read<UserBloc>().state;
              if (userState is UserLoaded && !userState.user.isProfileComplete) {
                ZinkoProfileCompletionDialog.show(context, userState.user);
                return;
              }
              Navigator.pushNamed(context, BookingScreen.routeName, arguments: {
                'workspaceId': workspace.id,
                'workspaceName': workspace.name,
                'workspace': workspace,
              });
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  'BOOK NOW',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2),
                ),
              ),
            ),
          ).animate().scale(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}