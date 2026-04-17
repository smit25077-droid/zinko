import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/workspace_entity.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_state.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../user/domain/entities/person_entity.dart';
import 'workspace_detail_screen.dart';
import '../../../user/presentation/pages/person_profile_screen.dart';
import '../../../community/presentation/bloc/community_bloc.dart';
import '../../../community/presentation/bloc/community_event.dart';
import '../../../community/presentation/bloc/community_state.dart';
import '../../../user/presentation/pages/subscription_plans_screen.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../../../models/app_models.dart' show ZinkoChat;
import '../../../chat/presentation/pages/chat_screen.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_event.dart';
import '../bloc/map/map_state.dart';

class MapScreen extends StatelessWidget {
  static const String routeName = '/map';
  const MapScreen({super.key});

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GoogleMapController?> mapController =
        ValueNotifier(null);

    return BlocProvider(
      create: (_) => di.sl<MapBloc>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<WorkspaceBloc, WorkspaceState>(
            listener: (context, state) {
              if (state is WorkspaceLoaded) {
                final people =
                    (context.read<CommunityBloc>().state is CommunityDataLoaded)
                        ? (context.read<CommunityBloc>().state
                                as CommunityDataLoaded)
                            .people
                        : <PersonEntity>[];
                context.read<MapBloc>().add(MapDataUpdated(
                    workspaces: state.workspaces, people: people));
              }
            },
          ),
          BlocListener<CommunityBloc, CommunityState>(
            listener: (context, state) {
              if (state is CommunityDataLoaded) {
                final workspaces = (context.read<WorkspaceBloc>().state
                        is WorkspaceLoaded)
                    ? (context.read<WorkspaceBloc>().state as WorkspaceLoaded)
                        .workspaces
                    : <WorkspaceEntity>[];
                context.read<MapBloc>().add(MapDataUpdated(
                    workspaces: workspaces, people: state.people));
              }
            },
          ),
          BlocListener<MapBloc, MapState>(
            listener: (context, state) {
              if (state.selectedWorkspace != null) {
                _showPlaceDetails(context, state.selectedWorkspace!);
                context.read<MapBloc>().add(ClearSelectionEvent());
              } else if (state.selectedPerson != null) {
                _showPersonDetails(context, state.selectedPerson!);
                context.read<MapBloc>().add(ClearSelectionEvent());
              }
            },
          ),
        ],
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            return Scaffold(
              backgroundColor:
                  Colors.transparent, // Global background visibility
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (controller) =>
                        mapController.value = controller,
                    markers: mapState.markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    style: Theme.of(context).brightness == Brightness.dark
                        ? _getDarkMapStyle()
                        : null,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _SearchBar(),
                          const SizedBox(height: 10),
                          _FilterList(selectedFilter: mapState.selectedFilter),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 110,
                    child: _MyLocationButton(mapController: mapController),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPlaceDetails(BuildContext context, WorkspaceEntity workspace) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PlaceDetailsSheet(workspace: workspace),
    );
  }

  void _showPersonDetails(BuildContext context, PersonEntity person) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<CommunityBloc>()),
          BlocProvider.value(value: context.read<UserBloc>()),
        ],
        child: _PersonDetailsSheet(person: person),
      ),
    );
  }

  String? _getDarkMapStyle() {
    return '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
''';
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withValues(alpha: isDark ? 0.3 : 0.12),
              blurRadius: 30,
              offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : AppColors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.12)
                      : AppColors.black.withValues(alpha: 0.08),
                  width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Where are you headed?',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: GlassTheme.textColor(context).withValues(alpha: 0.4),
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: GlassTheme.textColor(context).withValues(alpha: 0.12),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                _GlassCircularButton(
                  icon: Icons.tune_rounded,
                  onTap: () {},
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterList extends StatelessWidget {
  final String selectedFilter;
  const _FilterList({required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Cafes', 'Workspaces', 'People'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilter == filters[index];
          return GestureDetector(
            onTap: () =>
                context.read<MapBloc>().add(MapFilterChanged(filters[index])),
            child: AnimatedContainer(
              duration: 300.ms,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.white : AppColors.black)
                    : isDark
                        ? AppColors.white.withValues(alpha: 0.08)
                        : AppColors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: (isDark ? AppColors.white : AppColors.black)
                                .withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ]
                    : null,
                border: Border.all(
                    color: isSelected
                        ? (isDark ? AppColors.white : AppColors.black)
                        : isDark
                            ? AppColors.white.withValues(alpha: 0.12)
                            : AppColors.black.withValues(alpha: 0.1),
                    width: 1.2),
              ),
              alignment: Alignment.center,
              child: Text(
                filters[index].toUpperCase(),
                style: TextStyle(
                  color: isSelected
                      ? (isDark ? AppColors.black : AppColors.white)
                      : GlassTheme.textColor(context).withValues(alpha: 0.7),
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final ValueNotifier<GoogleMapController?> mapController;
  const _MyLocationButton({required this.mapController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        if (mapController.value != null) {
          await mapController.value!.animateCamera(
            CameraUpdate.newCameraPosition(const CameraPosition(
                target: LatLng(51.5074, -0.1278), zoom: 15)),
          );
        }
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.3 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.12)
                    : AppColors.white.withValues(alpha: 0.9),
                border: Border.all(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.15)
                        : AppColors.black.withValues(alpha: 0.08),
                    width: 1.5),
              ),
              child: const Icon(Icons.my_location_rounded,
                  color: AppColors.primary, size: 26),
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }
}

class _PlaceDetailsSheet extends StatelessWidget {
  final WorkspaceEntity workspace;
  const _PlaceDetailsSheet({required this.workspace});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.backgroundDark.withValues(alpha: 0.92)
              : AppColors.white.withValues(alpha: 0.94),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : AppColors.black.withValues(alpha: 0.07),
              width: 1.5),
        ),
        padding: EdgeInsets.fromLTRB(
            28, 12, 28, 24 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 28),
            RepaintBoundary(
              child: Row(
                children: [
                  Hero(
                    tag: 'map_place_${workspace.id}',
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ZinkoNetworkImage(
                            imageUrl: workspace.imageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workspace.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: GlassTheme.textColor(context),
                                height: 1.0,
                                letterSpacing: -1.0)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Expanded(
                                child: Text(workspace.location,
                                    style: TextStyle(
                                        color: GlassTheme.secondaryTextColor(
                                            context),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(), // Placeholder since rating is removed
                            Text('£${workspace.price}',
                                style: TextStyle(
                                    color: GlassTheme.textColor(context),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, WorkspaceDetailScreen.routeName,
                    arguments: workspace);
              },
              child: Container(
                height: 64,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [AppColors.white, AppColors.white.withValues(alpha: 0.9)]
                        : [AppColors.black, AppColors.black.withValues(alpha: 0.9)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? AppColors.white
                                : AppColors.black)
                            .withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'VIEW WORKSPACE',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.black
                          : AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0),
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

class _PersonDetailsSheet extends StatelessWidget {
  final PersonEntity person;
  const _PersonDetailsSheet({required this.person});

  void _showPremiumBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context).withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 12, 24, 24 + MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              const Icon(Icons.workspace_premium_rounded,
                  color: AppColors.gold, size: 64),
              const SizedBox(height: 16),
              const Text('PREMIUM REQUIRED',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 32),
              _ActionElevatedButton(
                label: 'UPGRADE NOW',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, SubscriptionPlansScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, communityState) {
        final currentPerson = communityState is CommunityDataLoaded
            ? communityState.people
                .firstWhere((p) => p.id == person.id, orElse: () => person)
            : person;

        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            final user = (userState is UserLoaded) ? userState.user : null;
            final isPremium = user?.isPremium ?? false;

            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.92)
                    : AppColors.white.withValues(alpha: 0.94),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
                border: Border.all(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.1)
                        : AppColors.black.withValues(alpha: 0.07),
                    width: 1.5),
              ),
              padding: EdgeInsets.fromLTRB(
                  28, 12, 28, 32 + MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                          color: GlassTheme.textColor(context).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 28),
                  RepaintBoundary(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(currentPerson.avatarUrl),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentPerson.name,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: GlassTheme.textColor(context),
                                      letterSpacing: -1.2)),
                              const SizedBox(height: 2),
                              Text(currentPerson.role.toUpperCase(),
                                  style: TextStyle(
                                      color: GlassTheme.secondaryTextColor(
                                          context),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('ACTIVE NOW',
                                      style: TextStyle(
                                          color: AppColors.success,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 36),
                  RepaintBoundary(
                    child: Row(
                      children: [
                        Expanded(
                          child: _GlassActionButton(
                            label: currentPerson.isConnected
                                ? 'DISCONNECT'
                                : 'CONNECT',
                            onTap: () {
                              if (isPremium) {
                                context.read<CommunityBloc>().add(
                                    ToggleConnectionEvent(currentPerson.id));
                              } else {
                                _showPremiumBottomSheet(context);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            if (isPremium) {
                              final chat = ZinkoChat(
                                  id: currentPerson.id,
                                  name: currentPerson.name,
                                  lastMessage: '',
                                  time: 'Now',
                                  avatar: currentPerson.avatarUrl,
                                  unreadCount: 0,
                                  isOnline: true);
                              Navigator.pop(context);
                              Navigator.pushNamed(context, ChatScreen.routeName,
                                  arguments: chat);
                            } else {
                              _showPremiumBottomSheet(context);
                            }
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: GlassTheme.glassColor(context)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: GlassTheme.glassBorder(context)),
                            ),
                            child: Icon(Icons.chat_bubble_outline_rounded,
                                color: GlassTheme.textColor(context), size: 22),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn(),
                  const SizedBox(height: 12),
                  _ActionElevatedButton(
                    label: 'VIEW FULL PROFILE',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, PersonProfileScreen.routeName,
                          arguments: currentPerson);
                    },
                  ).animate(delay: 200.ms).fadeIn(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _GlassCircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  const _GlassCircularButton(
      {required this.icon, required this.onTap, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : AppColors.white.withValues(alpha: 0.8),
              border: Border.all(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.15)
                      : AppColors.black.withValues(alpha: 0.1)),
            ),
            child: Icon(icon,
                color: GlassTheme.iconColor(context), size: size * 0.5),
          ),
        ),
      ),
    );
  }
}

class _GlassActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GlassActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GlassTheme.glassBorder(context)),
        ),
        alignment: Alignment.center,
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: GlassTheme.textColor(context),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.0)),
      ),
    );
  }
}

class _ActionElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionElevatedButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? AppColors.white : AppColors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: isDark ? AppColors.black : AppColors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.0)),
      ),
    );
  }
}

