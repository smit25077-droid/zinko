// community_provider.dart
// Kept for backward compatibility – screens that import CommunityProvider
// now get AppProvider under the hood via the alias below.
// The actual logic lives in AppProvider (providers/app_provider.dart).

import 'package:flutter/material.dart';
import 'package:zinko_app/models/app_models.dart';

class CommunityProvider with ChangeNotifier {
  final List<ZinkoConnection> _connectionRequests = [
    ZinkoConnection(
      id: 'r1',
      name: 'Jessica Lee',
      role: 'Product Designer',
      avatar: 'https://i.pravatar.cc/150?u=jessica',
    ),
    ZinkoConnection(
      id: 'r2',
      name: 'David Wilson',
      role: 'Software Engineer',
      avatar: 'https://i.pravatar.cc/150?u=david_w',
    ),
    ZinkoConnection(
      id: 'r3',
      name: 'Amanda Chen',
      role: 'Marketing Manager',
      avatar: 'https://i.pravatar.cc/150?u=amanda_c',
    ),
  ];

  // Delegate to shared kAllChats list
  List<ZinkoChat> get chats => kAllChats;
  List<ZinkoConnection> get connectionRequests => _connectionRequests;

  void acceptConnection(ZinkoConnection request) {
    _connectionRequests.removeWhere((c) => c.id == request.id);
    final index = kAllChats.indexWhere((c) => c.name == request.name);
    if (index == -1) {
      kAllChats.insert(
        0,
        ZinkoChat(
          id: DateTime.now().toString(),
          name: request.name,
          lastMessage: 'You are now connected!',
          time: 'Just now',
          avatar: request.avatar,
          unreadCount: 0,
          isOnline: true,
        ),
      );
    }
    notifyListeners();
  }

  void ignoreConnection(String requestId) {
    _connectionRequests.removeWhere((c) => c.id == requestId);
    notifyListeners();
  }
}
