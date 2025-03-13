import 'dart:convert';


class RegisterResponse {
  final bool succeeded;
  final String message;
  final dynamic errors;
  final UserModel data;
  final String token;
  final String refreshToken;

  RegisterResponse({
    required this.succeeded,
    required this.message,
    required this.errors,
    required this.data,
    required this.token,
    required this.refreshToken,
  });

  factory RegisterResponse.fromJson(String source) {
    final map = json.decode(source);
    return RegisterResponse(
      succeeded: map['succeeded'],
      message: map['message'],
      errors: map['errors'],
      data: UserModel.fromJson(map['data']),
      token: map['token'],
      refreshToken: map['refreshToken'],
    );
  }
}
class UserModel {
  final String id;
  final String email;
  final String phoneNumber;
  final String displayedName;
  final String? nationalId;
  final int age;
  final String? address;
  final String? governorate;
  final String? imgUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.displayedName,
    this.nationalId,
    required this.age,
    this.address,
    this.governorate,
    this.imgUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(), // Ensure id is a string
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      displayedName: json['displayedName'],
      nationalId: json['nationalId'],
      age: json['age'] ?? 0, // Default to 0 if age is null
      address: json['address'],
      governorate: json['governorate'],
      imgUrl: json['imgUrl'],
    );
  }
}