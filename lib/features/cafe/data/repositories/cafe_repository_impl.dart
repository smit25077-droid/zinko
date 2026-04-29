import 'package:zinko_app/features/cafe/data/models/cafe_model.dart';

import 'package:zinko_app/features/cafe/domain/entities/cafe_entities.dart';
import 'package:zinko_app/features/cafe/domain/repositories/cafe_repository.dart';
import 'package:zinko_app/features/cafe/data/datasources/cafe_remote_data_source.dart';

class CafeRepositoryImpl implements CafeRepository {
  final CafeRemoteDataSource remoteDataSource;

  CafeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Cafe>> searchCafes(String keyword) async {
    final response = await remoteDataSource.searchCafes(keyword);
    return response.data ?? [];
  }

  @override
  Future<void> toggleWishlist(int cafeId, int userCode) async {
    final response = await remoteDataSource.toggleWishlist(cafeId, userCode);
    if (response.statusCode != 200) {
      throw Exception(response.message);
    }
  }

  @override
  Future<List<Cafe>> getWishlist(int userCode) async {
    final response = await remoteDataSource.getWishlist(userCode);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.message);
    }
    return response.data?.map((e) => CafeModel.fromWishlistJson(e)).toList() ??
        [];
  }
}
