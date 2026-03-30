import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/optimized_colors.dart';

class EventDetailScreen extends StatefulWidget {
  static const String routeName = '/event-detail';
  final dynamic event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late dynamic _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  void _onRegister(BuildContext context) {
    context.read<EventBloc>().add(RegisterEventEvent(_event.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventRegistrationSuccess &&
            state.eventName == _event.title) {
          _showSuccessOverlay(context);
        }
      },
      builder: (context, state) {
        if (state is EventLoaded) {
          try {
            _event = state.events
                .firstWhere((e) => e.id == _event.id, orElse: () => _event);
          } catch (_) {}
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
                  child:
                      Container(color: GlassTheme.backgroundOverlay(context)),
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
                          _buildGlassOrganizer(),
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

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _GlassHeaderButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassHeaderButton(
            icon: _event.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: _event.isFavorite ? Colors.redAccent : null,
            onTap: () {
              context
                  .read<EventBloc>()
                  .add(ToggleFavoriteEventEvent(_event.id));
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/cafe_hotel_bg.png',
                  fit: BoxFit.cover),
            ),
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.2)
                ]))),
          ],
        ),
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OptimizedColors.white30,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: OptimizedColors.white30),
                ),
                child: Text(
                  _event.category.toUpperCase(),
                  style: TextStyle(
                    color: GlassTheme.textColor(context),
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
              ).animate().fadeIn().slideX(begin: -0.1),
              const SizedBox(height: 12),
              Text(
                _event.title,
                style: TextStyle(
                  fontSize: 22,
                  color: GlassTheme.textColor(context),
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn().slideX(begin: -0.1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 14, color: GlassTheme.secondaryTextColor(context)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _event.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: GlassTheme.secondaryTextColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassStatsRow() {
    return Row(
      children: [
        _buildStatCard(
            'DATE & TIME', _event.date, Icons.calendar_today_rounded),
        const SizedBox(width: 12),
        _buildStatCard(
            'ATTENDING', '${_event.attendees}', Icons.people_alt_rounded),
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
                Icon(icon, size: 18, color: OptimizedColors.white30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                            color: GlassTheme.textColor(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w900),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(label,
                          style: const TextStyle(
                              color: OptimizedColors.white50,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                    ],
                  ),
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
      title: 'ABOUT THIS EVENT',
      child: Text(
        _event.description,
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: OptimizedColors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGlassOrganizer() {
    return _buildSectionCard(
      title: 'ORGANIZER',
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_event.hostName,
                    style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontWeight: FontWeight.w900,
                        fontSize: 14)),
                Text('Official Host',
                    style: TextStyle(
                        color: GlassTheme.secondaryTextColor(context),
                        fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              shape: BoxShape.circle,
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(Icons.chat_bubble_outline_rounded,
                size: 16, color: GlassTheme.iconColor(context)),
          ),
        ],
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
              Text(title,
                  style: TextStyle(
                      color: GlassTheme.secondaryTextColor(context),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2)),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionFAB(BuildContext context) {
    final isRegistered = _event.isRegistered;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          decoration: BoxDecoration(
            color: GlassTheme.backgroundOverlay(context),
            border:
                Border(top: BorderSide(color: GlassTheme.glassBorder(context))),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isRegistered ? null : () => _onRegister(context),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isRegistered
                          ? Colors.green.withOpacity(0.5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // decoration: BoxDecoration(
                    //   color: isRegistered
                    //       ? Colors.green.withOpacity(0.5)
                    //       : AppColors.primary,
                    //   borderRadius: BorderRadius.circular(16),
                    //   boxShadow: [
                    //     if (!isRegistered)
                    //       BoxShadow(
                    //           color: GlassTheme.textColor(context)
                    //               .withOpacity(0.3),
                    //           blurRadius: 10,
                    //           offset: const Offset(0, 4))
                    //   ],
                    // ),
                    alignment: Alignment.center,
                    child: Text(
                        isRegistered
                            ? 'REGISTERED SUCCESSFULLY'
                            : 'RESERVE MY SPOT',
                        style: TextStyle(
                            color: isRegistered ? Colors.white : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0)),
                  ),
                ).animate().scale(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _EventSuccessOverlay(eventName: _event.title),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pop(context); // Pop dialog
        Navigator.pop(context); // Pop screen
      }
    });
  }
}

class _EventSuccessOverlay extends StatelessWidget {
  final String eventName;
  const _EventSuccessOverlay({required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.green.withOpacity(0.5), width: 2),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.green, size: 70),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 32),
              const Text('YOU\'RE IN!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Your registration for $eventName is confirmed.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 48),
              const Text('See you there!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic)),
            ],
          ).animate().fadeIn(),
        ),
      ),
    );
  }
}

class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  const _GlassHeaderButton(
      {required this.icon, this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon,
                color: iconColor ?? GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}
