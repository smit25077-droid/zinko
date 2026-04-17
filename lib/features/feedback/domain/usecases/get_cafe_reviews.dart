import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cafe_review_entity.dart';
import '../repositories/feedback_repository.dart';

class GetCafeReviews implements UseCase<List<CafeReviewEntity>, int> {
  final FeedbackRepository repository;

  GetCafeReviews(this.repository);

  @override
  Future<Either<Failure, List<CafeReviewEntity>>> call(int cafeId) async {
    return await repository.getCafeReviews(cafeId);
  }
}
