class CafeReviewRequestModel {
  final int cafeReviewId;
  final int cafeId;
  final String reviewText;
  final String reviewStar;
  final String userId;

  CafeReviewRequestModel({
    required this.cafeReviewId,
    required this.cafeId,
    required this.reviewText,
    required this.reviewStar,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'cafe_review_id': cafeReviewId,
      'cafe_id': cafeId,
      'review_text': reviewText,
      'review_star': reviewStar,
      'user_id': userId,
    };
  }
}
