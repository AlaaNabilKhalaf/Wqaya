
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/model/home_models.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<dynamic> cachedDiseases = [];

  Future<void> fetchSymptomCategories() async {
    emit(SymptomLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/SymptomsCategories/page',
        queryParameters: {
          'pageNumber': 1,
          'pageSize': 111,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 && response.data['succeeded'] == true) {
        final items = response.data['data']['items'] as List;
        final categories = items
            .map((item) => SymptomCategory.fromJson(item))
            .toList();

        emit(SymptomLoaded(categories));
      } else {
        emit(SymptomError(response.data['message'] ?? 'Unknown API error'));
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message ?? 'Network error';
      emit(SymptomError(msg));
    } catch (e) {
      emit(SymptomError('Unexpected error: $e'));
    }
  }

  void fetchChronicDiseases() async {
    emit(SymptomLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/Diseases/ChronicDiseases?pageNumber=1&pageSize=111',
        options: Options(headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}', // insert your token variable
          'accept': '*/*'
        }),
      );
      final items = response.data['data']['items'] as List;
      final diseases = items.map((e) => ChronicDiseaseModel.fromJson(e)).toList();
      emit(ChronicDiseasesLoaded(diseases: diseases));
    } catch (e) {
      emit(SymptomError('Failed to load chronic diseases'));
    }
  }

  Future<SymptomSubmissionResponse> submitUserSymptoms({
    required List<int> symptomIds,
  }) async {

    const String url = 'https://wqaya.runasp.net/api/MedicalHistory/symptom';
    try {
      emit (SubmitUserSymptomsLoadingState()) ;
      final response = await Dio().post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'Content-Type': 'application/json',
            'accept': '*/*',
          },
        ),
        data: symptomIds.map((id) => {'symptomId': id}).toList(),
      );

      if (response.statusCode == 200) {
        print(response.data);
        emit (SubmitUserSymptomsSuccessfulState()) ;
        return SymptomSubmissionResponse.fromJson(response.data);

      } else {
        print(response.data);
        emit (SubmitUserSymptomsFailureState()) ;

      throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response.toString());
        emit (SubmitUserSymptomsFailureState()) ;
        throw Exception('Dio error: ${e.response?.data?['message'] ?? 'Unknown error'}');
      } else {

        emit (SubmitUserSymptomsFailureState()) ;
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      emit (SubmitUserSymptomsFailureState()) ;
      throw Exception('Something went wrong: $e');
    }
  }
  Future<SymptomSubmissionResponse> submitUserDiseases({
    required List<int> diseaseIds,
  }) async {
    const String url = 'https://wqaya.runasp.net/api/MedicalHistory/disease';
    final currentState = state;
    if (currentState is ChronicDiseasesLoaded) {
      cachedDiseases = currentState.diseases;
    }
    try {
      emit(SubmitUserDiseasesLoadingState());

      final response = await Dio().post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'Content-Type': 'application/json',
            'accept': '*/*',
          },
        ),
        data: diseaseIds.map((id) => {
          'diseaseId': id,
          'medicineId': 0,
        }).toList(),
      );

      if (response.statusCode == 200) {
        print(response.data);
        emit(SubmitUserDiseasesSuccessfulState());
        return SymptomSubmissionResponse.fromJson(response.data);
      } else {
        print(response.data);
        emit(SubmitUserDiseasesFailureState());
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response.toString());
        emit(SubmitUserDiseasesFailureState());
        throw Exception('Dio error: ${e.response?.data?['message'] ?? 'Unknown error'}');
      } else {
        emit(SubmitUserDiseasesFailureState());
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      emit(SubmitUserDiseasesFailureState());
      throw Exception('Something went wrong: $e');
    }
  }

  Future<void> getUserMedicine() async {
    emit(UserMedicineLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/MedicalHistory/medicines?pageNumber=1&pageSize=111',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
        ),
      );

      final data = response.data['data']['items'] as List;
      final medicines = data.map((e) => MedicineModel.fromJson(e)).toList();
      emit(UserMedicineLoaded(medicines));
    } catch (e) {
      emit(UserMedicineError('Failed to load medicines'));
    }
  }
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
}
