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
      final response = await _dio.post(
        "/api/Authentication/ChangePassword",
        options: Options(headers:
        {
          'Content-Type': 'application/json',
          'accept': '*/*',
        }),

        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );
      debugPrint("Response data: ${response.data}");

      //Getting Data
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('succeeded') && data['succeeded'] == true) {
        final String msg = data['message'] ?? 'Password reset successfully';

        //Caching
        CacheHelper().saveData(key: 'currentPassword', value: newPassword);
        //Emitting
        emit(ChangePasswordSuccessState(message: msg));
      } else {

        final String msg = data['message'] ?? "لم تتم العملية من فضلك حاول في وقت اخر";
        emit(ChangePasswordFailState(message: msg));
      }
    } on DioException catch (e) {
      debugPrint(e.response?.data['message'].toString() );
      emit(ChangePasswordFailState(message: e.response?.data['message'].toString()  ?? " خطأ من السيرفر بدون تفاصيل" ));
    }
  }
}
