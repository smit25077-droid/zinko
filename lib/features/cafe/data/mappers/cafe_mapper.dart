import 'package:flutter/material.dart';
import '../../domain/entities/cafe_entities.dart' as cafe_ent;
import '../../../booking/domain/entities/workspace_entity.dart' as booking;

class CafeMapper {
  static booking.WorkspaceEntity toWorkspaceEntity(cafe_ent.Cafe cafe) {
    return booking.WorkspaceEntity(
      id: cafe.cafeId.toString(),
      name: cafe.cafeName,
      location: cafe.address,
      price: cafe.hourRate.toStringAsFixed(0),
      imageUrl: cafe.images.isNotEmpty
          ? cafe.images.first.filePath
          : 'https://images.unsplash.com/photo-1554118811-1e0d58224f24',
      images: cafe.images.isNotEmpty
          ? cafe.images.map((i) => i.filePath).toList()
          : ['https://images.unsplash.com/photo-1554118811-1e0d58224f24'],
      amenities: cafe.amenities
          .map((a) => _mapAmenityToIcon(a.amenitiesName))
          .toList(),
      amenityNames: cafe.amenities.map((a) => a.amenitiesName).toList(),
      description: cafe.description,
      phone: cafe.phoneNo,
      email: cafe.email,
      tablesLeft: cafe.workspace.where((w) => w.isActive).length,
      totalSlots: cafe.workspace.length,
      lat: double.tryParse(cafe.latitude) ?? 0.0,
      lng: double.tryParse(cafe.longitude) ?? 0.0,
      cafeWorkSpaces: cafe.workspace
          .map((w) => booking.CafeWorkSpace(
                id: w.cafeWorkspacesId,
                cafeId: w.cafeId,
                cafeName: w.cafeName,
                tableName: w.tableName,
                totalSeats: w.totalSeats,
                isActive: w.isActive,
              ))
          .toList(),
      cafeTimeSlots: cafe.timeSlots
          .map((s) => booking.CafeTimeSlot(
                id: s.cafeTimeSlotsId,
                cafeId: s.cafeId,
                cafeName: s.cafeName,
                startTime: s.startTime,
                endTime: s.endTime,
                weekDay: s.weekDay,
              ))
          .toList(),
    );

  }

  static IconData _mapAmenityToIcon(String name) {
    switch (name.toLowerCase()) {
      case 'high speed wifi':
        return Icons.wifi;
      case 'coffee':
        return Icons.coffee;
      case 'tea':
        return Icons.emoji_food_beverage;
      case 'phone booth':
        return Icons.phone_android;
      case 'water':
        return Icons.water_drop;
      case 'paid parking':
      case 'free parking':
        return Icons.local_parking;
      default:
        return Icons.star;
    }
  }
}
