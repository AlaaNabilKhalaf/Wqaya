import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'Models/user_model.dart';

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
      emit(SignInLoadingState());

      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Authentication/Login',
        data: {
          'phone': phoneNumber,
          'password': password,
        },
        options: Options(validateStatus: (status) => true), // allow capturing all status codes
      );

      if (response.statusCode == 200 && response.data['succeeded'] == true) {
        debugPrint(response.data.toString());
        CacheHelper().saveData(key: 'token', value: response.data['token']);
        CacheHelper().saveData(key: 'email', value: response.data['userData']['email']);
        CacheHelper().saveData(key: 'profileImage', value: response.data['userData']['imgUrl']);
        emit(SignInSuccessState(token: response.data['token']));
      } else {
        final errorMessage = response.data['message'] ?? 'فشل تسجيل الدخول';
        debugPrint("Sign-in failed: $errorMessage");
        emit(SignInFailureState(error: errorMessage));
      }

    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError = e.response?.data['message']?.toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      debugPrint("Server error: $serverError");
      emit(SignInFailureState(error: serverError));
    }
  }

  final Dio _dio = Dio();

  Future<void> registerPatient({
    required String email,
    required String displayedName,
    required String phoneNumber,
    required String password,
    required String confirmedPassword,
    required BuildContext context,
  }) async {
    // Input validation
    if (email.isEmpty || !email.contains('@')) {
      emit(RegisterFailureState(message: "يرجى إدخال بريد إلكتروني صالح"));
      return;
    }

    if (displayedName.isEmpty) {
      emit(RegisterFailureState(message: "الاسم مطلوب"));
      return;
    }

    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      emit(RegisterFailureState(message: "يرجى إدخال رقم هاتف صالح"));
      return;
    }

    if (password.length < 6) {
      emit(RegisterFailureState(message: "الرقم السري يجب أن يحتوي على 6 أحرف على الأقل"));
      return;
    }

    if (password != confirmedPassword) {
      emit(RegisterFailureState(message: "كلمتا المرور غير متطابقتين"));
      return;
    }

    emit(RegisterLoadingState());

    try {
      final response = await _dio.post(
        'https://wqaya.runasp.net/api/Patient/RegisterPatient',
        data: {
          "email": email,
          "displayedName": displayedName,
          "phoneNumber": phoneNumber,
          "password": password,
          "confirmedPassword": confirmedPassword,
        },
        options: Options(
          validateStatus: (status) => true,
        )
      );

      final data = response.data;
      if (data['succeeded'] == true) {
        CacheHelper().saveData(key: 'UserId', value: data['userId']);
        final storedUserId = CacheHelper().getData(key: 'UserId');
        debugPrint(storedUserId);
        CacheHelper().saveData(key: 'displayedName', value: displayedName.toString());
        CacheHelper().saveData(key: 'phoneNumber', value: data['phoneNumber'].toString());
        CacheHelper().saveData(key: 'email', value: data['email'].toString());
        CacheHelper().saveData(key: 'profileImage', value: data['imgUrl'].toString());
        emit(RegisterSuccessState(message: data['message'], userId: data['userId'].toString()));
      } else {
        emit(RegisterFailureState(message :data['message'] ?? 'فشل التسجيل'));
      }
    } catch (e) {
      emit(RegisterFailureState(message: "حدث خطأ أثناء الاتصال بالخادم"));
    }
}

  void verifyEmail({required String verificationCode}) async {
    try {
      emit(VerificationLoadingState());

      final storedUserId = CacheHelper().getData(key: 'UserId');
      debugPrint('UserId: $storedUserId');
      debugPrint('VerificationCode: $verificationCode');

      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Patient/VerifyPatient?userId=$storedUserId&verificationCode=$verificationCode',
        options: Options(
          validateStatus: (status) => true, // Accept all status codes
        ),
      );

      final responseData = response.data;
      debugPrint('Response: $responseData');

      if (response.statusCode == 200 && responseData['succeeded'] == true) {
        CacheHelper().saveData(key: 'token', value: responseData['token']);
        emit(VerificationSuccessState(message: responseData['message'] ?? "تم التأكيد بنجاح"));
      } else {
        final errorMessage = responseData['message'] ?? "حدث خطأ غير متوقع";
        emit(VerificationFailureState(error: errorMessage));
      }

    } catch (e) {
      String serverError = "خطأ غير متوقع من الخادم";
      if (e is DioException) {
        serverError = e.response?.data['message'] ?? "خطأ من السيرفر بدون تفاصيل";
      }
      emit(VerificationFailureState(error: serverError));
    }
  }

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
      emit(FollowUpLoadingState());

      const url = 'https://wqaya.runasp.net/api/Patient/UpdateUser';
      final headers = {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = {
        'displayedName': displayedName,
        'nationalId': nationalId,
        'age': age,
        'gender': gender,
        'adress': address,
        'governorate': governorate,
      };

      final response = await _dio.put(
        url,
        options: Options(headers: headers, validateStatus: (status) => true),
        data: body,
      );

      final responseData = response.data;
      debugPrint('Update User Response: $responseData');

      if (response.statusCode == 200 && responseData['succeeded'] == true) {
        emit(FollowUpSuccessState());
        debugPrint('User updated successfully: ${responseData['message']}');
      } else {
        final errorMessage = responseData['message'] ?? 'فشل في تحديث البيانات';
        emit(FollowUpFailureState(error: errorMessage));
        debugPrint('Failed to update user: $errorMessage');
      }
    } catch (e) {
      String serverError = 'حدث خطأ غير متوقع';
      if (e is DioException) {
        serverError = e.response?.data['message'] ?? 'خطأ من السيرفر بدون تفاصيل';
      }
      emit(FollowUpFailureState(error: serverError));
      debugPrint('Unexpected error: $serverError');
    }
  }



  void forgotPassword({required String email}) async {
    try {
      emit(ForgotPasswordLoadingState());
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Authentication/RequestResetPassword?email=$email',
        options: Options(headers: {'accept': '*/*'}),
      );
      if (response.statusCode == 200) {
        CacheHelper().saveData(key: 'emailToResetPass',value: email);
        emit(ForgotPasswordSuccessState(message: 'Please check your email'));
      } else {
        debugPrint(response.data['message']);
        emit(ForgotPasswordFailureState(error: 'Failed to send OTP'));
      }
    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError =
            e.response?.data['message'].toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      debugPrint("server :$serverError");
      emit(ForgotPasswordFailureState(error: serverError));
    }
  }

  void checkCode({required String code}) async {
    try {
      emit(CheckCodeLoadingState());

      debugPrint("Sending Email: ${CacheHelper().getData(key: 'emailToResetPass')}");
      debugPrint("Sending Code: $code");

      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Authentication/CheckCode',
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

      debugPrint(" Server Response: ${response.data}");
      CacheHelper().saveData(key: 'resetPassCode', value:code );
      emit(CheckCodeSuccessState(message: 'Code verified successfully'));
    } catch (e) {
      String serverError = "خطأ غير معروف من السيرفر";
      if (e is DioException) {
        serverError =
            e.response?.data.toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      debugPrint(" CheckCode Error: $serverError");
      emit(CheckCodeFailureState(error: serverError));
    }
  }

  void resetPassword({
    required String code,
    required String? newPassword,
  }) async {
    try {
      debugPrint("Resetting password with: ");
      debugPrint("Email: ${CacheHelper().getData(key: 'emailToResetPass')}");
      debugPrint("Code: $code");
      debugPrint("New Password: $newPassword");

      if (CacheHelper().getData(key: 'emailToResetPass') == null) {
        emit(ResetPasswordFailure(error: "No saved email found in Cubit!"));
        return;
      }

      emit(ResetPasswordLoading());
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/Authentication/ResetPassword',
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
      debugPrint("Response data: ${response.data}");
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
        serverError = e.response?.data['message'].toString() ?? "خطأ من السيرفر بدون تفاصيل";
      }
      debugPrint(serverError);
      emit(ResetPasswordFailure(error: serverError));
    }
  }

  Future<void> googleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await CacheHelper().clearData();
      debugPrint("done");
      if (context.mounted) {}
      emit(AuthInitial());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
