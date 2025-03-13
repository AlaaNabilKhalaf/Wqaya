import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/Models/updateUserResponse.dart';
import 'Models/UserModel.dart';
import 'Models/register.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  LoginResponse? loginResponse;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '163119622890-p749ij53hmaapfagn9lpapps0j9phf32.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Future<void> signInWithGoogle() async {
  //   emit(SigninLoadingState());
  //
  //   try {
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser != null) {
  //       // Obtain the auth details from the request
  //       final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //       UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //       String? token = await userCredential.user?.getIdToken();
  //       final response = await Dio().post(
  //         '${baseUrl}Authentication/google-login',
  //         queryParameters: {'token': token},
  //         options: Options(
  //           headers: {'Content-Type': 'application/json'}, // Set headers
  //         ),
  //       );
  //       final responseBody = response.data;
  //       print(responseBody);
  //       await CacheHelper().clearData();
  //       final userData = responseBody['userData'];
  //       if (userData != null) {
  //       }
  //
  //       if (response.statusCode == 200) {
  //         CacheHelper().saveData(key: 'token', value: responseBody['token']);
  //         print(responseBody['token']);
  //         CacheHelper()
  //             .saveData(key: 'displayedName', value: responseBody['userData']['displayedName']);
  //         CacheHelper().saveData(key: 'email', value: responseBody['userData']['email']);
  //         emit(SigninSuccessState(token: '${responseBody['token']}'));
  //       } else {
  //         print(responseBody['message']);
  //         emit(SigninFailureState(error: responseBody['message']));
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     emit(SigninFailureState(error: e.toString()));
  //   }
  // }
  Future<void> signIn({required String phoneNumber, required String password}) async {
    try {
      emit(SigninLoadingState());
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/LoginPatient',
        data: {
          'phone': phoneNumber,
          'password': password,
        },
      );
      if(response.statusCode==200){
        print(response.data);
        CacheHelper().saveData(key: 'token', value: response.data['token']);
        emit(SigninSuccessState(token: response.data['token']));
      }else{
        print("here ${response.data}");
      emit(SigninFailureState(error: response.data['message']));
    }} catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError =
            e.response?.data['message'].toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      print("serverError :$serverError");
      emit(SigninFailureState(error: serverError));
    }
  }

  void register(
      {required String name,
      required String email,
      required String password,
      required String phoneNumber,
      required String confirmedPassword}) async {
    try {
      emit(RegisterLoadingState());
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/RegisterPatient',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        }),
        data: {
          'displayedName': name,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'confirmedPassword': confirmedPassword
        },
      );
      if (response.statusCode == 200) {
        print("here");
        print(response.data);
        final verificationResponse =
            VerificationResponse.fromJson(jsonEncode(response.data));
        CacheHelper()
            .saveData(key: 'UserId', value: verificationResponse.userId);
        emit(RegisterSuccessState(message: verificationResponse.message));
      } else {
        print(response.data['message']);
        emit(RegisterFailureState(error: response.data['message']));
      }
    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError = e.response?.data['errors'].toString() ??
            "خطأ من السيرفر بدون تفاصيل";
        print(e.response?.data);
      }
      print(e.toString());
      emit(RegisterFailureState(error: serverError));
    }
  }

  void verifyEmail({required String verificationCode}) async {
    try {
      emit(VerificationLoadingState());
      final storedUserId = CacheHelper.sharedPreferences.get('UserId');
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/VerifyEmail',
        queryParameters: {
          'UserId': storedUserId,
          'verifiedcode': verificationCode,
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
        CacheHelper().saveData(key: 'token', value: response.data['token']);
        emit(VerificationSuccessState(message: "تم التأكيد بنجاح"));
      } else {
        print(response.data);
        emit(VerificationFailureState(
            error: "Unexpected status code: ${response.statusCode}"));
      }
    } catch (e) {
      String serverError = "";
      if (e is DioException) {
        print(1);
        serverError =
            e.response?.data.toString() ?? "خطأ من السيرفر بدون تفاصيل";
        print(serverError);
      }
      print(serverError);
      emit(VerificationFailureState(error: serverError));
    }
  }

  final Dio _dio = Dio();

  Future<void> updateUser({
    required String token,
    required String displayedName,
    required String nationalId,
    required dynamic age,
    required String gender,
    required String address,
    required String governorate,
  }) async {
    try {
      print(1);
      emit(FollowUpLoadingState());
      const url = 'https://wqaya.runasp.net/api/Patient/UpdateUser';
      final headers = {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Define the request body
      final body = {
        'displayedName': displayedName,
        'nationalId': nationalId,
        'age': age,
        'gender': gender,
        'adress': address,
        'governorate': governorate,
      };
      print(2);
      final response = await _dio.put(
        url,
        options: Options(headers: headers),
        data: body,
      );
      print(3);
      // Check if the request was successful
      if (response.statusCode == 200) {
        print(4);
        final responseData = response.data;
        print('Update User Response: $responseData');
        emit(FollowUpSuccessState());
        final updateResponse = UpdateUserResponse.fromJson(responseData);
        if (updateResponse.succeeded) {
          print('User updated successfully: ${updateResponse.message}');
        } else {
          print(5);
          emit(FollowUpFailureState());
          print('Failed to update user: ${updateResponse.message}');
        }
      } else {
        print(6);
        emit(FollowUpFailureState());
        print('Failed to update user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  void forgotPassword({required String email}) async {
    try {
      emit(ForgotPasswordLoadingState());
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/ForgetPassword?Email=$email',
        options: Options(headers: {'accept': '*/*'}),
      );
      if (response.statusCode == 200) {
        emit(ForgotPasswordSuccessState(message: 'Please check your email'));
      } else {
        print(response.data['message']);
        emit(ForgotPasswordFailureState(error: 'Failed to send OTP'));
      }
    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError =
            e.response?.data['message'].toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      print("server :$serverError");
      emit(ForgotPasswordFailureState(error: serverError));
    }
  }

  void checkCode({required String code}) async {
    try {
      emit(CheckCodeLoadingState());

      print("Sending Email: ${CacheHelper().getData(key: 'emailToResetPass')}");
      print("Sending Code: $code");

      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/CheckCode',
        queryParameters: {
          'Email': CacheHelper().getData(key: 'emailToResetPass'),
          'Code': code,
        },
        options: Options(
          headers: {
            'accept': '*/*',
          },
        ),
      );

      print(" Server Response: ${response.data}");
      CacheHelper().saveData(key: 'resetPassCode', value:code );
      emit(CheckCodeSuccessState(message: 'Code verified successfully'));
    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError =
            e.response?.data.toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      print(" CheckCode Error: $serverError");
      emit(CheckCodeFailureState(error: serverError));
    }
  }

  void resetPassword({
    required String code,
    required String? newPassword,
  }) async {
    try {
      print("Resetting password with: ");
      print("Email: ${CacheHelper().getData(key: 'emailToResetPass')}");
      print("Code: $code");
      print("New Password: $newPassword");

      if (CacheHelper().getData(key: 'emailToResetPass') == null) {
        emit(ResetPasswordFailure(error: "No saved email found in Cubit!"));
        return;
      }

      emit(ResetPasswordLoading());
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/ResetPassword',
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': CacheHelper().getData(key: 'emailToResetPass'),
          'code': code,
          'newpassword': newPassword,
        },
      );
      print("Response data: ${response.data}");
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('succeeded') && data['succeeded'] == true) {
        final String msg = data['message'] ?? 'Password reset successfully';
        emit(ResetPasswordSuccess(message: msg));
      } else {
        final String msg = data['message'] ?? 'Failed to reset password';
        emit(ResetPasswordFailure(error: msg));
      }
    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError =
            e.response?.data['message'].toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      print(serverError);
      emit(ResetPasswordFailure(error: serverError));
    }
  }

  Future<void> googleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await CacheHelper().clearData();
      print("done");
      if (context.mounted) {}
      emit(AuthInitial());
    } catch (e) {
      print(e.toString());
    }
  }
}
