import 'package:flutter/material.dart';
import '../../domain/entities/workspace_entity.dart';

class WorkspaceModel extends WorkspaceEntity {
  const WorkspaceModel({
    required super.id,
    required super.name,
    required super.location,
    required super.distance,
    required super.rating,
    required super.price,
    required super.priceUnit,
    required super.imageUrl,
    required super.images,
    required super.amenities,
    required super.amenityNames,
    required super.perkTags,
    required super.description,
    super.phone = '',
    super.email = '',
    required super.tablesLeft,
    required super.totalSlots,
    super.discount,
    super.discountDesc,
    super.promoCode,
    super.type,
    super.isFavorite,
    super.isBookmarked,
    super.isBooked,
    super.lat,
    super.lng,
    super.reviews,
    super.cafeTimeSlots,
    super.cafeWorkSpaces,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['cafe_images'] as List? ?? [])
        .map((img) {
          String path = img['file_path']?.toString() ?? '';
          path = path.replaceAll('\\', '/');
          if (path.contains('localhost')) {
            path = path.replaceAll(RegExp(r'http://localhost:\d+'), 'http://187.127.135.213:8090');
          }
          return path;
        })
        .where((path) => path.isNotEmpty)
        .toList();

    final firstImageUrl = imagesList.isNotEmpty
        ? imagesList[0]
        : 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=800';

    final amenitiesJson = json['cafe_amenitites'] as List? ?? [];

    return WorkspaceModel(
      id: json['cafe_id'].toString(),
      name: json['cafe_name'] ?? 'Unknown Cafe',
      location: json['address'] ?? '',
      distance: '',
      rating: 0.0,
      price: '',
      priceUnit: '',
      imageUrl: firstImageUrl,
      images: imagesList.isEmpty ? [firstImageUrl] : imagesList,
      amenities: amenitiesJson.map((a) {
        final name = a['amenities_name']?.toString().toLowerCase() ?? '';
        if (name.contains('wifi')) return Icons.wifi;
        if (name.contains('coffee')) return Icons.coffee;
        if (name.contains('tea')) return Icons.emoji_food_beverage;
        if (name.contains('parking')) return Icons.local_parking;
        return Icons.check_circle_outline;
      }).toList(),
      amenityNames: amenitiesJson
          .map((a) => a['amenities_name']?.toString() ?? '')
          .toList(),
      perkTags: const [],
      description: json['description'] ?? '',
      phone: json['phone_no']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      tablesLeft: (json['cafe_work_space'] as List? ?? [])
          .where((w) => (w['is_active'] == true ||
              w['is_active'] == 1 ||
              w['is_active'] == '1'))
          .length,
      totalSlots: (json['cafe_work_space'] as List? ?? []).length,
      lat: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      cafeTimeSlots: (json['cafe_time_slots'] as List? ?? [])
          .map((s) => CafeTimeSlotModel.fromJson(s))
          .toList(),
      cafeWorkSpaces: (json['cafe_work_space'] as List? ??
              json['cafe_workspaces'] as List? ??
              json['cafe_workspace'] as List? ??
              [])
          .map((w) => CafeWorkSpaceModel.fromJson(w))
          .toList(),
    );
  }

  factory WorkspaceModel.fromEntity(WorkspaceEntity entity) {
    return WorkspaceModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      distance: entity.distance,
      rating: entity.rating,
      price: entity.price,
      priceUnit: entity.priceUnit,
      imageUrl: entity.imageUrl,
      images: entity.images,
      amenities: entity.amenities,
      amenityNames: entity.amenityNames,
      perkTags: entity.perkTags,
      description: entity.description,
      phone: entity.phone,
      email: entity.email,
      tablesLeft: entity.tablesLeft,
      totalSlots: entity.totalSlots,
      discount: entity.discount,
      discountDesc: entity.discountDesc,
      promoCode: entity.promoCode,
      type: entity.type,
      isFavorite: entity.isFavorite,
      isBookmarked: entity.isBookmarked,
      isBooked: entity.isBooked,
      lat: entity.lat,
      lng: entity.lng,
      reviews: entity.reviews,
      cafeTimeSlots: entity.cafeTimeSlots,
      cafeWorkSpaces: entity.cafeWorkSpaces,
    );
  }
}

class CafeTimeSlotModel extends CafeTimeSlot {
  const CafeTimeSlotModel({
    required super.id,
    required super.cafeId,
    super.cafeName,
    required super.startTime,
    required super.endTime,
    required super.weekDay,
  });

  factory CafeTimeSlotModel.fromJson(Map<String, dynamic> json) {
    return CafeTimeSlotModel(
      id: json['cafe_time_slots_id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'],
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      weekDay: json['week_day'] ?? '',
    );
  }
}

class CafeWorkSpaceModel extends CafeWorkSpace {
  const CafeWorkSpaceModel({
    required super.id,
    required super.cafeId,
    super.cafeName,
    required super.tableName,
    required super.totalSeats,
    required super.isActive,
  });

  factory CafeWorkSpaceModel.fromJson(Map<String, dynamic> json) {
    final active = json['is_active'];
    return CafeWorkSpaceModel(
      id: json['cafe_workspaces_id'] ?? json['id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'],
      tableName: json['table_name'] ??
          json['tableName'] ??
          'Table ${json['id'] ?? '??'}',
      totalSeats: json['total_seats'] ?? json['totalSeats'] ?? 2,
      isActive: active == true || active == 1 || active == '1',
    );
  }
}
