import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/feedback/domain/repositories/feedback_repository.dart';

class SubmitSuggestion implements UseCase<void, SubmitSuggestionParams> {
  final FeedbackRepository repository;

  SubmitSuggestion(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitSuggestionParams params) async {
    return await repository.submitSuggestion(
      userCode: params.userCode,
      suggestionData: params.suggestionData,
      cafeId: params.cafeId,
    );
  }
}

class SubmitSuggestionParams {
  final int userCode;
  final String suggestionData;
  final int cafeId;

  SubmitSuggestionParams({
    required this.userCode,
    required this.suggestionData,
    required this.cafeId,
  });
}
