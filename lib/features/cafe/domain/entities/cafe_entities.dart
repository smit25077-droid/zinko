import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart' as booking;

class Cafe extends Equatable {
  final int cafeId;
  final String cafeName;
  final String description;
  final String address;
  final String city;
  final String pincode;
  final String latitude;
  final String longitude;
  final String phoneNo;
  final String email;
  final String ownerName;
  final String ownerPhoneNo;
  final String ownerEmail;
  final String venueType;
  final double hourRate;
  final List<CafeAmenity> amenities;
  final List<CafeImage> images;
  final List<CafeTimeSlot> timeSlots;
  final List<CafeWorkspace> workspace;
  final List<booking.WorkspaceReviewEntity> reviews;
  final bool isLiked;

  const Cafe({
    required this.cafeId,
    required this.cafeName,
    required this.description,
    required this.address,
    required this.city,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.phoneNo,
    required this.email,
    required this.ownerName,
    required this.ownerPhoneNo,
    required this.ownerEmail,
    required this.venueType,
    required this.hourRate,
    required this.amenities,
    required this.images,
    required this.timeSlots,
    required this.workspace,
    this.reviews = const [],
    this.isLiked = false,
  });

  Cafe copyWith({
    int? cafeId,
    String? cafeName,
    String? description,
    String? address,
    String? city,
    String? pincode,
    String? latitude,
    String? longitude,
    String? phoneNo,
    String? email,
    String? ownerName,
    String? ownerPhoneNo,
    String? ownerEmail,
    String? venueType,
    double? hourRate,
    List<CafeAmenity>? amenities,
    List<CafeImage>? images,
    List<CafeTimeSlot>? timeSlots,
    List<CafeWorkspace>? workspace,
    List<booking.WorkspaceReviewEntity>? reviews,
    bool? isLiked,
  }) {
    return Cafe(
      cafeId: cafeId ?? this.cafeId,
      cafeName: cafeName ?? this.cafeName,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      ownerName: ownerName ?? this.ownerName,
      ownerPhoneNo: ownerPhoneNo ?? this.ownerPhoneNo,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      venueType: venueType ?? this.venueType,
      hourRate: hourRate ?? this.hourRate,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      timeSlots: timeSlots ?? this.timeSlots,
      workspace: workspace ?? this.workspace,
      reviews: reviews ?? this.reviews,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
        cafeId,
        cafeName,
        description,
        address,
        city,
        pincode,
        latitude,
        longitude,
        phoneNo,
        email,
        ownerName,
        ownerPhoneNo,
        ownerEmail,
        venueType,
        hourRate,
        amenities,
        images,
        timeSlots,
        workspace,
        reviews,
        isLiked,
      ];
}

class CafeAmenity extends Equatable {
  final int amenitiesId;
  final String amenitiesName;
  final bool isActive;

  const CafeAmenity({
    required this.amenitiesId,
    required this.amenitiesName,
    required this.isActive,
  });

  @override
  List<Object?> get props => [amenitiesId, amenitiesName, isActive];
}

class CafeImage extends Equatable {
  final int cafeImageId;
  final int cafeId;
  final String fileName;
  final String filePath;

  const CafeImage({
    required this.cafeImageId,
    required this.cafeId,
    required this.fileName,
    required this.filePath,
  });

  @override
  List<Object?> get props => [cafeImageId, cafeId, fileName, filePath];
}

class CafeTimeSlot extends Equatable {
  final int cafeTimeSlotsId;
  final int cafeId;
  final String? cafeName;
  final String startTime;
  final String endTime;
  final String weekDay;

  const CafeTimeSlot({
    required this.cafeTimeSlotsId,
    required this.cafeId,
    this.cafeName,
    required this.startTime,
    required this.endTime,
    required this.weekDay,
  });

  @override
  List<Object?> get props =>
      [cafeTimeSlotsId, cafeId, cafeName, startTime, endTime, weekDay];
}

class CafeWorkspace extends Equatable {
  final int cafeWorkspacesId;
  final int cafeId;
  final String? cafeName;
  final String tableName;
  final int totalSeats;
  final bool isActive;

  const CafeWorkspace({
    required this.cafeWorkspacesId,
    required this.cafeId,
    this.cafeName,
    required this.tableName,
    required this.totalSeats,
    required this.isActive,
  });

  @override
  List<Object?> get props =>
      [cafeWorkspacesId, cafeId, cafeName, tableName, totalSeats, isActive];
}
