import 'package:zinko_app/features/booking/data/models/workspace_model.dart';
import 'package:zinko_app/features/cafe/domain/entities/cafe_entities.dart';

class CafeModel extends Cafe {
  const CafeModel({
    required super.cafeId,
    required super.cafeName,
    required super.description,
    required super.address,
    required super.city,
    required super.pincode,
    required super.latitude,
    required super.longitude,
    required super.phoneNo,
    required super.email,
    required super.ownerName,
    required super.ownerPhoneNo,
    required super.ownerEmail,
    required super.venueType,
    required super.hourRate,
    required super.amenities,
    required super.images,
    required super.timeSlots,
    required super.workspace,
    super.reviews = const [],
    super.isLiked = false,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      email: json['email'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerPhoneNo: json['owner_phone_no'] ?? '',
      ownerEmail: json['owner_email'] ?? '',
      venueType: json['venue_type'] ?? '',
      hourRate: (json['hour_rate'] ?? 0).toDouble(),
      amenities: (json['cafe_amenitites'] as List<dynamic>?)
              ?.map((e) => CafeAmenityModel.fromJson(e))
              .toList() ??
          [],
      images: (json['cafe_images'] as List<dynamic>?)
              ?.map((e) => CafeImageModel.fromJson(e))
              .toList() ??
          [],
      timeSlots: (json['cafe_time_slots'] as List<dynamic>?)
              ?.map((e) => CafeTimeSlotModel.fromJson(e))
              .toList() ??
          [],
      workspace: (json['cafe_work_space'] as List<dynamic>?)
              ?.map((e) => CafeWorkspaceModel.fromJson(e))
              .toList() ??
          [],
      reviews: (json['cafe_reviews'] as List? ?? [])
          .map((r) => WorkspaceReviewModel.fromJson(r))
          .toList(),
      isLiked: json['is_wishlist'] ?? false,
    );
  }

  factory CafeModel.fromWishlistJson(Map<String, dynamic> json) {
    return CafeModel(
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'] ?? '',
      description: '',
      address: '',
      city: '',
      pincode: '',
      latitude: '0',
      longitude: '0',
      phoneNo: '',
      email: '',
      ownerName: '',
      ownerPhoneNo: '',
      ownerEmail: '',
      venueType: '',
      hourRate: 0,
      amenities: [],
      images: [],
      timeSlots: [],
      workspace: [],
      isLiked: json['is_wishlist'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'cafe_id': cafeId,
        'cafe_name': cafeName,
        'description': description,
        'address': address,
        'city': city,
        'pincode': pincode,
        'latitude': latitude,
        'longitude': longitude,
        'phone_no': phoneNo,
        'email': email,
        'owner_name': ownerName,
        'owner_phone_no': ownerPhoneNo,
        'owner_email': ownerEmail,
        'venue_type': venueType,
        'hour_rate': hourRate,
        'cafe_amenitites':
            amenities.map((e) => (e as CafeAmenityModel).toJson()).toList(),
        'cafe_images':
            images.map((e) => (e as CafeImageModel).toJson()).toList(),
        'cafe_time_slots':
            timeSlots.map((s) => (s as CafeTimeSlotModel).toJson()).toList(),
        'cafe_work_space':
            workspace.map((w) => (w as CafeWorkspaceModel).toJson()).toList(),
        'is_wishlist': isLiked,
      };
}

class CafeAmenityModel extends CafeAmenity {
  const CafeAmenityModel({
    required super.amenitiesId,
    required super.amenitiesName,
    required super.isActive,
  });

  factory CafeAmenityModel.fromJson(Map<String, dynamic> json) {
    return CafeAmenityModel(
      amenitiesId: json['amenities_id'] ?? 0,
      amenitiesName: json['amenities_name'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'amenities_id': amenitiesId,
        'amenities_name': amenitiesName,
        'is_active': isActive,
      };
}

class CafeImageModel extends CafeImage {
  const CafeImageModel({
    required super.cafeImageId,
    required super.cafeId,
    required super.fileName,
    required super.filePath,
  });

  factory CafeImageModel.fromJson(Map<String, dynamic> json) {
    return CafeImageModel(
      cafeImageId: json['cafe_image_id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      fileName: json['file_name'] ?? '',
      filePath: (json['file_path'] ?? '').toString().replaceAll('\\', '/'),
    );
  }

  Map<String, dynamic> toJson() => {
        'cafe_image_id': cafeImageId,
        'cafe_id': cafeId,
        'file_name': fileName,
        'file_path': filePath,
      };
}

class CafeTimeSlotModel extends CafeTimeSlot {
  const CafeTimeSlotModel({
    required super.cafeTimeSlotsId,
    required super.cafeId,
    super.cafeName,
    required super.startTime,
    required super.endTime,
    required super.weekDay,
  });

  factory CafeTimeSlotModel.fromJson(Map<String, dynamic> json) {
    return CafeTimeSlotModel(
      cafeTimeSlotsId: json['cafe_time_slots_id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'],
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      weekDay: json['week_day'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cafe_time_slots_id': cafeTimeSlotsId,
        'cafe_id': cafeId,
        'cafe_name': cafeName,
        'start_time': startTime,
        'end_time': endTime,
        'week_day': weekDay,
      };
}

class CafeWorkspaceModel extends CafeWorkspace {
  const CafeWorkspaceModel({
    required super.cafeWorkspacesId,
    required super.cafeId,
    super.cafeName,
    required super.tableName,
    required super.totalSeats,
    required super.isActive,
  });

  factory CafeWorkspaceModel.fromJson(Map<String, dynamic> json) {
    return CafeWorkspaceModel(
      cafeWorkspacesId: json['cafe_workspaces_id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'],
      tableName: json['table_name'] ?? '',
      totalSeats: json['total_seats'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'cafe_workspaces_id': cafeWorkspacesId,
        'cafe_id': cafeId,
        'cafe_name': cafeName,
        'table_name': tableName,
        'total_seats': totalSeats,
        'is_active': isActive,
      };
}
