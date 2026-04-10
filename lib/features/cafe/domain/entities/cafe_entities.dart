import 'package:equatable/equatable.dart';

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
  });

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
