// ============================================================
//  app_provider.dart — Unified state manager for Zinko
//  Replaces BookingProvider + CommunityProvider
//  Manages: bookings, favourites, connections, posts, events
// ============================================================

import 'package:flutter/material.dart';
import 'package:zinko_app/models/app_models.dart';

class AppProvider with ChangeNotifier {
  // ── Bookings ───────────────────────────────────────────────
  final List<ZinkoBooking> _bookings = [...kAllBookings];
  List<ZinkoBooking> get bookings => List.unmodifiable(_bookings);

  void addBooking(ZinkoBooking booking) {
    _bookings.insert(0, booking);
    // Update the corresponding place model
    final idx = kAllPlaces.indexWhere((p) => p.id == booking.placeId);
    if (idx != -1) {
      kAllPlaces[idx].isBooked = true;
    }
    notifyListeners();
  }

  void removeBooking(String id) {
    _bookings.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  void completeBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      final b = _bookings[index];
      _bookings[index] = ZinkoBooking(
        id: b.id,
        placeId: b.placeId,
        placeName: b.placeName,
        location: b.location,
        imageUrl: b.imageUrl,
        date: b.date,
        timeSlot: b.timeSlot,
        tableNumber: b.tableNumber,
        subtotal: b.subtotal,
        tax: b.tax,
        total: b.total,
        isCompleted: true,
        placeType: b.placeType,
      );

      // Reset the booked status of the place so it can be booked again
      if (b.placeType == PlaceType.event) {
        final eIdx = kAllEvents.indexWhere((e) => e.id == b.placeId);
        if (eIdx != -1) {
          kAllEvents[eIdx].isRegistered = false;
        }
      } else {
        final pIdx = kAllPlaces.indexWhere((p) => p.id == b.placeId);
        if (pIdx != -1) {
          kAllPlaces[pIdx].isBooked = false;
        }
      }

      notifyListeners();
    }
  }

  bool hasBooking(String placeId) => _bookings.any((b) => b.placeId == placeId);

  List<ZinkoPlace> get allPlaces => kAllPlaces;

  // ── Places (favourites / bookmarks) ───────────────────────
  List<ZinkoPlace> get favoritePlaces =>
      kAllPlaces.where((p) => p.isFavorite).toList();

  List<ZinkoPlace> get bookmarkedPlaces =>
      kAllPlaces.where((p) => p.isBookmarked).toList();

  void toggleFavoritePlace(String id) {
    final idx = kAllPlaces.indexWhere((p) => p.id == id);
    if (idx != -1) {
      kAllPlaces[idx].isFavorite = !kAllPlaces[idx].isFavorite;
      notifyListeners();
    }
  }

  void toggleBookmarkPlace(String id) {
    final idx = kAllPlaces.indexWhere((p) => p.id == id);
    if (idx != -1) {
      kAllPlaces[idx].isBookmarked = !kAllPlaces[idx].isBookmarked;
      notifyListeners();
    }
  }

  ZinkoPlace? getPlaceByName(String name) {
    try {
      return kAllPlaces.firstWhere((p) => p.name == name);
    } catch (_) {
      return null;
    }
  }

  ZinkoPlace? getPlaceById(String id) {
    try {
      return kAllPlaces.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── People (connections / favourites) ─────────────────────
  List<ZinkoPerson> get allPeople => kAllPeople;

  List<ZinkoPerson> get connectedPeople =>
      kAllPeople.where((p) => p.isConnected).toList();

  List<ZinkoPerson> get favoritePeople =>
      kAllPeople.where((p) => p.isFavorite).toList();

  void toggleConnection(String id) {
    final idx = kAllPeople.indexWhere((p) => p.id == id);
    if (idx != -1) {
      kAllPeople[idx].isConnected = !kAllPeople[idx].isConnected;
      notifyListeners();
    }
  }

  void toggleFavoritePerson(String id) {
    final idx = kAllPeople.indexWhere((p) => p.id == id);
    if (idx != -1) {
      kAllPeople[idx].isFavorite = !kAllPeople[idx].isFavorite;
      notifyListeners();
    }
  }

  ZinkoPerson? getPersonById(String id) {
    try {
      return kAllPeople.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Events ─────────────────────────────────────────────────
  List<ZinkoEvent> get allEvents => kAllEvents;

  List<ZinkoEvent> get registeredEvents =>
      kAllEvents.where((e) => e.isRegistered).toList();

  List<ZinkoEvent> get favoriteEvents =>
      kAllEvents.where((e) => e.isFavorite).toList();

  void toggleFavoriteEvent(String id) {
    final idx = kAllEvents.indexWhere((e) => e.id == id);
    if (idx != -1) {
      kAllEvents[idx].isFavorite = !kAllEvents[idx].isFavorite;
      notifyListeners();
    }
  }

  void registerEvent(String id) {
    final idx = kAllEvents.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final event = kAllEvents[idx];
      event.isRegistered = true;

      // Add to bookings list so it shows in My Bookings screen
      addBooking(ZinkoBooking(
        id: 'eb_${event.id}_${DateTime.now().millisecondsSinceEpoch}',
        placeId: event.id,
        placeName: event.title,
        location: event.location,
        imageUrl: event.imageUrl,
        date: DateTime.now(), // For simplicity in this demo
        timeSlot: 'Event Registration',
        tableNumber: 'N/A',
        subtotal: 0,
        tax: 0,
        total: 0,
        placeType: PlaceType.event,
        isCompleted: false,
      ));

      notifyListeners();
    }
  }

  // ── Posts (community) ──────────────────────────────────────
  List<ZinkoPost> get posts => kAllPosts;

  void toggleLikePost(String id) {
    final idx = kAllPosts.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final post = kAllPosts[idx];
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
      notifyListeners();
    }
  }

  // ── Groups ─────────────────────────────────────────────────
  List<ZinkoGroup> get groups => kAllGroups;

  void toggleJoinGroup(String id) {
    final idx = kAllGroups.indexWhere((g) => g.id == id);
    if (idx != -1) {
      kAllGroups[idx].isJoined = !kAllGroups[idx].isJoined;
      notifyListeners();
    }
  }

  // ── Connections (Requests) ─────────────────────────────────
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

  List<ZinkoConnection> get connectionRequests =>
      List.unmodifiable(_connectionRequests);

  void acceptConnection(ZinkoConnection request) {
    _connectionRequests.removeWhere((c) => c.id == request.id);
    final index = kAllChats.indexWhere((c) => c.name == request.name);
    if (index == -1) {
      kAllChats.insert(
        0,
        ZinkoChat(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  List<ZinkoConnection> get connections => kAllConnections;

  void toggleConnectUser(String id) {
    final idx = kAllConnections.indexWhere((c) => c.id == id);
    if (idx != -1) {
      kAllConnections[idx].isConnected = !kAllConnections[idx].isConnected;
      notifyListeners();
    }
  }

  // ── Chats ──────────────────────────────────────────────────
  List<ZinkoChat> get chats => kAllChats;

  int get totalUnread => kAllChats.fold(0, (sum, c) => sum + c.unreadCount);

  // ── Global wishlist (combined favourites) ──────────────────
  int get totalFavorites =>
      favoritePlaces.length + favoritePeople.length + favoriteEvents.length;
}
