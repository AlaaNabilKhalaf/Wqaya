import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_model.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final Dio _dio = Dio();
  final String baseUrl = 'https://wqaya.runasp.net/api';

  AnalysisCubit() : super(AnalysisInitial());

  // Keep track of current analysis records list for consistent state management
  List<AnalysisRecord> _currentRecords = [];
  List<AnalysisRecord> get currentRecords => _currentRecords;

  // Map for displaying result status in Arabic
  final Map<String, String> resultStatusMap = {
    'Normal': 'طبيعي',
    'High': 'مرتفع',
    'Low': 'منخفض',
    'Pending': 'قيد الانتظار',
    'Abnormal': 'غير طبيعي',
  };

  // Fetch analysis records
  Future<void> fetchAnalysisRecords({int pageNumber = 1, int pageSize = 111}) async {
    emit(AnalysisLoading());
    try {
      final response = await _dio.get(
        '$baseUrl/Analysis/page?pageNumber=$pageNumber&pageSize=$pageSize',
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'accept': '*/*'
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['succeeded'] == true) {
          final pageData = data['data'];
          final List<dynamic> items = pageData['items'];

          final List<AnalysisRecord> records =
          items.map((item) => AnalysisRecord.fromJson(item)).toList();

          _currentRecords = records; // Update current records list

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
        emit(AnalysisError(message: 'Failed to load records. Status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AnalysisError(message: 'Error fetching records: ${e.toString()}'));
    }
  }

  // Search analysis records
  Future<void> searchAnalysisRecords({required String keyword}) async {
    if (keyword.trim().isEmpty) {
      await fetchAnalysisRecords();
      return;
    }

    emit(SearchAnalysisLoading());
    try {
      // Filter the existing records for client-side search
      final filteredRecords = _currentRecords.where((record) =>
      record.testName.toLowerCase().contains(keyword.toLowerCase()) ||
          record.labName.toLowerCase().contains(keyword.toLowerCase())
      ).toList();

      emit(SearchAnalysisSuccess(filteredRecords));
    } catch (e) {
      emit(SearchAnalysisError('Failed to search records: ${e.toString()}'));
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
  Future<void> searchAnalysisRecordsFromServer({required String keyword}) async {
    emit(SearchAnalysisLoading());
    try {
      final response = await _dio.get(
        '$baseUrl/Analysis/search',
        queryParameters: {'key': keyword},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'accept': '*/*',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['succeeded'] == true) {
          final List<dynamic> items = data['data'];

          final List<AnalysisRecord> records =
          items.map((item) => AnalysisRecord.fromJson(item)).toList();

          emit(SearchAnalysisSuccess(records));
        } else {
          emit(SearchAnalysisError(data['message'] ?? 'فشل البحث عن التحاليل'));
        }
      } else {
        emit(SearchAnalysisError('فشل البحث. كود الحالة: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SearchAnalysisError('حدث خطأ أثناء البحث: ${e.toString()}'));
    }
  }
  Future<void> uploadAnalysisRecord({
    required String testName,
    required String labName,
    required DateTime date,
    String? resultSummary,
    String? resultStatus,
    required int medicalHistoryId,
    required File pdfFile,
  }) async {
    emit(AnalysisUploading());
    try {
      // Check if the file is a PDF
      if (!pdfFile.path.toLowerCase().endsWith('.pdf')) {
        emit(AnalysisUploadError(message: 'Only PDF files are allowed'));
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
            'accept': '*/*'
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
        emit(AnalysisUploadError(message: 'Failed to upload record. Status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AnalysisUploadError(message: 'Error uploading record: ${e.toString()}'));
    }
  }

  // Update an existing analysis record
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
    emit(AnalysisUpdateLoading());
    try {
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
        '$baseUrl/Analysis',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
            'accept': '*/*'
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        emit(AnalysisUpdateError(errorMessage: 'فشل تحديث بيانات التحليل: ${response.statusCode}'));
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
          '$baseUrl/Analysis/profile-pic',
          data: pdfFormData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
              'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
              'accept': '*/*'
            },
          ),
        );

        if (pdfResponse.statusCode != 200 && pdfResponse.statusCode != 204) {
          emit(AnalysisUpdateError(
              errorMessage: 'تم تحديث البيانات لكن فشل تحديث ملف PDF: ${pdfResponse.statusCode}'
          ));
          return;
        }
      }

      emit(AnalysisUpdateSuccess());
      // Refresh the analysis records after update
      await fetchAnalysisRecords();
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ غير متوقع';
      if (e.response != null) {
        // Extract specific error message from response if available
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
      }
      emit(AnalysisUpdateError(errorMessage: '$errorMessage: $e'));
    } catch (e) {
      emit(AnalysisUpdateError(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  // Delete an analysis record
  Future<void> deleteAnalysisRecord(int analysisId) async {
    emit(AnalysisDeleteLoading());
    try {
      final response = await _dio.delete(
        '$baseUrl/Analysis/$analysisId',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(AnalysisDeleteSuccess());
        // Refresh the analysis records after deletion
        await fetchAnalysisRecords();
      } else {
        emit(AnalysisDeleteError(errorMessage: 'حدث خطأ أثناء الحذف. Status: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ أثناء الحذف';
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        }
      }
      emit(AnalysisDeleteError(errorMessage: errorMessage));
    } catch (e) {
      emit(AnalysisDeleteError(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }
}