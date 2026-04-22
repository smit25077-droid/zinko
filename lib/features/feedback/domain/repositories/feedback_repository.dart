import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/feedback/domain/entities/cafe_review_entity.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, void>> submitReview({
    required int cafeId,
    required String reviewText,
    required String reviewStar,
    required String userId,
  });
  Future<Either<Failure, void>> submitSuggestion({
    required int userCode,
    required String suggestionData,
    required int cafeId,
  });
  Future<Either<Failure, List<CafeReviewEntity>>> getCafeReviews(int cafeId);
}
