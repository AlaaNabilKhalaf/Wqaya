// lib/Features/Complaints/Presentation/Views/view_model/complaint_cubit.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_state.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/models.dart';

class ComplaintsCubit extends Cubit<ComplaintState> {
  ComplaintsCubit() : super(ComplaintInitial());

  static const String baseUrl = 'https://wqaya.runasp.net/api';
  final token = CacheHelper().getData(key: 'token');
  // Get user complaints
  Future<void> getUserComplaints() async {
    emit(UserComplaintsLoading());
    try {
      if (token == null) {
        emit(UserComplaintsError('توكن المستخدم غير متوفر'));
        return;
      }
      print('https://wqaya.runasp.net/api/Complaints');
      print('Bearer $token');
      final response = await http.get(
        Uri.parse('https://wqaya.runasp.net/api/Complaints/page?pageNumber=1&pageSize=111'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['succeeded'] == true) {
          final List<dynamic> complaintsData = responseData['data'] ?? [];
          final List<Complaint> complaints = complaintsData
              .map((item) => Complaint.fromJson(item))
              .toList();

          emit(UserComplaintsLoaded(complaints));
        } else {

          print(1);
          emit(UserComplaintsError(responseData['message'] ?? 'حدث خطأ في جلب البيانات'));
        }
      } else {
        if (response.statusCode==400&& json.decode(response.body)['message'].toString()=="There are no complaints."){
          emit(UserComplaintsLoaded([]));

        }else {
          print(response.body);
          emit(UserComplaintsError('حدث خطأ: ${response.statusCode}'));
        }
      }
    } catch (e) {
      print(3);

      emit(UserComplaintsError('حدث خطأ أثناء جلب البيانات: $e'));
    }
  }

  // Add new complaint
  Future<void> addComplaint({
    required String type,
    required String reason,
    required String location,
    required String duration,
    required String severity,
    required List<String> medicines,
    required String notes,
  }) async {
    emit(AddComplaintLoading());
    try {
      if (token == null) {
        emit(AddComplaintError('توكن المستخدم غير متوفر'));
        return;
      }

      final combinedMedicines = medicines.isNotEmpty ? medicines.join('-') : "";

      final response = await http.post(
        Uri.parse('https://wqaya.runasp.net/api/Complaints'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          'type': type,
          'medicalHistoryId': 0,
          'reason': reason,
          'location': location,
          'duration': duration,
          'severity': severity,
          'addedmedicines': combinedMedicines,
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['succeeded'] == true) {
          emit(AddComplaintSuccess('تمت إضافة الشكوى بنجاح'));
        } else {
          print(1);
          emit(AddComplaintError(responseData['message'] ?? 'حدث خطأ في إضافة الشكوى'));
        }
      } else {
        print(type);
        print(reason);
        print(location);
        print(duration);
        print(severity);
        print(combinedMedicines);
        print(notes);
        print(response.body);
        print(2);
        emit(AddComplaintError('حدث خطأ: ${response.statusCode}'));
      }
    } catch (e) {
      print(3);
      emit(AddComplaintError('حدث خطأ أثناء إضافة الشكوى: $e'));
    }
  }
  // Delete complaint
  Future<void> deleteUserComplaint(int complaintId) async {
    emit(DeleteComplaintLoading());
    try {
      if (token == null) {
        emit(DeleteComplaintError('توكن المستخدم غير متوفر'));
        return;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/Complaints/$complaintId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['succeeded'] == true) {
          emit(DeleteComplaintSuccess('تم حذف الشكوى بنجاح'));
        } else {
          emit(DeleteComplaintError(responseData['message'] ?? 'حدث خطأ في حذف الشكوى'));
        }
      } else {
        emit(DeleteComplaintError('حدث خطأ: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DeleteComplaintError('حدث خطأ أثناء حذف الشكوى: $e'));
    }
  }

  // Search complaints
  Future<void> searchComplaints(String query) async {
    if (query.isEmpty) {
      getUserComplaints();
      return;
    }

    emit(SearchComplaintsLoading());
    try {
      if (token == null) {
        emit(SearchComplaintsError('توكن المستخدم غير متوفر'));
        return;
      }

      final response = await http.get(
        Uri.parse('https://wqaya.runasp.net/api/Complaints/search?key=$query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['succeeded'] == true) {
          final List<dynamic> complaintsData = responseData['data'] ?? [];
          final List<Complaint> complaints = complaintsData
              .map((item) => Complaint.fromJson(item))
              .toList();

          emit(SearchComplaintsSuccess(complaints));
        } else {
          emit(SearchComplaintsError(responseData['message'] ?? 'حدث خطأ في البحث'));
        }
      } else {
        emit(SearchComplaintsError('حدث خطأ: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SearchComplaintsError('حدث خطأ أثناء البحث: $e'));
    }
  }

  Future<void> updateComplaint({
    required int id,
    required String type,
    required String reason,
    required String location,
    required String duration,
    required String severity,
    required List<String> medicines,
    required String notes,
  }) async {
    emit(UpdateComplaintLoading());
    try {
      final token = CacheHelper().getData(key: 'token');
      final addedMedicines = medicines.isNotEmpty ? medicines.join('-') : "";
      final response = await Dio().put(
        'https://wqaya.runasp.net/api/Complaints',
        data: {
          'id': id,
          'type': type,
          'medicalHistoryId': 0,
          'reason': reason,
          'location': location,
          'duration': duration,
          'severity': severity,
          'addedmedicines': addedMedicines,
          'notes': notes,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Complaint updated successfully: ${response.data}');
      emit(UpdateComplaintSuccess('تم تحديث الشكوى بنجاح'));
      await getUserComplaints();
    } catch (e) {
      print('Error updating complaint: $e');
      String errorMessage = 'فشل في تحديث الشكوى';
      if (e is DioException && e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
        print('Server error details: ${e.response!.data}');
      }
      emit(UpdateComplaintError(errorMessage));
    }
  }
}
class ComplaintEnums {
  // Type options with translations
  static const Map<String, String> typeOptionsArabic = {
    'Active': 'حالية',
    'Inactive': 'قديمة',
  };

  // Duration options with translations
  static const Map<String, String> durationOptionsArabic = {
    'Hours': 'ساعات',
    'Days': 'أيام',
    'Weeks': 'أسابيع',
    'Months': 'شهور',
    'Years': 'سنوات',
  };

  // Severity options with translations
  static const Map<String, String> severityOptionsArabic = {
    'Trivial': 'بسيط جداً',
    'Low': 'بسيط',
    'Moderate': 'متوسط',
    'Medium': 'متوسط القوة',
    'Significant': 'ملحوظ',
    'High': 'شديد',
    'Severe': 'بالغ الشدة',
    'Critical': 'حرج',
    'Blocker': 'مانع للتقدم',
    'Fatal': 'مميت'
  };

  // Get the Arabic display name for an enum value
  static String getArabicName(Map<String, String> map, String englishValue) {
    return map[englishValue] ?? englishValue;
  }

  // Get the English enum value from an Arabic name
  static String getEnglishValue(Map<String, String> map, String arabicName) {
    for (var entry in map.entries) {
      if (entry.value == arabicName) {
        return entry.key;
      }
    }
    return arabicName;
  }
}