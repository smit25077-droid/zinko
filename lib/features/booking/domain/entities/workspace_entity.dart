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
  final List<String> images;
  final List<IconData> amenities;
  final List<String> amenityNames;
  final List<String> perkTags;
  final String description;
  final String phone;
  final String email;
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
  final List<CafeTimeSlot> cafeTimeSlots;
  final List<CafeWorkSpace> cafeWorkSpaces;

  const WorkspaceEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.price,
    required this.priceUnit,
    required this.imageUrl,
    this.images = const [],
    required this.amenities,
    required this.amenityNames,
    required this.perkTags,
    required this.description,
    this.phone = '',
    this.email = '',
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
    this.cafeTimeSlots = const [],
    this.cafeWorkSpaces = const [],
  });

  WorkspaceEntity copyWith({
    String? id,
    String? name,
    String? location,
    String? distance,
    double? rating,
    String? price,
    String? priceUnit,
    String? imageUrl,
    List<String>? images,
    List<IconData>? amenities,
    List<String>? amenityNames,
    List<String>? perkTags,
    String? description,
    String? phone,
    String? email,
    int? tablesLeft,
    int? totalSlots,
    String? discount,
    String? discountDesc,
    String? promoCode,
    WorkspaceType? type,
    bool? isFavorite,
    bool? isBookmarked,
    bool? isBooked,
    double? lat,
    double? lng,
    List<WorkspaceReviewEntity>? reviews,
    List<CafeTimeSlot>? cafeTimeSlots,
    List<CafeWorkSpace>? cafeWorkSpaces,
  }) {
    return WorkspaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      amenityNames: amenityNames ?? this.amenityNames,
      perkTags: perkTags ?? this.perkTags,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      tablesLeft: tablesLeft ?? this.tablesLeft,
      totalSlots: totalSlots ?? this.totalSlots,
      discount: discount ?? this.discount,
      discountDesc: discountDesc ?? this.discountDesc,
      promoCode: promoCode ?? this.promoCode,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isBooked: isBooked ?? this.isBooked,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      reviews: reviews ?? this.reviews,
      cafeTimeSlots: cafeTimeSlots ?? this.cafeTimeSlots,
      cafeWorkSpaces: cafeWorkSpaces ?? this.cafeWorkSpaces,
    );
  }
}

class CafeTimeSlot {
  final int id;
  final int cafeId;
  final String? cafeName;
  final String startTime;
  final String endTime;
  final String weekDay;

  const CafeTimeSlot({
    required this.id,
    required this.cafeId,
    this.cafeName,
    required this.startTime,
    required this.endTime,
    required this.weekDay,
  });
}

class CafeWorkSpace {
  final int id;
  final int cafeId;
  final String? cafeName;
  final String tableName;
  final int totalSeats;
  final bool isActive;

  const CafeWorkSpace({
    required this.id,
    required this.cafeId,
    this.cafeName,
    required this.tableName,
    required this.totalSeats,
    required this.isActive,
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
