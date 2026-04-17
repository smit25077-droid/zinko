import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
  @override
  List<Object?> get props => [];
}

class GetCafeReviewsEvent extends FeedbackEvent {
  final int cafeId;
  const GetCafeReviewsEvent(this.cafeId);
  @override
  List<Object?> get props => [cafeId];
}

class SubmitReviewEvent extends FeedbackEvent {
  final int cafeId;
  final String reviewText;
  final String reviewStar;
  final String userId;
  const SubmitReviewEvent({
    required this.cafeId,
    required this.reviewText,
    required this.reviewStar,
    required this.userId,
  });
  @override
  List<Object?> get props => [cafeId, reviewText, reviewStar, userId];
}

class SubmitSuggestionEvent extends FeedbackEvent {
  final int userCode;
  final String suggestionData;
  final int cafeId;
  const SubmitSuggestionEvent({
    required this.userCode,
    required this.suggestionData,
    required this.cafeId,
  });
  @override
  List<Object?> get props => [userCode, suggestionData, cafeId];
}
