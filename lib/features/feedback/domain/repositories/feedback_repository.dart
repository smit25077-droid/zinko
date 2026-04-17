import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cafe_review_entity.dart';

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
