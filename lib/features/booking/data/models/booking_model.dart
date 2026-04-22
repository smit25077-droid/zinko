import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.placeId,
    required super.placeName,
    required super.location,
    required super.imageUrl,
    required super.date,
    required super.timeSlot,
    required super.tableNumber,
    required super.subtotal,
    required super.tax,
    required super.total,
    super.isCompleted,
    super.placeType,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      placeId: json['placeId'] as String,
      placeName: json['placeName'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: json['timeSlot'] as String,
      tableNumber: json['tableNumber'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      placeType: _parsePlaceType(json['placeType'] as String?),
    );
  }

  static BookingPlaceType _parsePlaceType(String? type) {
    switch (type) {
      case 'coworking':
        return BookingPlaceType.coworking;
      case 'office':
        return BookingPlaceType.office;
      case 'event':
        return BookingPlaceType.event;
      default:
        return BookingPlaceType.cafe;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeId': placeId,
      'placeName': placeName,
      'location': location,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'tableNumber': tableNumber,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'isCompleted': isCompleted,
      'placeType': placeType.name,
    };
  }
}
