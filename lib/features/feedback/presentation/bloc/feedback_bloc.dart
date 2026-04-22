import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/feedback/domain/usecases/get_cafe_reviews.dart';
import 'package:zinko_app/features/feedback/domain/usecases/submit_review.dart';
import 'package:zinko_app/features/feedback/domain/usecases/submit_suggestion.dart';
import 'package:zinko_app/features/feedback/presentation/bloc/feedback_event.dart';
import 'package:zinko_app/features/feedback/presentation/bloc/feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final GetCafeReviews getCafeReviews;
  final SubmitReview submitReview;
  final SubmitSuggestion submitSuggestion;

  FeedbackBloc({
    required this.getCafeReviews,
    required this.submitReview,
    required this.submitSuggestion,
  }) : super(FeedbackInitial()) {
    on<GetCafeReviewsEvent>(_onGetCafeReviews);
    on<SubmitReviewEvent>(_onSubmitReview);
    on<SubmitSuggestionEvent>(_onSubmitSuggestion);
  }

  Future<void> _onGetCafeReviews(
      GetCafeReviewsEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackLoading());
    final result = await getCafeReviews(event.cafeId);
    result.fold(
      (failure) => emit(FeedbackError(failure.message)),
      (reviews) => emit(FeedbackReviewsLoaded(reviews)),
    );
  }

  Future<void> _onSubmitReview(
      SubmitReviewEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackLoading());
    final result = await submitReview(SubmitReviewParams(
      cafeId: event.cafeId,
      reviewText: event.reviewText,
      reviewStar: event.reviewStar,
      userId: event.userId,
    ));
    result.fold(
      (failure) => emit(FeedbackError(failure.message)),
      (_) => emit(const FeedbackSuccess('Review submitted successfully!')),
    );
  }

  Future<void> _onSubmitSuggestion(
      SubmitSuggestionEvent event, Emitter<FeedbackState> emit) async {
    emit(FeedbackLoading());
    final result = await submitSuggestion(SubmitSuggestionParams(
      userCode: event.userCode,
      suggestionData: event.suggestionData,
      cafeId: event.cafeId,
    ));
    result.fold(
      (failure) => emit(FeedbackError(failure.message)),
      (_) => emit(const FeedbackSuccess('Suggestion submitted successfully!')),
    );
  }
}
