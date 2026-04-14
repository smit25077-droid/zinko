import 'package:flutter/material.dart';
import '../../../../widgets/zinko_background.dart';
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
    return ZinkoBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        // appBar: CommonAppBar(
        //   title: 'EVENTS',
        //   isBackEnable: false,
        // ),
        body: Column(
          children: [
            // SizedBox(height: 80),
            // Scrollable Event List
            Expanded(
              child: BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: GlassTheme.textColor(context)));
                  }
                  if (state is EventLoaded) {
                    final events = state.events;
                    return Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _EventCard(event: event)
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 100.ms)
                              ;
                        },
                      ),
                    );
                  }
                  if (state is EventError) {
                    return Center(
                        child: Text(state.message,
                            style: TextStyle(
                                color: GlassTheme.textColor(context))));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Bottom padding for the navigation bar
            // const SizedBox(height: 100),
          ],
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
                      height: 110,
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
                          style: TextStyle(
                              color: GlassTheme.tertiaryTextColor(context),
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5),
                        ),
                        const Spacer(),
                        Icon(Icons.access_time_rounded,
                            size: 12,
                            color: GlassTheme.tertiaryTextColor(context)),
                        const SizedBox(width: 4),
                        Text(
                          '${event.date} ${event.month}',
                          style: TextStyle(
                            color: GlassTheme.secondaryTextColor(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 12,
                            color:
                                GlassTheme.textColor(context).withValues(alpha: 0.6)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: GlassTheme.textColor(context)
                                  .withValues(alpha: 0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: GlassTheme.textColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlassTheme.glassBorder(context)),
      ),
      child: Text(
        price,
        style: TextStyle(
          color: isDark ? Colors.black : Colors.white,
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
        color: GlassTheme.textColor(context).withValues(alpha: 0.08),
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

