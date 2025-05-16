import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Rays/presentation/views/view_model/models/ray_model.dart';

part 'ray_cubit_state.dart';

class RayCubit extends Cubit<RayCubitState> {
  RayCubit() : super(RayCubitInitialState());
  Future<void> getUserRays() async {
    emit(RayLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/Ray/GetByMhId',
        options: Options(headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'accept': '*/*',
        }),
      );
      final data = response.data['data'] as List;
      print(data);
      final rays = data.map((json) => RayModel.fromJson(json)).toList();
      emit(RaySuccess(rays));
    } catch (e) {
      emit(RayError('فشل في جلب الأشعة'));
    }
  }
  Future<void> addUserRay({
    required String rayType , required String reason , required String rayDate , required String bodyPart , required MultipartFile image ,
  }) async {
    final dio = Dio();
    final formData = FormData.fromMap({
      "RayType": rayType,
      "Reason": reason,
      "RayDate": rayDate,
      "BodyPart": bodyPart,
      "ImageFile": image,
      "MedicalHistoryId": "",
    });
    try {
      emit (AddRayLoading());
      final response = await dio.post(
        'https://wqaya.runasp.net/api/Ray',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.data['succeeded'] == true) {
        emit (AddRaySuccess());
      } else {
        emit (AddRayError());
        throw Exception("Failed to add ray");
      }
    } catch (e) {
      emit (AddRayError());
    }
  }

  Future<void> deleteUserRay({required int rayId}) async {
    final dio = Dio();
    final String token = CacheHelper().getData(key: 'token');

    try {
      emit(DeleteRayLoading());

      final response = await dio.delete(
        'https://wqaya.runasp.net/api/Ray/$rayId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(DeleteRaySuccess());
      } else {
        emit(DeleteRayError(message: "حدث خلل أثناء الحذف"));
      }
    } catch (e) {
      emit(DeleteRayError(message: "حدث خلل أثناء الحذف"));
    }
  }
  Future<void> editUserRayWithoutPicture({
    required int rayId,
    required String rayType,
    required String reason,
    required String rayDate,
    required String bodyPart,
  }) async {
    final dio = Dio();

    final Map<String, dynamic> formFields = {
      "Id": rayId.toString(),
      "RayType": rayType,
      "Reason": reason,
      "RayDate": rayDate,
      "BodyPart": bodyPart,
      "MedicalHistoryId": "",
    };
    final formData = FormData.fromMap(formFields);

    try {
      emit(EditRayLoading());

      final response = await dio.put(
        'https://wqaya.runasp.net/api/Ray',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.data['succeeded'] == true) {
        emit(EditRaySuccess());
      } else {
        emit(EditRayError(message: response.data['message'] ?? "Failed to edit ray"));
      }
    } catch (e) {
      emit(EditRayError(message: e.toString()));
    }
  }
  Future<void> editRayPicture({
    required int rayId,
    required File profilePic,
    required String rayType,
    required String reason,
    required String rayDate,
    required String bodyPart,
  }) async {
    final dio = Dio();

    final Map<String, dynamic> formFields = {
      "Id": rayId.toString(),
      "profilePic": await MultipartFile.fromFile(
        profilePic.path,
        filename: profilePic.path.split('/').last,
      ),
    };
    final formData = FormData.fromMap(formFields);

    try {
      emit(EditRayPictureLoading());

      final response = await dio.put(
        'https://wqaya.runasp.net/api/Ray/profile-pic',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.data['succeeded'] == true) {
        await editUserRayWithoutPicture(
            rayId: rayId, rayType: rayType, reason: reason, rayDate: rayDate, bodyPart: bodyPart);

        if (state is EditRaySuccess) {
          emit(EditRayPictureSuccess());
        }
      } else {
        emit(EditRayPictureError(message: response.data['message'] ?? "Failed to edit ray picture"));
      }
    } catch (e) {
      emit(EditRayPictureError(message: e.toString()));
    }
  }
  Future<void> searchRays({required String keyword}) async {
    emit(SearchRaysLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/Ray/search',
        queryParameters: {'key': keyword},
        options: Options(headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'accept': '*/*',
        }),
      );

      if (response.statusCode == 200 && response.data['succeeded'] == true) {
        final List<dynamic> data = response.data['data'];
        final rays = data.map((json) => RayModel.fromJson(json)).toList();
        emit(SearchRaysSuccess(rays));
      } else {
        emit(SearchRaysError(response.data['message'] ?? 'فشل في البحث'));
      }
    } catch (e) {
      emit(SearchRaysError('حدث خطأ أثناء تنفيذ البحث'));
    }
  }
}
