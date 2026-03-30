import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../../../../widgets/zinko_network_image.dart';
import 'event_detail_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/optimized_colors.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = '/events';
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(GetEventsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/cafe_hotel_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                  color:
                      GlassTheme.backgroundOverlay(context).withOpacity(0.4)),
            ),
          ),

          BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              }
              if (state is EventLoaded) {
                final events = state.events;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(context),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final event = events[index];
                            return _EventCard(event: event)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.05);
                          },
                          childCount: events.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              }
              if (state is EventError) {
                return Center(
                    child: Text(state.message,
                        style:
                            TextStyle(color: GlassTheme.textColor(context))));
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'EVENTS',
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontWeight: FontWeight.w900,
            fontSize: 25,
            letterSpacing: 3.0,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                OptimizedColors.black40,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventEntity event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, EventDetailScreen.routeName,
            arguments: event),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    child: ZinkoNetworkImage(
                      imageUrl: event.imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _PriceBadge(price: event.price),
                  ),
                ],
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          event.category.toUpperCase(),
                          style: const TextStyle(
                              color: OptimizedColors.white50,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5),
                        ),
                        const Spacer(),
                        const Icon(Icons.access_time_rounded,
                            size: 12,
                            color: OptimizedColors.white50),
                        const SizedBox(width: 4),
                        Text(
                          '${event.date} ${event.month}',
                          style: const TextStyle(
                            color: OptimizedColors.white50,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.title,
                      style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 14, color: GlassTheme.textColor(context)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(
                              color: GlassTheme.textColor(context),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _HostAvatar(hostName: event.hostName),
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

class _PriceBadge extends StatelessWidget {
  final String price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: OptimizedColors.black80,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OptimizedColors.white12),
      ),
      child: Text(
        price,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _HostAvatar extends StatelessWidget {
  final String hostName;
  const _HostAvatar({required this.hostName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: OptimizedColors.white08,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: OptimizedColors.white30,
            child: Text(
              hostName[0],
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: GlassTheme.textColor(context)),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            hostName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: GlassTheme.textColor(context),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _CategorySelector extends StatefulWidget {
  @override
  State<_CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<_CategorySelector> {
  String selected = 'ALL';
  final categories = ['ALL', 'PARTIES', 'MUSIC', 'ART', 'TECH', 'SPORTS'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selected == cat;
          return GestureDetector(
            onTap: () => setState(() => selected = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : GlassTheme.glassColor(context),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : GlassTheme.glassBorder(context)),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : OptimizedColors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ).animate(target: isSelected ? 1 : 0).scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: 200.ms),
          );
        },
      ),
    );
  }
}

