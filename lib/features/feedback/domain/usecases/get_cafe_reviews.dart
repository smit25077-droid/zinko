import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/feedback/domain/entities/cafe_review_entity.dart';
import 'package:zinko_app/features/feedback/domain/repositories/feedback_repository.dart';

class GetCafeReviews implements UseCase<List<CafeReviewEntity>, int> {
  final FeedbackRepository repository;

  GetCafeReviews(this.repository);

  @override
  Future<Either<Failure, List<CafeReviewEntity>>> call(int cafeId) async {
    return await repository.getCafeReviews(cafeId);
  }
}
