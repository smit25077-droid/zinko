import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/network/api_endpoints.dart';
import 'package:zinko_app/core/network/dio_client.dart';
import 'package:zinko_app/features/feedback/data/models/cafe_review_model.dart';
import 'package:zinko_app/features/feedback/data/models/cafe_review_request_model.dart';
import 'package:zinko_app/features/feedback/data/models/cafe_suggestion_request_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitReview(CafeReviewRequestModel request);
  Future<void> submitSuggestion(CafeSuggestionRequestModel request);
  Future<List<CafeReviewModel>> getCafeReviews(int cafeId);
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final DioClient client;
  final SharedPreferences sharedPreferences;

  FeedbackRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<void> submitReview(CafeReviewRequestModel request) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.post(
      ApiEndpoints.addReview,
      data: request.toJson(),
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Failed to submit review');
    }
  }

  @override
  Future<void> submitSuggestion(CafeSuggestionRequestModel request) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.post(
      ApiEndpoints.addSuggestion,
      data: request.toJson(),
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Failed to submit suggestion');
    }
  }

  @override
  Future<List<CafeReviewModel>> getCafeReviews(int cafeId) async {
    final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
    String? token;
    if (jsonString != null) {
      token = Map<String, dynamic>.from(json.decode(jsonString))['token'];
    }

    final response = await client.get(
      ApiEndpoints.getCafeReviews(cafeId),
      options: Options(
        headers: token != null ? {'Authentication': token} : {},
      ),
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      return data.map((json) => CafeReviewModel.fromJson(json)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch reviews');
    }
  }
}
