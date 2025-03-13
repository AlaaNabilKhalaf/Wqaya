import 'dart:convert';

class VerificationResponse {
  final bool succeeded;
  final String userId;
  final String message;

  VerificationResponse({
    required this.succeeded,
    required this.userId,
    required this.message,
  });

  factory VerificationResponse.fromMap(Map<String, dynamic> map) {
    return VerificationResponse(
      succeeded: map['succeeded'],
      userId: map['userId'],
      message: map['message'],
    );
  }

  factory VerificationResponse.fromJson(String jsonString) {
    return VerificationResponse.fromMap(jsonDecode(jsonString));
  }
}
