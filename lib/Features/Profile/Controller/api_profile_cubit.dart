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
        CacheHelper().saveData(key: 'currentPassword', value: newPassword);
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
          CacheHelper().removeData(key: 'token');
          CacheHelper().removeData(key: 'profileImage');
        }
        emit(DeleteUserSuccessState(message: "تم حذف الحساب بنجاح"));
      } else {
        emit(DeleteUserFailState(error: "فشل في حذف المستخدم"));
      }
    } on DioException catch (e) {
      emit(DeleteUserFailState(error: e.response?.data?.toString() ?? "خطأ غير معروف"));
    }
  }






}
