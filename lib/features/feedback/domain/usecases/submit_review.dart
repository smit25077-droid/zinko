import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/feedback/domain/repositories/feedback_repository.dart';

class SubmitReview implements UseCase<void, SubmitReviewParams> {
  final FeedbackRepository repository;

  SubmitReview(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitReviewParams params) async {
    return await repository.submitReview(
      cafeId: params.cafeId,
      reviewText: params.reviewText,
      reviewStar: params.reviewStar,
      userId: params.userId,
    );
  }
}

class SubmitReviewParams {
  final int cafeId;
  final String reviewText;
  final String reviewStar;
  final String userId;

  SubmitReviewParams({
    required this.cafeId,
    required this.reviewText,
    required this.reviewStar,
    required this.userId,
  });
}
