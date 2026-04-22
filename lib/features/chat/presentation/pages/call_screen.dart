import 'package:flutter/material.dart';
import 'package:zinko_app/features/chat/domain/entities/chat_entity.dart';
import 'package:zinko_app/widgets/zinko_network_image.dart';

class CallScreen extends StatelessWidget {
  static const String routeName = '/call';
  final ChatEntity chat;
  final bool isVideo;

  const CallScreen({super.key, required this.chat, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A222C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: ZinkoNetworkImage(
                    imageUrl: chat.avatar,
                    width: 140,
                    height: 140,
                    borderRadius: 70,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  chat.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Calling...',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCallAction(Icons.mic_none_rounded,
                      Colors.white.withAlpha(30), Colors.white),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _buildCallAction(
                        Icons.call_end_rounded, Colors.redAccent, Colors.white,
                        size: 32, padding: 20),
                  ),
                  _buildCallAction(Icons.volume_up_rounded,
                      Colors.white.withAlpha(30), Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallAction(IconData icon, Color bg, Color iconColor,
      {double size = 24, double padding = 16}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: size),
    );
  }
}
