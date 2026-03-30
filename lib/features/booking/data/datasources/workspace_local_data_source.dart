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
    // Add more here...
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
