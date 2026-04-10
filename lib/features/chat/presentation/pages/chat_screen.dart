import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/models/app_models.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../../../widgets/zinko_network_image.dart';
import 'call_screen.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  final ZinkoChat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetMessagesEvent(widget.chat.id));
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    context.read<ChatBloc>().add(
        SendChatMessageEvent(widget.chat.id, _messageController.text.trim()));
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: GlassTheme.textColor(context), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ZinkoNetworkImage(
                imageUrl: widget.chat.avatar,
                width: 36,
                height: 36,
                borderRadius: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.chat.name,
                      style: TextStyle(
                          color: GlassTheme.textColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w900)),
                  Text(widget.chat.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                          color: widget.chat.isOnline
                              ? Colors.greenAccent
                              : GlassTheme.secondaryTextColor(context),
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam_rounded,
                color: GlassTheme.textColor(context), size: 22),
            onPressed: () => Navigator.pushNamed(context, CallScreen.routeName,
                arguments: {'chat': widget.chat, 'isVideo': true}),
          ),
          IconButton(
            icon: Icon(Icons.phone_rounded,
                color: GlassTheme.textColor(context), size: 22),
            onPressed: () => Navigator.pushNamed(context, CallScreen.routeName,
                arguments: {'chat': widget.chat, 'isVideo': false}),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ZinkoBackground(
        child: SafeArea(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is MessagesLoading) {
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              } else if (state is ChatError) {
                return Center(
                    child: Text(state.message,
                        style:
                            TextStyle(color: GlassTheme.textColor(context))));
              } else if (state is MessagesLoaded) {
                final messages = state.messages;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return _buildMessage(
                              context, msg.text, msg.time, msg.isMe);
                        },
                      ),
                    ),
                    _buildInputArea(context),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(
      BuildContext context, String text, String time, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: BoxDecoration(
                  color: isMe
                      ? GlassTheme.textColor(context).withValues(alpha: 0.15)
                      : GlassTheme.textColor(context).withValues(alpha: 0.06),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 20),
                  ),
                  border: Border.all(color: GlassTheme.glassBorder(context)),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                      color: GlassTheme.textColor(context),
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(time,
              style: TextStyle(
                  fontSize: 9,
                  color: GlassTheme.tertiaryTextColor(context),
                  fontWeight: FontWeight.w700)),
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, 24 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: GlassTheme.backgroundOverlay(context),
            border:
                Border(top: BorderSide(color: GlassTheme.glassBorder(context))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: GlassTheme.textColor(context).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: GlassTheme.glassBorder(context)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(
                        color: GlassTheme.textColor(context), fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                          color: GlassTheme.secondaryTextColor(context),
                          fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: GlassTheme.textColor(context),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

