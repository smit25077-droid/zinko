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
import 'package:zinko_app/utils/common_util.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/widgets/zinko_profile_completion_dialog.dart';
import 'dart:io' show Platform;

import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_state.dart';
import 'package:zinko_app/features/booking/presentation/pages/booking_screen.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_detail_bloc.dart';

import 'package:collection/collection.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zinko_app/features/feedback/presentation/pages/cafe_reviews_screen.dart';

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
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      buildWhen: (prev, curr) {
        if (curr is WorkspaceLoaded) {
          // Only rebuild if the current workspace we're viewing has changed
          final oldW =
              (prev is WorkspaceLoaded) ? prev.workspaces.firstWhereOrNull((w) => w.id == widget.workspace.id) : null;
          final newW = curr.workspaces.firstWhereOrNull((w) => w.id == widget.workspace.id);
          return oldW != newW;
        }
        return false;
      },
      builder: (context, state) {
        final workspace = (state is WorkspaceLoaded)
            ? state.workspaces.firstWhereOrNull((w) => w.id == widget.workspace.id) ?? widget.workspace
            : widget.workspace;

        return Scaffold(
          appBar: ZinkoAppBar(
            title: workspace.name,
            actions: [
              _FavoriteButton(workspace: workspace),
              const SizedBox(width: 8),
            ],
          ),
          body: ZinkoBackground(
            child: ZinkoScrollBody(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _ImageCarousel(
                    workspace: workspace,
                    heroTag: widget.heroTag,
                    carouselController: _carouselController,
                  ),
                  Padding(
                    padding: CommonUtil.pAll16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGlassHeader(workspace),
                        if (workspace.description.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildGlassDescription(workspace),
                        ],
                        if (workspace.amenities.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildGlassAmenities(workspace),
                        ],
                        if (workspace.lat != 0) ...[
                          const SizedBox(height: 12),
                          _buildGlassMap(workspace),
                        ],
                        if (workspace.reviews.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildGlassReviews(workspace),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildActionFAB(context, workspace),
        );
      },
    );
  }

  Widget _buildGlassHeader(WorkspaceEntity workspace) {
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
                ).animate().fadeIn(duration: 250.ms),
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

  Widget _buildGlassDescription(WorkspaceEntity workspace) {
    return _buildSectionCard(
      title: 'ABOUT',
      child: Text(
        workspace.description,
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGlassAmenities(WorkspaceEntity workspace) {
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
              color: OptimizedColors.white04,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OptimizedColors.white05),
            ),
            child: Row(
              children: [
                Icon(workspace.amenities[index], size: 14, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(workspace.amenityNames[index],
                      style: const TextStyle(fontSize: 11, color: AppColors.white, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassMap(WorkspaceEntity workspace) {
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

  Widget _buildGlassReviews(WorkspaceEntity workspace) {
    List<WorkspaceReviewEntity> reviews = workspace.reviews;
    if (reviews.isEmpty) return const SizedBox.shrink();
    final reviewsToShow = reviews.take(3).toList();
    final hasMore = reviews.length > 3;

    return _buildSectionCard(
      title: 'REVIEWS',
      child: Column(
        children: [
          ...reviewsToShow.map((r) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CafeReviewsScreen.routeName,
                    arguments: {
                      'cafeId': int.tryParse(workspace.id) ?? 0,
                      'cafeName': workspace.name,
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: OptimizedColors.white05,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: OptimizedColors.white08),
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
                                    style: const TextStyle(
                                        color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                                Text(r.date,
                                    style: const TextStyle(
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
                          style: const TextStyle(
                              color: OptimizedColors.white80,
                              fontSize: 12,
                              height: 1.5,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              )),
          if (hasMore) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CafeReviewsScreen.routeName,
                  arguments: {
                    'cafeId': int.tryParse(workspace.id) ?? 0,
                    'cafeName': workspace.name,
                  },
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: OptimizedColors.primary08,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: OptimizedColors.primary25),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SEE ALL REVIEWS',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 250.ms),
          ],
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

  // Widget _buildImageCarousel(BuildContext context) {
  //   final workspace = widget.workspace;
  //   return ;
  // }

  Widget _buildCompactRatingBadge(double rating, {bool isSmall = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8, vertical: isSmall ? 3 : 5),
      decoration: BoxDecoration(
        color: OptimizedColors.primary08,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OptimizedColors.primary25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(color: AppColors.white, fontSize: isSmall ? 11 : 13, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFAB(BuildContext context, WorkspaceEntity workspace) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.black,
        border: const Border(top: BorderSide(color: OptimizedColors.white10)),
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
                          color: AppColors.white50, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '£${workspace.price}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.white)),
                        TextSpan(
                            text: ' /h',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.white50)),
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
                      color: OptimizedColors.primary25,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
              ),
              child: const Center(
                child: Text(
                  'BOOK NOW',
                  style:
                      TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                ),
              ),
            ),
          ).animate().scale(duration: 250.ms),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}

class _FavoriteButton extends StatelessWidget {
  final WorkspaceEntity workspace;

  const _FavoriteButton({required this.workspace});

  @override
  Widget build(BuildContext context) {
    final cafeState = context.watch<CafeBloc>().state;
    bool isLiked = workspace.isFavorite;
    if (cafeState is CafeLoaded) {
      final c = cafeState.cafes.firstWhereOrNull((e) => e.cafeId.toString() == workspace.id);
      if (c != null) isLiked = c.isLiked;
    } else if (cafeState is CafeWishlistLoaded) {
      final c = cafeState.wishlist.firstWhereOrNull((e) => e.cafeId.toString() == workspace.id);
      if (c != null) isLiked = c.isLiked;
    }

    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: OptimizedColors.black40,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OptimizedColors.white20),
        ),
        child: Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isLiked ? Colors.redAccent : Colors.white,
          size: 20,
        ),
      ),
      onPressed: () {
        final userState = context.read<UserBloc>().state;
        if (userState is UserLoaded) {
          context.read<CafeBloc>().add(ToggleWishlistEvent(
                cafeId: int.parse(workspace.id),
                userCode: userState.user.userCode,
                isWishlist: !isLiked,
              ));
        }
      },
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final WorkspaceEntity workspace;
  final String? heroTag;
  final CarouselSliderController carouselController;

  const _ImageCarousel({
    required this.workspace,
    this.heroTag,
    required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: workspace.images.isEmpty ? 1 : workspace.images.length,
              itemBuilder: (context, index, realIndex) {
                final tag = index == 0
                    ? (heroTag ?? 'workspace_image_${workspace.id}')
                    : '${heroTag ?? 'workspace_image_${workspace.id}'}_$index';
                return Hero(
                  tag: tag,
                  child: ZinkoNetworkImage(
                    imageUrl: workspace.images.isEmpty ? workspace.imageUrl : workspace.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
              options: CarouselOptions(
                height: 280,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOutCubic,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  context.read<WorkspaceDetailBloc>().add(UpdatePageIndex(index));
                },
              ),
            ),
          ),
          if (workspace.images.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BlocBuilder<WorkspaceDetailBloc, WorkspaceDetailState>(
                buildWhen: (p, c) => p.currentPage != c.currentPage,
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
                          boxShadow:
                              isSelected ? [const BoxShadow(color: OptimizedColors.white30, blurRadius: 4)] : [],
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
}
