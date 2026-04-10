import '../models/event_model.dart';
import '../../../../models/app_models.dart' hide EventModel;

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents();
  Future<EventModel> toggleFavoriteEvent(String id);
  Future<EventModel> registerEvent(String id);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final List<EventModel> _mockEvents = kAllEvents
      .map((e) => EventModel(
            id: e.id,
            title: e.title,
            category: e.category,
            date: e.date,
            month: e.month,
            location: e.location,
            price: e.price,
            hostName: e.hostName,
            hostImage: e.hostImage,
            imageUrl: e.imageUrl,
            description: e.description,
            isPremiumOnly: e.isPremiumOnly,
            attendees: e.attendees,
            isFavorite: e.isFavorite,
            isRegistered: e.isRegistered,
          ))
      .toList();

  @override
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockEvents;
  }

  @override
  Future<EventModel> toggleFavoriteEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updated = _mockEvents[index]
          .copyWith(isFavorite: !_mockEvents[index].isFavorite);
      _mockEvents[index] = updated;
      return updated;
    }
    throw Exception('Event not found');
  }

  @override
  Future<EventModel> registerEvent(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updated = _mockEvents[index].copyWith(isRegistered: true);
      _mockEvents[index] = updated;
      return updated;
    }
    throw Exception('Event not found');
  }
}
