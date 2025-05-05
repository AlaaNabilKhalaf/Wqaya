class RayModel {
  final int id;
  final String rayType;
  final String reason;
  final String rayDate;
  final String bodyPart;
  final String imageUrl;

  RayModel({
    required this.id,
    required this.rayType,
    required this.reason,
    required this.rayDate,
    required this.bodyPart,
    required this.imageUrl,
  });

  factory RayModel.fromJson(Map<String, dynamic> json) {
    return RayModel(
      id: json['id'],
      rayType: json['rayType'],
      reason: json['reason'],
      rayDate: json['rayDate'],
      bodyPart: json['bodyPart'],
      imageUrl: json['imageUrl'],
    );
  }
}
