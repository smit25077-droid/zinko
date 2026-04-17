class CafeSuggestionRequestModel {
  final int suggestionId;
  final int userCode;
  final String suggestionData;
  final int cafeId;

  CafeSuggestionRequestModel({
    required this.suggestionId,
    required this.userCode,
    required this.suggestionData,
    required this.cafeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'suggestion_id': suggestionId,
      'user_code': userCode,
      'suggestion_data': suggestionData,
      'cafe_id': cafeId,
    };
  }
}
