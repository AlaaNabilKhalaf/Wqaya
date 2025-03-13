import 'dart:convert';

class UserModel {
  String id;
  String email;
  String? bio;
  String? phoneNumber;
  String userName;
  String displayedName;
  String? profilePic;
  String? address;
  List<dynamic> experiences;

  UserModel({
    required this.id,
    required this.email,
    this.bio,
    this.phoneNumber,
    required this.userName,
    required this.displayedName,
    this.profilePic,
    this.address,
    required this.experiences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      bio: json['bio'],
      phoneNumber: json['phoneNumber'],
      userName: json['userName'],
      displayedName: json['displayedName'],
      profilePic: json['profilePic'],
      address: json['address'],
      experiences: json['experiences'] ?? [],
    );
  }
}

class LoginResponse {
  bool succeeded;
  String message;
  String token;
  String refreshToken;
  UserModel userData;

  LoginResponse({
    required this.succeeded,
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.userData,
  });

  factory LoginResponse.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return LoginResponse(
      succeeded: json['succeeded'],
      message: json['message'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      userData: UserModel.fromJson(json['userData']),
    );
  }
}
