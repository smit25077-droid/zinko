import 'package:zinko_app/features/cafe/domain/entities/cafe_entities.dart';
import 'package:zinko_app/features/cafe/domain/repositories/cafe_repository.dart';

class GetWishlist {
  final CafeRepository repository;

  GetWishlist({required this.repository});

  Future<List<Cafe>> call(int userCode) async {
    return await repository.getWishlist(userCode);
  }
}
