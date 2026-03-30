import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_models.dart';
import '../../../../providers/app_provider.dart';
import '../../domain/entities/person_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import 'subscription_plans_screen.dart';
import '../../../chat/presentation/pages/chat_screen.dart';

// ── Main Person Profile Screen ─────────────────────────────────────────────────
class PersonProfileScreen extends StatefulWidget {
  static const String routeName = '/person-profile';
  final PersonEntity person;

  const PersonProfileScreen({super.key, required this.person});

  @override
  State<PersonProfileScreen> createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _connectController;

  @override
  void initState() {
    super.initState();
    _connectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _connectController.dispose();
    super.dispose();
  }

  void _onConnect(BuildContext context, bool isPremium) {
    if (!isPremium) {
      _showPremiumBottomSheet(context);
      return;
    }
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _connectController.forward(from: 0);
    appProvider.toggleConnection(widget.person.id);
  }

  void _onMessage(BuildContext context, bool isPremium) {
    if (!isPremium) {
      _showPremiumBottomSheet(context);
      return;
    }
    final chat = ZinkoChat(
      id: widget.person.id,
      name: widget.person.name,
      lastMessage: '',
      time: 'Now',
      avatar: widget.person.avatarUrl,
      unreadCount: 0,
      isOnline: true,
    );
    Navigator.pushNamed(context, ChatScreen.routeName, arguments: chat);
  }

  void _showPremiumBottomSheet(BuildContext context) {
    final state = context.read<UserBloc>().state;
    if (state is UserLoaded && state.user.isPremium) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PremiumBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'IDENTITY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/cafe_hotel_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),
          // Content
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              final isPremiumUser = state is UserLoaded ? state.user.isPremium : false;
              final p = widget.person;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 120),
                        // Avatar Header
                        Hero(
                          tag: 'person-${p.id}',
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)
                              ],
                              image: DecorationImage(image: NetworkImage(p.avatarUrl), fit: BoxFit.cover),
                            ),
                          ),
                        ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                            if (p.isVerified) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, color: Colors.white, size: 24),
                            ],
                          ],
                        ).animate(delay: 200.ms).fadeIn(),
                        Text(
                          p.role.toUpperCase(),
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w700, letterSpacing: 1.2),
                        ).animate(delay: 300.ms).fadeIn(),
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: _GlassButton(
                                  onPressed: () => _onConnect(context, isPremiumUser),
                                  text: p.isConnected ? 'CONNECTED' : 'CONNECT',
                                  icon: p.isConnected ? Icons.person_remove_rounded : Icons.person_add_rounded,
                                  isFilled: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _GlassButton(
                                  onPressed: () => _onMessage(context, isPremiumUser),
                                  text: 'MESSAGE',
                                  icon: Icons.chat_bubble_rounded,
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),
                        
                        const SizedBox(height: 32),
                        
                        // Stats Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildGlassStats(p),
                        ).animate(delay: 500.ms).fadeIn(),
                        
                        const SizedBox(height: 24),
                        
                        // Content Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('ABOUT IDENTITY'),
                              const SizedBox(height: 12),
                              _buildGlassCard(
                                child: Text(
                                  p.bio,
                                  style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white.withOpacity(0.85)),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              _buildSectionTitle('MASTERED SKILLS'),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: p.skills.map((skill) => _buildSkillBadge(skill)).toList(),
                              ),
                              const SizedBox(height: 24),
                              
                              _buildSectionTitle('ACTIVITY LOG'),
                              const SizedBox(height: 12),
                              _buildGlassCard(
                                child: Column(
                                  children: [
                                    _buildActivityTile(Icons.event_available_rounded, 'Attending "London Tech Meetup"', '2h ago'),
                                    Divider(color: Colors.white.withOpacity(0.1), height: 24),
                                    _buildActivityTile(Icons.groups_3_rounded, 'Joined "Digital Nomads" Group', 'Yesterday'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ).animate(delay: 600.ms).fadeIn(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white60, letterSpacing: 1.5),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGlassStats(PersonEntity p) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: Row(
            children: [
              _buildStatItem(p.connections.toString(), 'CONNECTIONS'),
              Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
              _buildStatItem(p.groups.toString(), 'GROUPS'),
              Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
              _buildStatItem(p.rating.toStringAsFixed(1), 'RATING'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _buildSkillBadge(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Text(
        skill,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildActivityTile(IconData icon, String title, String time) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              Text(time, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool isFilled;

  const _GlassButton({required this.onPressed, required this.text, required this.icon, this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: isFilled ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: isFilled ? Colors.black : Colors.white),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    color: isFilled ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B1220).withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFFF8F00)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            const Text('PREMIUM FEATURE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            const Text(
              'Upgrade to Pro or Elite plan to network\nwith other members directly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.white60, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, SubscriptionPlansScreen.routeName);
              },
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                alignment: Alignment.center,
                child: const Text('UPGRADE NOW', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('MAYBE LATER', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
