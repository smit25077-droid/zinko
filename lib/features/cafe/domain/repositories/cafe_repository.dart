import 'package:zinko_app/features/cafe/domain/entities/cafe_entities.dart';

abstract class CafeRepository {
  Future<List<Cafe>> searchCafes(String keyword);
  Future<void> toggleWishlist(int cafeId, int userCode, bool isWishlist);
  Future<List<Cafe>> getWishlist(int userCode);
}
