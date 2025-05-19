import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

part 'ocr_state.dart';


class OcrCubit extends Cubit<OcrState> {
  final Dio dio = Dio();

  OcrCubit() : super(OcrInitial());

  Future<void> uploadPicture(File prescriptionImage) async {
    // Emit loading state immediately
    emit(OcrLoading());

    try {
      // Get the token from your secure storage or wherever you store it
      String token = await getToken();

      // Create form data
      final formData = FormData.fromMap({
        'profilePic': await MultipartFile.fromFile(
          prescriptionImage.path,
          filename: prescriptionImage.path.split('/').last,
        ),
      });

      // Send request
      final response = await dio.post(
        'https://wqaya.runasp.net/api/Ocr/prescription',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['succeeded'] == true) {
          final List<dynamic> medicinesJson = responseData['data'];
          final List<MedicineModel> medicines = medicinesJson
              .map((medicine) => MedicineModel.fromJson(medicine))
              .toList();

          emit(OcrSuccess(medicines));
        } else {
          emit(OcrError(responseData['message'] ?? 'حدث خطأ أثناء معالجة الصورة'));
        }
      } else {
        emit(OcrError('حدث خطأ في الاتصال بالخادم'));
      }
    } catch (e) {
      emit(OcrError('حدث خطأ في الاتصال بالخادم: ${e.toString()}'));
    }
  }

  // Helper method to get token (implement according to your app's auth system)
  Future<String> getToken() async {
    // Replace with your actual token retrieval logic
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWxla3lhc3NlcjQxMEBnbWFpbC5jb20iLCJqdGkiOiI1MTI3NDAwNS05NTQ5LTQ3YzYtODQxYi1jNzVhODM0NDA0ZGEiLCJVc2VySWQiOiIxMiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6Im1hbGVreWFzc2VyNDEwQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlBhdGllbnQiLCJleHAiOjE3NDc2NzAxNzQsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcxMTciLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo3MTE3In0.tjSMJiJpzSe5-YMmGeVy3utdIpyuDYs44871PpoGbwE';
  }

  // Method to reset the state
  void reset() {
    emit(OcrInitial());
  }
}