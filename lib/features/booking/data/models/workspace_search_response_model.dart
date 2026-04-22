import 'package:zinko_app/features/booking/data/models/workspace_model.dart';

class WorkspaceSearchResponseModel {
  final int statusCode;
  final String message;
  final List<WorkspaceModel> data;
  final String requestId;
  final String timestamp;

  WorkspaceSearchResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.requestId,
    required this.timestamp,
  });

  factory WorkspaceSearchResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceSearchResponseModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => WorkspaceModel.fromJson(item))
          .toList(),
      requestId: json['requestId'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
