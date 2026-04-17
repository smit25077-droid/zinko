import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cafe_review_entity.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../datasources/feedback_remote_data_source.dart';
import '../models/cafe_review_request_model.dart';
import '../models/cafe_suggestion_request_model.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitReview({
    required int cafeId,
    required String reviewText,
    required String reviewStar,
    required String userId,
  }) async {
    try {
      await remoteDataSource.submitReview(CafeReviewRequestModel(
        cafeReviewId: 0,
        cafeId: cafeId,
        reviewText: reviewText,
        reviewStar: reviewStar,
        userId: userId,
      ));
      return const Right(null);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Failed to submit review';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitSuggestion({
    required int userCode,
    required String suggestionData,
    required int cafeId,
  }) async {
    try {
      await remoteDataSource.submitSuggestion(CafeSuggestionRequestModel(
        suggestionId: 0,
        userCode: userCode,
        suggestionData: suggestionData,
        cafeId: cafeId,
      ));
      return const Right(null);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Failed to submit suggestion';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CafeReviewEntity>>> getCafeReviews(int cafeId) async {
    try {
      final remoteReviews = await remoteDataSource.getCafeReviews(cafeId);
      return Right(remoteReviews);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Failed to fetch reviews';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
