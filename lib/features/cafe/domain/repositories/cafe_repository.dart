import '../entities/cafe_entities.dart';

abstract class CafeRepository {
  Future<List<Cafe>> searchCafes(String keyword);
}
