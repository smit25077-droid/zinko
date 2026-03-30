import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.category,
    required super.date,
    required super.month,
    required super.location,
    required super.price,
    required super.hostName,
    required super.hostImage,
    required super.imageUrl,
    super.description,
    super.isPremiumOnly,
    super.attendees,
    super.isFavorite,
    super.isRegistered,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      date: json['date'],
      month: json['month'],
      location: json['location'],
      price: json['price'],
      hostName: json['hostName'],
      hostImage: json['hostImage'],
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      isPremiumOnly: json['isPremiumOnly'] ?? false,
      attendees: json['attendees'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      isRegistered: json['isRegistered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'month': month,
      'location': location,
      'price': price,
      'hostName': hostName,
      'hostImage': hostImage,
      'imageUrl': imageUrl,
      'description': description,
      'isPremiumOnly': isPremiumOnly,
      'attendees': attendees,
      'isFavorite': isFavorite,
      'isRegistered': isRegistered,
    };
  }

  EventModel copyWith({
    bool? isFavorite,
    bool? isRegistered,
  }) {
    return EventModel(
      id: id,
      title: title,
      category: category,
      date: date,
      month: month,
      location: location,
      price: price,
      hostName: hostName,
      hostImage: hostImage,
      imageUrl: imageUrl,
      description: description,
      isPremiumOnly: isPremiumOnly,
      attendees: attendees,
      isFavorite: isFavorite ?? this.isFavorite,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
