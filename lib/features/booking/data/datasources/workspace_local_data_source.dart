import 'package:flutter/material.dart';
import '../models/workspace_model.dart';
import '../../domain/entities/workspace_entity.dart';

abstract class WorkspaceLocalDataSource {
  Future<List<WorkspaceEntity>> getWorkspaces();
  Future<void> toggleFavorite(String id);
  Future<void> toggleBookmark(String id);
}

class WorkspaceLocalDataSourceImpl implements WorkspaceLocalDataSource {
  final List<WorkspaceEntity> _workspaces = [
    WorkspaceModel(
      id: 'p1',
      name: 'Cafe Work',
      location: 'Canary Wharf, London',
      distance: '8.0 km away',
      rating: 4.5,
      price: '£5',
      priceUnit: '/hr',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.wifi, Icons.coffee_outlined, Icons.restaurant, Icons.power],
      amenityNames: ['WiFi', 'Coffee', 'Food', 'Power Sockets'],
      perkTags: ['10% off on Food', 'Unlimited Refills'],
      description: 'Work from a cozy cafe with artisanal coffee and quiet corners. Ideal for writers and solo founders.',
      tablesLeft: 8,
      totalSlots: 15,
      discount: '20% OFF',
      discountDesc: 'On all beverages',
      promoCode: 'Code: CAFE20',
      type: WorkspaceType.cafe,
      lat: 51.5033,
      lng: -0.0195,
      reviews: [
        WorkspaceReviewEntity(
          userName: 'Alice M.',
          avatarUrl: 'https://i.pravatar.cc/60?u=a1',
          rating: 5.0,
          comment: 'Love this place, great WiFi and vibes!',
          timeAgo: '2 days ago',
        ),
      ],
    ),
    WorkspaceModel(
      id: 'p2',
      name: 'WorkHub Prime',
      location: 'Shoreditch, London',
      distance: '3.2 km away',
      rating: 4.8,
      price: '£25',
      priceUnit: '/day',
      imageUrl: 'https://images.unsplash.com/photo-1497215728101-856f4ea42174?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.wifi, Icons.print_rounded, Icons.meeting_room_rounded, Icons.kitchen_rounded],
      amenityNames: ['High-Speed WiFi', 'Printing', 'Meeting Rooms', 'Kitchen'],
      perkTags: ['Free Snacks', 'Networking Events'],
      description: 'A professional coworking space in the heart of Tech City. Perfect for teams and high-growth startups requiring top-tier facilities.',
      tablesLeft: 5,
      totalSlots: 40,
      discount: '15% OFF',
      discountDesc: 'On monthly passes',
      promoCode: 'Code: HUB15',
      type: WorkspaceType.coworking,
      lat: 51.5245,
      lng: -0.0787,
      reviews: [
        WorkspaceReviewEntity(
          userName: 'James K.',
          avatarUrl: 'https://i.pravatar.cc/60?u=j1',
          rating: 4.5,
          comment: 'Best professional vibe in London.',
          timeAgo: '1 week ago',
        ),
      ],
    ),
    WorkspaceModel(
      id: 'p3',
      name: 'The Quiet Zone',
      location: 'South Kensington, London',
      distance: '12.5 km away',
      rating: 4.9,
      price: '£15',
      priceUnit: '/hr',
      imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.wifi, Icons.library_books_rounded, Icons.no_photography_rounded, Icons.volume_off_rounded],
      amenityNames: ['Fiber WiFi', 'Research Library', 'No Calls Zone', 'Silent Area'],
      perkTags: ['Focus Guaranteed', 'Premium Literature'],
      description: 'The ultimate sanctuary for deep work. This space is strictly silent, designed for academics, researchers, and serious creators.',
      tablesLeft: 3,
      totalSlots: 10,
      discount: 'FREE',
      discountDesc: 'First hour for students',
      promoCode: 'Code: FOCUS01',
      type: WorkspaceType.coworking,
      lat: 51.4944,
      lng: -0.1763,
      reviews: [
        WorkspaceReviewEntity(
          userName: 'Sarah L.',
          avatarUrl: 'https://i.pravatar.cc/60?u=s1',
          rating: 5.0,
          comment: 'Extremely peaceful. Finished my thesis here!',
          timeAgo: '4 days ago',
        ),
      ],
    ),
    WorkspaceModel(
      id: 'p4',
      name: 'UrbanPods',
      location: 'Westminster, London',
      distance: '0.5 km away',
      rating: 4.7,
      price: '£12',
      priceUnit: '/hr',
      imageUrl: 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.wifi, Icons.private_connectivity_rounded, Icons.ac_unit_rounded, Icons.monitor_rounded],
      amenityNames: ['Secure WiFi', 'Private Pod', 'Climate Control', 'Dual Monitors'],
      perkTags: ['Soundproof', '24/7 Access'],
      description: 'Private, secure micro-offices located right in the city center. Ideal for confidential calls and ultra-focused tasks.',
      tablesLeft: 12,
      totalSlots: 20,
      discount: '10% OFF',
      discountDesc: 'For evening bookings',
      promoCode: 'Code: POD10',
      type: WorkspaceType.coworking,
      lat: 51.4993,
      lng: -0.1273,
      reviews: [],
    ),
    WorkspaceModel(
      id: 'p5',
      name: 'SkyLounge Library',
      location: 'Chelsea, London',
      distance: '15.2 km away',
      rating: 4.6,
      price: '£30',
      priceUnit: '/day',
      imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.wifi, Icons.wine_bar_rounded, Icons.camera_alt_rounded, Icons.restaurant_menu_rounded],
      amenityNames: ['Sky WiFi', 'Bar Access', 'Viewpoint', 'Gourmet Lunch'],
      perkTags: ['Golden Hour Access', 'VIP Lounge'],
      description: 'A luxurious combination of a workspace and a high-end lounge. Work with a breathtaking view of the London skyline.',
      tablesLeft: 2,
      totalSlots: 15,
      discount: 'COMPLIMENTARY',
      discountDesc: 'Welcome drink included',
      promoCode: 'Code: SKYDRINK',
      type: WorkspaceType.cafe,
      lat: 51.4875,
      lng: -0.1682,
      reviews: [
        WorkspaceReviewEntity(
          userName: 'Robert D.',
          avatarUrl: 'https://i.pravatar.cc/60?u=r1',
          rating: 4.5,
          comment: 'Incredible views and very comfortable chairs.',
          timeAgo: '3 weeks ago',
        ),
      ],
    ),
    WorkspaceModel(
      id: 'p6',
      name: 'The Executive Suite',
      location: 'Mayfair, London',
      distance: '1.2 km away',
      rating: 5.0,
      price: '£85',
      priceUnit: '/day',
      imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.support_agent_rounded, Icons.lock_rounded, Icons.videocam_rounded, Icons.coffee_maker_rounded],
      amenityNames: ['Reception', 'Secure Lock', 'Video Conf.', 'Nespresso'],
      perkTags: ['Luxury Setting', 'Concierge'],
      description: 'A prestigious private office in the heart of Mayfair. Designed for senior executives requiring discretion and a high-status environment.',
      tablesLeft: 1,
      totalSlots: 4,
      discount: 'NEW',
      discountDesc: 'Launch offer',
      promoCode: 'Code: MAYFAIR',
      type: WorkspaceType.office,
      lat: 51.5113,
      lng: -0.1457,
      reviews: [],
    ),
    WorkspaceModel(
      id: 'p7',
      name: 'Creative Beat Studio',
      location: 'Hackney, London',
      distance: '6.5 km away',
      rating: 4.8,
      price: '£40',
      priceUnit: '/hr',
      imageUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=800&q=80',
      amenities: [Icons.mic_rounded, Icons.album_rounded, Icons.surround_sound_rounded, Icons.wifi_protected_setup_rounded],
      amenityNames: ['Recording Gear', 'Soundproof', 'Control Room', 'Mixing Desk'],
      perkTags: ['Acoustic Treatment', 'Session Support'],
      description: 'A professional recording and creative studio in vibrant Hackney. Equipped with industry-standard gear for musicians and podcasters.',
      tablesLeft: 2,
      totalSlots: 3,
      discount: 'STUDIO',
      discountDesc: 'Off-peak rate',
      promoCode: 'Code: BEAT25',
      type: WorkspaceType.studio,
      lat: 51.5452,
      lng: -0.0553,
      reviews: [
        WorkspaceReviewEntity(
          userName: 'Marcus V.',
          avatarUrl: 'https://i.pravatar.cc/60?u=m2',
          rating: 4.9,
          comment: 'Outstanding acoustics. Highly recommend.',
          timeAgo: '1 day ago',
        ),
      ],
    ),
  ];

  @override
  Future<List<WorkspaceEntity>> getWorkspaces() async {
    return _workspaces;
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final index = _workspaces.indexWhere((w) => w.id == id);
    if (index != -1) {
      final w = _workspaces[index];
      _workspaces[index] = WorkspaceModel.fromEntity(
        WorkspaceEntity(
          id: w.id,
          name: w.name,
          location: w.location,
          distance: w.distance,
          rating: w.rating,
          price: w.price,
          priceUnit: w.priceUnit,
          imageUrl: w.imageUrl,
          amenities: w.amenities,
          amenityNames: w.amenityNames,
          perkTags: w.perkTags,
          description: w.description,
          tablesLeft: w.tablesLeft,
          totalSlots: w.totalSlots,
          discount: w.discount,
          discountDesc: w.discountDesc,
          promoCode: w.promoCode,
          type: w.type,
          isFavorite: !w.isFavorite,
          isBookmarked: w.isBookmarked,
          isBooked: w.isBooked,
          lat: w.lat,
          lng: w.lng,
          reviews: w.reviews,
        ),
      );
    }
  }

  @override
  Future<void> toggleBookmark(String id) async {
    final index = _workspaces.indexWhere((w) => w.id == id);
    if (index != -1) {
      final w = _workspaces[index];
      _workspaces[index] = WorkspaceModel.fromEntity(
        WorkspaceEntity(
          id: w.id,
          name: w.name,
          location: w.location,
          distance: w.distance,
          rating: w.rating,
          price: w.price,
          priceUnit: w.priceUnit,
          imageUrl: w.imageUrl,
          amenities: w.amenities,
          amenityNames: w.amenityNames,
          perkTags: w.perkTags,
          description: w.description,
          tablesLeft: w.tablesLeft,
          totalSlots: w.totalSlots,
          discount: w.discount,
          discountDesc: w.discountDesc,
          promoCode: w.promoCode,
          type: w.type,
          isFavorite: w.isFavorite,
          isBookmarked: !w.isBookmarked,
          isBooked: w.isBooked,
          lat: w.lat,
          lng: w.lng,
          reviews: w.reviews,
        ),
      );
    }
  }
}
