import 'package:zinko_app/features/feedback/domain/entities/cafe_review_entity.dart';


class CafeReviewModel extends CafeReviewEntity {
  const CafeReviewModel({
    required super.cafeReviewId,
    required super.cafeId,
    required super.cafeName,
    required super.reviewText,
    required super.reviewDate,
    required super.reviewStar,
    required super.userId,
    required super.isPublish,
    required super.userName,
  });

  factory CafeReviewModel.fromJson(Map<String, dynamic> json) {
    return CafeReviewModel(
      cafeReviewId: json['cafe_review_id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      cafeName: json['cafe_name'] ?? '',
      reviewText: json['review_text'] ?? '',
      reviewDate: DateTime.tryParse(json['review_date'] ?? '') ?? DateTime(0001),
      reviewStar: json['review_star']?.toString() ?? '0',
      userId: json['user_id'] is String ? int.tryParse(json['user_id']) ?? 0 : (json['user_id'] ?? 0),
      isPublish: json['is_publish'] ?? false,
      userName: json['user_name'] ?? '',
    );
  }
}
