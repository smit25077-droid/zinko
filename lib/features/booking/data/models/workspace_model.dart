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
    required super.amenities,
    required super.amenityNames,
    required super.perkTags,
    required super.description,
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
  });

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
      amenities: entity.amenities,
      amenityNames: entity.amenityNames,
      perkTags: entity.perkTags,
      description: entity.description,
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
    );
  }
}
