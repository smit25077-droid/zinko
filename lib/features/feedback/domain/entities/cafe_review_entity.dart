import 'package:equatable/equatable.dart';

class CafeReviewEntity extends Equatable {
  final int cafeReviewId;
  final int cafeId;
  final String cafeName;
  final String reviewText;
  final DateTime reviewDate;
  final String reviewStar;
  final int userId;
  final bool isPublish;

  const CafeReviewEntity({
    required this.cafeReviewId,
    required this.cafeId,
    required this.cafeName,
    required this.reviewText,
    required this.reviewDate,
    required this.reviewStar,
    required this.userId,
    required this.isPublish,
  });

  @override
  List<Object?> get props => [
        cafeReviewId,
        cafeId,
        cafeName,
        reviewText,
        reviewDate,
        reviewStar,
        userId,
        isPublish,
      ];
}
