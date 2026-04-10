import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../models/cafe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CafeRemoteDataSource {
  Future<ApiResponse<List<CafeModel>>> searchCafes(String keyword);
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
}
