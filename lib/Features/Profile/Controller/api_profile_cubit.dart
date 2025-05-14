import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:wqaya/Features/Profile/Controller/api_profile_states.dart';
import 'package:dio/dio.dart';
import '../../../Core/cache/cache_helper.dart';


class ApiProfileCubit extends Cubit<ApiProfileStates> {
  ApiProfileCubit() : super(InitialApiProfileState());

  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wqaya.runasp.net"));

  Future<void> changePassword(String currentPassword, String newPassword, String confirmNewPassword) async {
    emit(ChangePasswordLoadingState());
    try {
      final token = await CacheHelper().getData(key: 'token');

      final response = await _dio.post(
        "/api/Authentication/ChangePassword",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        }),
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );

      debugPrint("Response data: ${response.data}");

      final Map<String, dynamic> data = response.data;
      if (data.containsKey('succeeded') && data['succeeded'] == true) {
        final String msg = data['message'] ?? 'Password reset successfully';
        CacheHelper().removeData(key: 'currentPassword');
        CacheHelper().saveData(key: 'currentPassword', value: newPassword.toString());
        emit(ChangePasswordSuccessState(message: msg));
      } else {
        final String msg = data['message'] ?? "لم تتم العملية من فضلك حاول في وقت اخر";
        emit(ChangePasswordFailState(message: msg));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'];
      String errorText;

      if (errorMsg is List) {
        errorText = errorMsg.isNotEmpty ? errorMsg[0].toString() : "خطأ غير معروف";
      } else if (errorMsg is String) {
        errorText = errorMsg;
      } else {
        errorText = "حدث خطأ غير متوقع";
      }

      emit(ChangePasswordFailState(message: errorText));
    }
  }


  Future<void> deleteUser(String email) async {
    emit(DeleteUserLoadingState());

    final token = CacheHelper().getData(key: 'token');

    try {
      final response = await _dio.delete(
        "/api/Authentication/DeleteUser",
        queryParameters: {"email": email},
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "accept": "*/*",
        }),
      );

      if (response.statusCode == 200 && response.data['succeeded'] == true) {
        {
          // CacheHelper().removeData(key: 'token');
          // CacheHelper().removeData(key: 'profileImage');
          // CacheHelper().removeData(key: 'currentPassword');
          CacheHelper().clearData();
        }
        emit(DeleteUserSuccessState(message: "تم حذف الحساب بنجاح"));
      } else {
        emit(DeleteUserFailState(error: "فشل في حذف المستخدم"));
      }
    } on DioException catch (e) {
      emit(DeleteUserFailState(error: e.response?.data?.toString() ?? "خطأ غير معروف"));
    }
  }

  // Request to send verification code to email
  Future<void> requestChangePhone(String newPhone) async {
    emit(RequestChangePhoneLoadingState());
    final token = await CacheHelper().getData(key: 'token');

    try {
      final response = await _dio.post(
        "/api/Authentication/RequestChangePhone",
        queryParameters: {
          "newPhone": newPhone,
        },
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.data['succeeded'] == true) {
        emit(RequestChangePhoneSuccessState(message: response.data['message']));
      } else {
        emit(RequestChangePhoneFailState(message: response.data['message'] ?? "فشل في إرسال كود التحقق"));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? "حدث خطأ أثناء إرسال كود التحقق";
      emit(RequestChangePhoneFailState(message: errorMsg));
    }
  }

  // Request to confirm and change phone number using verification code
  Future<void> changePhone(String newPhone, int code) async {
    emit(ChangePhoneLoadingState());
    final token = await CacheHelper().getData(key: 'token');

    try {
      final response = await _dio.post(
        "/api/Authentication/ChangePhone",
        options: Options(headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        data: {
          "newPhone": newPhone,
          "code": code,
        },
      );

      if (response.data['succeeded'] == true) {
        CacheHelper().removeData(key: 'phoneNumber');
        CacheHelper().saveData(key: 'phoneNumber', value: newPhone.toString());

        emit(ChangePhoneSuccessState(message: response.data['message']));
      } else {
        emit(ChangePhoneFailState(message: response.data['message'] ?? "فشل في تغيير رقم الهاتف"));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? "حدث خطأ أثناء تغيير الرقم";
      emit(ChangePhoneFailState(message: errorMsg));
    }
  }


  Future<void> updateUserData({
    required String displayedName,
    required String nationalId,
    required int age,
    required String gender,
    required String address,
    required String governorate,
  }) async {
    emit(UpdateUserLoadingState());

    final token = await CacheHelper().getData(key: 'token');

    debugPrint('🔐 Token: $token');
    debugPrint('📦 Sending data:');
    debugPrint('Name: $displayedName');
    debugPrint('National ID: $nationalId');
    debugPrint('Age: $age');
    debugPrint('Gender: $gender');
    debugPrint('Address: $address');
    debugPrint('Governorate: $governorate');

    try {
      final response = await _dio.put(
        "/api/Patient/UpdateUser",
        options: Options(headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        data: {
          "displayedName": displayedName,
          "nationalId": nationalId,
          "age": age,
          "gender": gender,
          "adress": address,
          "governorate": governorate
        },
      );


      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');

      if (response.data['succeeded'] == true) {

        //Remove Old
        CacheHelper().removeData(key: 'displayedName');
        CacheHelper().removeData(key: 'nationalId', );
        CacheHelper().removeData(key: 'age');
        CacheHelper().removeData(key: 'gender');
        CacheHelper().removeData(key: 'address');
        CacheHelper().removeData(key: 'governorate');

        //Save New
        CacheHelper().saveData(key: 'displayedName', value: displayedName.toString());
        CacheHelper().saveData(key: 'nationalId', value: nationalId.toString());
        CacheHelper().saveData(key: 'age', value: age.toString());
        CacheHelper().saveData(key: 'gender', value: gender.toString());
        CacheHelper().saveData(key: 'address', value: address.toString() );
        CacheHelper().saveData(key: 'governorate', value: governorate.toString());

        emit(UpdateUserSuccessState(message: response.data['message']));
      } else {
        emit(UpdateUserFailState(
          error: response.data['message'] ?? "فشل في تحديث البيانات",
        ));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? "حدث خطأ أثناء تحديث البيانات";

      debugPrint('❌ DioException caught');
      debugPrint('Status Code: ${e.response?.statusCode}');
      debugPrint('Response Data: ${e.response?.data}');
      debugPrint('Message: $errorMsg');

      emit(UpdateUserFailState(error: errorMsg));
    } catch (e) {
      debugPrint('❗ Unexpected error: $e');
      emit(UpdateUserFailState(error: "حدث خطأ غير متوقع"));
    }
  }








}
