import 'package:flutter/material.dart';

enum WorkspaceType { cafe, coworking, office, event, studio }

class WorkspaceEntity {
  final String id;
  final String name;
  final String location;
  final String distance;
  final double rating;
  final String price;
  final String priceUnit;
  final String imageUrl;
  final List<IconData> amenities;
  final List<String> amenityNames;
  final List<String> perkTags;
  final String description;
  final int tablesLeft;
  final int totalSlots;
  final String? discount;
  final String? discountDesc;
  final String? promoCode;
  final WorkspaceType type;
  final bool isFavorite;
  final bool isBookmarked;
  final bool isBooked;
  final double lat;
  final double lng;
  final List<WorkspaceReviewEntity> reviews;

  const WorkspaceEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.price,
    required this.priceUnit,
    required this.imageUrl,
    required this.amenities,
    required this.amenityNames,
    required this.perkTags,
    required this.description,
    required this.tablesLeft,
    required this.totalSlots,
    this.discount,
    this.discountDesc,
    this.promoCode,
    this.type = WorkspaceType.cafe,
    this.isFavorite = false,
    this.isBookmarked = false,
    this.isBooked = false,
    this.lat = 51.5074,
    this.lng = -0.1278,
    this.reviews = const [],
  });
}

class WorkspaceReviewEntity {
  final String userName;
  final String avatarUrl;
  final double rating;
  final String comment;
  final String timeAgo;

  const WorkspaceReviewEntity({
    required this.userName,
    required this.avatarUrl,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}
