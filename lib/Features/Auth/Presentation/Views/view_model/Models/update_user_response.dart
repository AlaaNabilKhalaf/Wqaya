class UpdateUserResponse {
  final bool succeeded;
  final String message;
  final UserModel data;

  UpdateUserResponse({
    required this.succeeded,
    required this.message,
    required this.data,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      succeeded: json['succeeded'],
      message: json['message'],
      data: UserModel.fromJson(json['data']),
    );
  }
}

// Model for the User Data
class UserModel {
  final String id;
  final String email;
  final String phoneNumber;
  final String displayedName;
  final String nationalId;
  final int age;
  final String address;
  final String governorate;
  final String? imgUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.displayedName,
    required this.nationalId,
    required this.age,
    required this.address,
    required this.governorate,
    this.imgUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      displayedName: json['displayedName'],
      nationalId: json['nationalId'],
      age: json['age'],
      address: json['adress'], // Note: API uses "adress" instead of "address"
      governorate: json['governorate'],
      imgUrl: json['imgUrl'],
    );
  }
}