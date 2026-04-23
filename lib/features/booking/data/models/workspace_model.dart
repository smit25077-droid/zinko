import 'package:flutter/material.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';

class WorkspaceModel extends WorkspaceEntity {
  const WorkspaceModel({
    required super.id,
    required super.name,
    required super.location,
    required super.price,
    required super.imageUrl,
    required super.images,
    required super.amenities,
    required super.amenityNames,
    required super.description,
    super.phone = '',
    super.email = '',
    required super.tablesLeft,
    required super.totalSlots,
    super.isFavorite = false,
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

    final amenitiesJson = (json['cafe_amenitites'] as List? ??
        json['cafe_amenities'] as List? ??
        json['amenities'] as List? ??
        []);

    final reviewsJson = (json['cafe_reviews'] as List? ??
        json['reviews'] as List? ??
        json['review'] as List? ??
        []);

    final timeSlotsJson = (json['cafe_time_slots'] as List? ??
        json['time_slots'] as List? ??
        json['slots'] as List? ??
        []);

    final workSpacesJson = (json['cafe_work_space'] as List? ??
        json['cafe_work_spaces'] as List? ??
        json['cafe_workspaces'] as List? ??
        json['work_spaces'] as List? ??
        []);

    return WorkspaceModel(
      id: (json['cafe_id'] ?? json['id'] ?? '').toString(),
      name: json['cafe_name']?.toString() ??
          json['name']?.toString() ??
          'Unknown Cafe',
      location: json['address']?.toString() ??
          json['location']?.toString() ??
          '',
      price: (json['hour_rate'] ?? json['price'] ?? '0').toString(),
      imageUrl: firstImageUrl,
      images: imagesList.isEmpty ? [firstImageUrl] : imagesList,
      amenities: amenitiesJson.map((a) {
        final name = (a['amenities_name'] ?? a['name'])?.toString().toLowerCase() ?? '';
        if (name.contains('wifi')) return Icons.wifi;
        if (name.contains('coffee')) return Icons.coffee;
        if (name.contains('tea')) return Icons.emoji_food_beverage;
        if (name.contains('parking')) return Icons.local_parking;
        return Icons.check_circle_outline;
      }).toList(),
      amenityNames: amenitiesJson
          .map((a) => (a['amenities_name'] ?? a['name'])?.toString() ?? '')
          .toList(),
      description: json['description']?.toString() ?? '',
      phone: (json['phone_no'] ?? json['phone'] ?? '').toString(),
      email: json['email']?.toString() ?? '',
      tablesLeft: workSpacesJson
          .where((w) => (w['is_active'] == true ||
              w['is_active'] == 1 ||
              w['is_active'] == '1'))
          .length,
      totalSlots: workSpacesJson.length,
      isFavorite: json['is_wishlist'] == true ||
          json['is_wishlist'] == 1 ||
          json['is_favorite'] == true ||
          json['is_favorite'] == 1,
      lat: double.tryParse(json['latitude']?.toString() ??
              json['lat']?.toString() ??
              '0') ??
          0.0,
      lng: double.tryParse(json['longitude']?.toString() ??
              json['lng']?.toString() ??
              '0') ??
          0.0,
      reviews: reviewsJson
          .map((r) => WorkspaceReviewModel.fromJson(r))
          .toList(),
      cafeTimeSlots: timeSlotsJson
          .map((s) => CafeTimeSlotModel.fromJson(s))
          .toList(),
      cafeWorkSpaces: workSpacesJson
          .map((w) => CafeWorkSpaceModel.fromJson(w))
          .toList(),
    );
  }

  factory WorkspaceModel.fromEntity(WorkspaceEntity entity) {
    return WorkspaceModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      price: entity.price,
      imageUrl: entity.imageUrl,
      images: entity.images,
      amenities: entity.amenities,
      amenityNames: entity.amenityNames,
      description: entity.description,
      phone: entity.phone,
      email: entity.email,
      tablesLeft: entity.tablesLeft,
      totalSlots: entity.totalSlots,
      isFavorite: entity.isFavorite,
      lat: entity.lat,
      lng: entity.lng,
      reviews: entity.reviews,
      cafeTimeSlots: entity.cafeTimeSlots,
      cafeWorkSpaces: entity.cafeWorkSpaces,
    );
  }
}

class WorkspaceReviewModel extends WorkspaceReviewEntity {
  const WorkspaceReviewModel({
    required super.id,
    required super.cafeId,
    super.cafeName,
    required super.userName,
    required super.avatarUrl,
    required super.rating,
    required super.comment,
    required super.date,
    required super.userId,
    required super.isPublish,
  });

  factory WorkspaceReviewModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceReviewModel(
      id: int.tryParse(json['cafe_review_id']?.toString() ?? '0') ?? 0,
      cafeId: int.tryParse(json['cafe_id']?.toString() ?? '0') ?? 0,
      cafeName: json['cafe_name']?.toString(),
      userName: json['user_name']?.toString() ?? 'Anonymous',
      avatarUrl:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(json['user_name']?.toString() ?? 'A')}&background=random',
      rating: double.tryParse(json['review_star']?.toString() ?? '0') ?? 0.0,
      comment: json['review_text']?.toString() ?? '',
      date: json['review_date']?.toString() ?? '',
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      isPublish: json['is_publish'] == true || json['is_publish'] == 1 || json['is_publish'] == '1',
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
      id: int.tryParse(json['cafe_time_slots_id']?.toString() ??
              json['id']?.toString() ??
              '0') ??
          0,
      cafeId: int.tryParse(
              json['cafe_id']?.toString() ?? json['cafeId']?.toString() ?? '0') ??
          0,
      cafeName: json['cafe_name']?.toString(),
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      weekDay: json['week_day']?.toString() ?? '',
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
      id: int.tryParse(json['cafe_workspaces_id']?.toString() ??
              json['cafe_workspace_id']?.toString() ??
              json['id']?.toString() ??
              '0') ??
          0,
      cafeId: int.tryParse(
              json['cafe_id']?.toString() ?? json['cafeId']?.toString() ?? '0') ??
          0,
      cafeName: json['cafe_name']?.toString(),
      tableName: json['table_name']?.toString() ??
          json['tableName']?.toString() ??
          'Table ${json['id'] ?? '??'}',
      totalSeats: int.tryParse(json['total_seats']?.toString() ??
              json['total_seats']?.toString() ??
              '2') ??
          2,
      isActive: active == true || active == 1 || active == '1',
    );
  }
}
