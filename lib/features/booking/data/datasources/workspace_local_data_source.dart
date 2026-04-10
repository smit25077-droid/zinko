import '../models/workspace_model.dart';
import '../../domain/entities/workspace_entity.dart';

abstract class WorkspaceLocalDataSource {
  Future<List<WorkspaceEntity>> getWorkspaces();
  Future<void> toggleFavorite(String id);
  Future<void> toggleBookmark(String id);
}

class WorkspaceLocalDataSourceImpl implements WorkspaceLocalDataSource {
  final List<WorkspaceEntity> _workspaces = [];

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
          images: w.images,
          amenities: w.amenities,
          amenityNames: w.amenityNames,
          perkTags: w.perkTags,
          description: w.description,
          phone: w.phone,
          email: w.email,
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
          cafeTimeSlots: w.cafeTimeSlots,
          cafeWorkSpaces: w.cafeWorkSpaces,
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
          images: w.images,
          amenities: w.amenities,
          amenityNames: w.amenityNames,
          perkTags: w.perkTags,
          description: w.description,
          phone: w.phone,
          email: w.email,
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
          cafeTimeSlots: w.cafeTimeSlots,
          cafeWorkSpaces: w.cafeWorkSpaces,
        ),
      );
    }
  }
}
