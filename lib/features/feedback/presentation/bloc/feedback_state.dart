import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/feedback/domain/entities/cafe_review_entity.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackReviewsLoaded extends FeedbackState {
  final List<CafeReviewEntity> reviews;
  const FeedbackReviewsLoaded(this.reviews);
  @override
  List<Object?> get props => [reviews];
}

class FeedbackError extends FeedbackState {
  final String message;
  const FeedbackError(this.message);
  @override
  List<Object?> get props => [message];
}

class FeedbackSuccess extends FeedbackState {
  final String message;
  const FeedbackSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
