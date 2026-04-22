import 'package:zinko_app/features/cafe/domain/repositories/cafe_repository.dart';

class ToggleWishlist {
  final CafeRepository repository;

  ToggleWishlist({required this.repository});

  Future<void> call(int cafeId, int userCode) async {
    return await repository.toggleWishlist(cafeId, userCode);
  }
}
