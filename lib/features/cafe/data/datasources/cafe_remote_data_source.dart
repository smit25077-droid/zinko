import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/network/api_endpoints.dart';
import 'package:zinko_app/core/network/api_response.dart';
import 'package:zinko_app/core/network/dio_client.dart';
import 'package:zinko_app/features/cafe/data/models/cafe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CafeRemoteDataSource {
  Future<ApiResponse<List<CafeModel>>> searchCafes(String keyword);
  Future<ApiResponse<dynamic>> toggleWishlist(int cafeId, int userCode, bool isWishlist);
  Future<ApiResponse<List<Map<String, dynamic>>>> getWishlist(int userCode);
}

class CafeRemoteDataSourceImpl implements CafeRemoteDataSource {
  final DioClient client;
  final SharedPreferences sharedPreferences;

  CafeRemoteDataSourceImpl(
      {required this.client, required this.sharedPreferences});

  @override
  Future<ApiResponse<List<CafeModel>>> searchCafes(String keyword) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      ApiEndpoints.searchCafes,
      queryParameters: {'keyword': keyword},
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    return ApiResponse<List<CafeModel>>.fromJson(
      response.data,
      (data) =>
          (data as List<dynamic>).map((e) => CafeModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> toggleWishlist(int cafeId, int userCode, bool isWishlist) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final data = {
      'cafe_id': cafeId,
      'user_code': userCode.toString(),
      'is_wishlist': isWishlist,
    };
    final options = Options(
      headers: token != null ? {'Authentication': token} : {},
    );

    final response = await client.post(
      ApiEndpoints.toggleWishlist,
      data: data,
      options: options,
    );

    return ApiResponse<dynamic>.fromJson(
      response.data,
      (data) => data,
    );
  }

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> getWishlist(
      int userCode) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      ApiEndpoints.getWishlist,
      queryParameters: {'user_code': userCode.toString()},
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    return ApiResponse<List<Map<String, dynamic>>>.fromJson(
      response.data,
      (data) => (data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
    );
  }
}
