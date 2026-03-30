import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/community_entities.dart';
import '../bloc/community_bloc.dart';
import '../bloc/community_event.dart';
import '../bloc/community_state.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../../models/app_models.dart';
import '../../../../widgets/zinko_network_image.dart';
import 'connection_requests_screen.dart';
import '../../../user/presentation/pages/subscription_plans_screen.dart';
import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../../chat/presentation/bloc/chat_event.dart';
import '../../../chat/presentation/bloc/chat_state.dart';
import '../../../chat/presentation/pages/chat_screen.dart';
import '../../../chat/domain/entities/chat_entity.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/optimized_colors.dart';
import '../../../../widgets/zinko_background.dart';

class CommunityScreen extends StatefulWidget {
  static const String routeName = '/community';
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);

    context.read<CommunityBloc>().add(GetCommunityDataEvent());
    context.read<ChatBloc>().add(GetChatsEvent());
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      context
          .read<CommunityBloc>()
          .add(CommunityTabChangedEvent(_tabController.index));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _showPremiumBottomSheet(BuildContext context) {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded && userState.user.isPremium) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: GlassTheme.backgroundOverlay(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border:
                Border.all(color: GlassTheme.glassBorder(context), width: 1.5),
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
                      color: OptimizedColors.white12,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gold, Color(0xFFFF8F00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.gold.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: Colors.white, size: 34),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              Text('PREMIUM ACCESS',
                  style: const TextStyle(
                      color: OptimizedColors.white50,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Text(
                'Unlock exclusive connections, group access, and direct messaging.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: GlassTheme.secondaryTextColor(context),
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              _GlassButton(
                label: 'UPGRADE NOW',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, SubscriptionPlansScreen.routeName);
                },
                isFullWidth: true,
                isPrimary: true,
              ).animate().slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutCubic),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('MAYBE LATER',
                    style: TextStyle(
                        color: OptimizedColors.white50,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.transparent,
      body: ZinkoBackground(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 120,
                centerTitle: true,
                leading: const SizedBox.shrink(),
                title: Text(
                  'COMMUNITY',
                  style: TextStyle(
                    color: GlassTheme.textColor(context),
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: 3.0,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _GlassHeaderButton(
                      icon: Icons.person_add_alt_1_rounded,
                      onTap: () => Navigator.pushNamed(
                          context, ConnectionRequestsScreen.routeName),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: GlassTheme.glassColor(context).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: GlassTheme.glassBorder(context)),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: GlassTheme.secondaryTextColor(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: OptimizedColors.white50,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 0.5),
                      tabs: const [
                        Tab(text: 'FEED'),
                        Tab(text: 'CHAT'),
                        Tab(text: 'GROUPS'),
                        Tab(text: 'CONNECT'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: BlocListener<CommunityBloc, CommunityState>(
            listener: (context, state) {
              if (state is CommunityDataLoaded &&
                  state.tabIndex != _tabController.index) {
                _tabController.animateTo(state.tabIndex);
              }
            },
            child: BlocBuilder<CommunityBloc, CommunityState>(
              builder: (context, state) {
                if (state is CommunityLoading)
                  return Center(
                      child: CircularProgressIndicator(
                          color: GlassTheme.textColor(context)));
                if (state is CommunityDataLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _FeedTab(
                          onPremiumAction: () =>
                              _showPremiumBottomSheet(context),
                          posts: state.posts),
                      const _ChatTab(),
                      _GroupsTab(
                          onPremiumAction: () =>
                              _showPremiumBottomSheet(context),
                          groups: state.groups),
                      _ConnectTab(
                          onPremiumAction: () =>
                              _showPremiumBottomSheet(context)),
                    ],
                  );
                }
                if (state is CommunityError)
                  return Center(
                      child: Text(state.message,
                          style: TextStyle(
                              color: GlassTheme.textColor(context))));
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  final VoidCallback onPremiumAction;
  final List<PostEntity> posts;
  const _FeedTab({required this.onPremiumAction, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: onPremiumAction,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GlassTheme.glassColor(context),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: GlassTheme.glassBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ZinkoNetworkImage(
                          imageUrl: post.userAvatar,
                          width: 36,
                          height: 36,
                          borderRadius: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.userName,
                                style: TextStyle(
                                    color: GlassTheme.textColor(context),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15)),
                            Text('${post.timeAgo} • ${post.userRole}',
                                style: const TextStyle(
                                    color: OptimizedColors.white50,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(post.content,
                      style: const TextStyle(
                          color: OptimizedColors.white80,
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w500)),
                  if (post.postImage != null) ...[
                    const SizedBox(height: 12),
                    ZinkoNetworkImage(
                        imageUrl: post.postImage!,
                        width: double.infinity,
                        height: 180,
                        borderRadius: 16),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CommunityBloc>()
                              .add(ToggleLikePostEvent(post.id));
                        },
                        child: _PostAction(
                            icon: post.isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            label: post.likes.toString(),
                            iconColor: post.isLiked
                                ? AppColors.error
                                : OptimizedColors.white50),
                      ),
                      const SizedBox(width: 24),
                      _PostAction(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: post.comments.toString()),
                      const Spacer(),
                      const _PostAction(
                          icon: Icons.share_rounded, label: 'Share'),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        );
      },
    );
  }
}

class _PostAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  const _PostAction({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? OptimizedColors.white50),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                color: OptimizedColors.white50,
                fontSize: 11,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatsLoading)
          return Center(
              child: CircularProgressIndicator(
                  color: GlassTheme.textColor(context)));

        List<ChatEntity>? chats;
        if (state is ChatsLoaded) {
          chats = state.chats;
        } else if (state is MessagesLoaded && state.chats != null) {
          chats = state.chats;
        }

        if (chats == null || chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded,
                    color: OptimizedColors.white30, size: 64),
                const SizedBox(height: 16),
                const Text('NO CONVERSATIONS YET',
                    style: TextStyle(
                        color: OptimizedColors.white50,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2)),
                const SizedBox(height: 24),
                _GlassButton(
                  label: 'REFRESH CHATS',
                  onTap: () => context.read<ChatBloc>().add(GetChatsEvent()),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: GlassTheme.glassColor(context),
          onRefresh: () async {
            context.read<ChatBloc>().add(GetChatsEvent());
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats![index];
              return RepaintBoundary(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: GlassTheme.glassColor(context),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: GlassTheme.glassBorder(context)),
                  ),
                  child: ListTile(
                    onTap: () => Navigator.pushNamed(
                        context, ChatScreen.routeName,
                        arguments: chat),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Stack(
                      children: [
                        ZinkoNetworkImage(
                            imageUrl: chat.avatar,
                            width: 48,
                            height: 48,
                            borderRadius: 24),
                        if (chat.isOnline)
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.black, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(chat.name,
                        style: TextStyle(
                            color: GlassTheme.textColor(context),
                            fontWeight: FontWeight.w900,
                            fontSize: 16)),
                    subtitle: Text(chat.lastMessage,
                        style: const TextStyle(
                            color: OptimizedColors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(chat.time,
                            style: const TextStyle(
                                color: OptimizedColors.white50,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.white
                                    : AppColors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(chat.unreadCount.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.black
                                        : AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),
              );
            },
          ),
        );
      },
    );
  }
}

class _GroupsTab extends StatelessWidget {
  final VoidCallback onPremiumAction;
  final List<GroupEntity> groups;
  const _GroupsTab({required this.onPremiumAction, required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: onPremiumAction,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: GlassTheme.glassColor(context).withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: GlassTheme.glassBorder(context)),
              ),
              child: Row(
                children: [
                  ZinkoNetworkImage(
                      imageUrl: group.image,
                      width: 50,
                      height: 50,
                      borderRadius: 12),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(group.name,
                            style: TextStyle(
                                color: GlassTheme.textColor(context),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(group.memberCount,
                            style: const TextStyle(
                                color: OptimizedColors.white60,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  _GlassButton(
                    label: group.isJoined ? 'Joined' : 'Join',
                    isSecondary: group.isJoined,
                    onTap: () {
                      context
                          .read<CommunityBloc>()
                          .add(ToggleJoinGroupEvent(group.id));
                    },
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        );
      },
    );
  }
}

class _ConnectTab extends StatelessWidget {
  final VoidCallback onPremiumAction;
  const _ConnectTab({required this.onPremiumAction});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: kSampleConnections.length,
      itemBuilder: (context, index) {
        final connect = kSampleConnections[index];
        return RepaintBoundary(
          child: GestureDetector(
            onTap: onPremiumAction,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: GlassTheme.glassColor(context).withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: GlassTheme.glassBorder(context)),
              ),
              child: Row(
                children: [
                  ZinkoNetworkImage(
                      imageUrl: connect.avatar,
                      width: 48,
                      height: 48,
                      borderRadius: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(connect.name,
                            style: TextStyle(
                                color: GlassTheme.textColor(context),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(connect.role,
                            style: TextStyle(
                                color: GlassTheme.secondaryTextColor(context)
                                    .withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  _GlassButton(
                    label: 'Connect',
                    onTap: onPremiumAction,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        );
      },
    );
  }
}

class _GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;
  final bool isPrimary;
  final bool isFullWidth;

  const _GlassButton({
    required this.label,
    required this.onTap,
    this.isSecondary = false,
    this.isPrimary = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        height: isFullWidth ? 56 : null,
        alignment: isFullWidth ? Alignment.center : null,
        padding: isFullWidth
            ? null
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary
              ? (isDark ? AppColors.white : AppColors.black)
              : isSecondary
                  ? AppColors.success.withOpacity(0.1)
                  : GlassTheme.textColor(context).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(
                  color: isSecondary
                      ? AppColors.success.withOpacity(0.3)
                      : GlassTheme.glassBorder(context)),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isPrimary
                ? (isDark ? AppColors.black : AppColors.white)
                : GlassTheme.textColor(context),
            fontSize: isFullWidth ? 13 : 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
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
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: OptimizedColors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
