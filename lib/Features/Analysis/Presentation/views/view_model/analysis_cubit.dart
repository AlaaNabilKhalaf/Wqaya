import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_model.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final Dio _dio = Dio();
  final String baseUrl = 'https://wqaya.runasp.net/api';

  AnalysisCubit() : super(AnalysisInitial());

  // Set the authorization token for authenticated requests

  final Map<String, String> resultStatusMap = {
    'Normal': 'طبيعي',
    'High': 'مرتفع',
    'Low': 'منخفض',
    'Pending': 'قيد الانتظار',
    'Abnormal': 'غير طبيعي',
  };
  // Fetch analysis records
  Future<void> fetchAnalysisRecords({int pageNumber = 1, int pageSize = 111}) async {
    try {
      emit(AnalysisLoading());
      print('$baseUrl/Analysis/page?pageNumber=1&pageSize=111');
      final response = await _dio.get(
        '$baseUrl/Analysis/page?pageNumber=1&pageSize=111',
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'accept':'*/*'
          },
        )
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        if (data['succeeded'] == true) {
          final pageData = data['data'];
          final List<dynamic> items = pageData['items'];

          final List<AnalysisRecord> records = items
              .map((item) => AnalysisRecord.fromJson(item))
              .toList();

          emit(AnalysisLoaded(
            records: records,
            pageIndex: pageData['pageIndex'],
            totalPages: pageData['totalPages'],
            totalCount: pageData['totalCount'],
            hasPreviousPage: pageData['hasPreviousPage'],
            hasNextPage: pageData['hasNextPage'],
          ));
        } else {
          emit(AnalysisError(message: data['message'] ?? 'Failed to load records'));
        }
      } else {
        print(response.data);
        emit(const AnalysisError(message: 'Failed to load records'));
      }
    } catch (e) {
      emit(AnalysisError(message: 'Error fetching records: ${e.toString()}'));
    }
  }

  // Upload a new analysis record (PDF only)
  Future<void> uploadAnalysisRecord({
    required String testName,
    required String labName,
    required DateTime date,
    String? resultSummary,
    String? resultStatus,
    required int medicalHistoryId,
    required File pdfFile,
  }) async {
    try {
      emit(AnalysisUploading());

      // Check if the file is a PDF
      if (!pdfFile.path.toLowerCase().endsWith('.pdf')) {
        emit(const AnalysisError(message: 'Only PDF files are allowed'));
        return;
      }

      // Create form data
      final formData = FormData.fromMap({
        'TestName': testName,
        'LabName': labName,
        'Date': date.toIso8601String(),
        'ResultSummary': resultSummary,
        'ResultStatus': resultStatus,
        'ImageFile': await MultipartFile.fromFile(pdfFile.path, filename: 'report.pdf'),
        'MedicalHistoryId': medicalHistoryId,
      });

      final response = await _dio.post(
        '$baseUrl/Analysis',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'accept':'*/*'
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['succeeded'] == true) {
          emit(AnalysisUploadSuccess(message: data['message'] ?? 'Upload successful'));
          // Fetch updated records after successful upload
          await fetchAnalysisRecords();
        } else {
          emit(AnalysisUploadError(message: data['message'] ?? 'Failed to upload record'));
        }
      } else {
        emit(const AnalysisUploadError(message: 'Failed to upload record'));
      }
    } catch (e) {
      emit(AnalysisUploadError(message: 'Error uploading record: ${e.toString()}'));
    }
  }

  // Pick a PDF file
  Future<File?> pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      emit(AnalysisError(message: 'Error picking file: ${e.toString()}'));
      return null;
    }
  }

  Future<void> updateAnalysisRecord({
    required int id,
    required String testName,
    required String labName,
    required DateTime date,
    String? resultSummary,
    String? resultStatus,
    required int medicalHistoryId,
    File? pdfFile,
  }) async {
    try {
      emit(AnalysisUploading());

      // First API call - Update analysis info
      final formData = FormData.fromMap({
        'Id': id,
        'TestName': testName,
        'LabName': labName,
        'Date': date.toIso8601String().split('T')[0],
        if (resultSummary != null) 'ResultSummary': resultSummary,
        if (resultStatus != null) 'ResultStatus': resultStatus,
        'MedicalHistoryId': medicalHistoryId,
      });
      final response = await _dio.put(
        'https://wqaya.runasp.net/api/Analysis',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'accept':'*/*'
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        emit(AnalysisUpdateError(message: 'فشل تحديث بيانات التحليل: ${response.statusCode}'));
        return;
      }

      // If PDF file is changed, make second API call to update it
      if (pdfFile != null) {
        final pdfFormData = FormData.fromMap({
          'Id': id,
          'profilePic': await MultipartFile.fromFile(
            pdfFile.path,
            filename: pdfFile.path.split('/').last,
          ),
        });

        final pdfResponse = await _dio.put(
          'https://wqaya.runasp.net/api/Analysis/profile-pic',
          data: pdfFormData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
              'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
              'accept':'*/*'
            },
          ),
        );

        if (pdfResponse.statusCode != 200 && pdfResponse.statusCode != 204) {
          emit(AnalysisUpdateError(message: 'تم تحديث البيانات لكن فشل تحديث ملف PDF: ${pdfResponse.statusCode}'));
          return;
        }
      }
      fetchAnalysisRecords();
      emit(AnalysisUpdateSuccess());
    } on DioException catch (e) {
      emit(AnalysisUpdateError(message: 'حدث خطأ غير متوقع: $e'));
    } catch (e) {
      emit(AnalysisUpdateError(message: 'حدث خطأ غير متوقع: $e'));
    }
  }

}