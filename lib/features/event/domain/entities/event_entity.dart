class EventEntity {
  final String id;
  final String title;
  final String category;
  final String date;
  final String month;
  final String location;
  final String price;
  final String hostName;
  final String hostImage;
  final String imageUrl;
  final String description;
  final bool isPremiumOnly;
  final int attendees;
  final bool isFavorite;
  final bool isRegistered;

  const EventEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.month,
    required this.location,
    required this.price,
    required this.hostName,
    required this.hostImage,
    required this.imageUrl,
    this.description = '',
    this.isPremiumOnly = false,
    this.attendees = 0,
    this.isFavorite = false,
    this.isRegistered = false,
  });
}
