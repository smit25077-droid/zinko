import '../entities/cafe_entities.dart';
import '../repositories/cafe_repository.dart';

class SearchCafes {
  final CafeRepository repository;

  SearchCafes({required this.repository});

  Future<List<Cafe>> call(String keyword) async {
    return await repository.searchCafes(keyword);
  }
}
