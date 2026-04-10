import '../../domain/entities/cafe_entities.dart';
import '../../domain/repositories/cafe_repository.dart';
import '../datasources/cafe_remote_data_source.dart';

class CafeRepositoryImpl implements CafeRepository {
  final CafeRemoteDataSource remoteDataSource;

  CafeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Cafe>> searchCafes(String keyword) async {
    final response = await remoteDataSource.searchCafes(keyword);
    return response.data ?? [];
  }
}
