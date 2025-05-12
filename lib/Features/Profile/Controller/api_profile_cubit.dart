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
      final token = await CacheHelper().getData(key: 'token'); // تأكد إن التوكن محفوظ هنا

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

}
