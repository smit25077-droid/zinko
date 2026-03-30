enum BookingPlaceType { cafe, coworking, office, event }

class BookingEntity {
  final String id;
  final String placeId;
  final String placeName;
  final String location;
  final String imageUrl;
  final DateTime date;
  final String timeSlot;
  final String tableNumber;
  final double subtotal;
  final double tax;
  final double total;
  final bool isCompleted;
  final BookingPlaceType placeType;

  const BookingEntity({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.location,
    required this.imageUrl,
    required this.date,
    required this.timeSlot,
    required this.tableNumber,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.isCompleted = false,
    this.placeType = BookingPlaceType.cafe,
  });
}
