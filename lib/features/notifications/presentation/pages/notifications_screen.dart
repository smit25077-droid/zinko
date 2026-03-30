import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({super.key});

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
        centerTitle: true,
        title: Text(
          'NOTIFICATIONS',
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          _GlassHeaderButton(
            icon: Icons.done_all_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ZinkoBackground(
        child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              physics: const BouncingScrollPhysics(),
              children: [
                const _NotificationGroup(
                  title: 'TODAY',
                  items: [
                    _NotificationItem(
                      title: 'Booking Confirmed',
                      description: 'Your booking at Urban Hive is confirmed.',
                      time: '2 hours ago',
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: Colors.greenAccent,
                      isNew: true,
                    ),
                    _NotificationItem(
                      title: 'Community Alert',
                      description: 'Startup Networking is happening near you.',
                      time: '5 hours ago',
                      icon: Icons.calendar_today_rounded,
                      iconColor: Colors.purpleAccent,
                      isNew: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _NotificationGroup(
                  title: 'YESTERDAY',
                  items: [
                    _NotificationItem(
                      title: 'Payment Success',
                      description: 'Subscription payment successful.',
                      time: '1 day ago',
                      icon: Icons.credit_card_rounded,
                      iconColor: Colors.blueAccent,
                    ),
                    _NotificationItem(
                      title: 'New Feature',
                      description: 'Discover Premium Community features!',
                      time: '2 days ago',
                      icon: Icons.stars_rounded,
                      iconColor: Colors.amberAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _NotificationGroup(
                  title: 'EARLIER',
                  items: [
                    _NotificationItem(
                      title: 'Friend Request',
                      description: 'David Wilson sent a request.',
                      time: '3 days ago',
                      icon: Icons.person_add_outlined,
                      iconColor: Colors.tealAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _NotificationGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: GlassTheme.secondaryTextColor(context).withOpacity(0.5),
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...items.indexed.map((entry) {
          return entry.$2
              .animate()
              .fadeIn(duration: 400.ms, delay: (entry.$1 * 80).ms)
              .slideX(begin: 0.1);
        }),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isNew;

  const _NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context).withOpacity(isNew ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: GlassTheme.glassBorder(context).withOpacity(isNew ? 0.3 : 0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: GlassTheme.textColor(context),
                          ),
                        ),
                        if (isNew)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: GlassTheme.secondaryTextColor(context).withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                time.split(' ').first + 'h',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: GlassTheme.secondaryTextColor(context).withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
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
