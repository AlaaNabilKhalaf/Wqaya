import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/allergies/Presentation/Views/view_model/models/allergy_model.dart';
import 'package:http/http.dart' as http;
part 'allergy_state.dart';

class AllergyCubit extends Cubit<AllergyState> {
  AllergyCubit() : super(AllergyInitial());

  final String baseUrl = 'https://wqaya.runasp.net/api';
  List<int> tempSelectedIds = [];
  List<String> tempSelectedNames = [];

  // Toggle selection methods for multi-select functionality
  void toggleAllergySelection(int id) {
    if (tempSelectedIds.contains(id)) {
      tempSelectedIds.remove(id);
    } else {
      tempSelectedIds.add(id);
    }
    emit(UserAllergyLoaded([]));
    getUserAllergies();
  }

  void toggleAllergySelectionByName(String name) {
    if (tempSelectedNames.contains(name)) {
      tempSelectedNames.remove(name);
    } else {
      tempSelectedNames.add(name);
    }
  }

  // Get all user allergies
  Future<void> getUserAllergies() async {
    emit(UserAllergyLoading());
    try {
      
  

      final response = await http.get(
        Uri.parse('https://wqaya.runasp.net/api/Allergic/page?pageNumber=1&pageSize=111'),
        headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        final List<AllergyModel> allergies = data
            .map((item) => AllergyModel.fromJson(item))
            .toList();
       emit(UserAllergyLoaded(allergies));
      } else {
        if (response.statusCode==400&& json.decode(response.body)['message'].toString()=="There are no Allergics."){
          emit(UserAllergyLoaded(const []));

        }else {
          print(response.body);
          emit(UserAllergyError(
              'Failed to load allergies: ${response.statusCode}'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UserAllergyError('Error: $e'));
    }
  }

  // Search allergies
  Future<void> searchUserAllergies({required String keyword}) async {
    emit(SearchAllergyLoading());
    try {


      final response = await http.get(
        Uri.parse('$baseUrl/Allergic/search?keyword=$keyword'),
        headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<AllergyModel> allergies = data
            .map((item) => AllergyModel.fromJson(item))
            .toList();

        emit(SearchAllergySuccess(allergies));
      } else {
        emit(SearchAllergyError('Failed to search allergies: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SearchAllergyError('Error: $e'));
    }
  }

  // Add new allergy
  Future<void> addAllergy({
    required String allergenName,
    required String allergenType, // e.g., "Food", "Drug"
    required String severityLevel, // e.g., "Moderate", "High"
    required String reaction,
    required String diagnosisDate, // formatted as ISO: yyyy-MM-ddTHH:mm:ss
    required String lastOccurrence, // formatted as ISO: yyyy-MM-ddTHH:mm:ss
    required String medicines,
    required String notes,
  }) async {
    emit(AddAllergyLoading());

    try {
      final response = await http.post(
        Uri.parse('https://wqaya.runasp.net/api/Allergic'),
        headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          'medicalHistoryId': 0,
          'allergenName': allergenName,
          'allergenType': allergenType,
          'severityLevel': severityLevel,
          'reaction': reaction,
          'diagnosisDate': diagnosisDate,
          'lastOccurrence': lastOccurrence,
          'addedmedicines': medicines,
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['succeeded'] == true) {
          emit(AddAllergySuccess());
        } else {
          emit(AddAllergyError(responseData['message'] ?? 'حدث خطأ في إضافة الحساسية'));
        }
      } else {
        print(response.body);
        emit(AddAllergyError('حدث خطأ: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AddAllergyError('حدث خطأ أثناء إضافة الحساسية: $e'));
    }
  }

  // Edit existing allergy

// Edit existing allergy
  Future<void> editAllergy({
    required int id,
    required String allergenName,
    required String allergenType, // e.g., "Food", "Drug"
    required String severityLevel, // e.g., "Moderate", "High"
    required String reaction,
    required String diagnosisDate, // formatted as ISO: yyyy-MM-ddTHH:mm:ss
    required String lastOccurrence, // formatted as ISO: yyyy-MM-ddTHH:mm:ss
    required String medicines,
    required String notes,
  }) async {
    emit(EditAllergyLoading());

    try {
      final response = await http.put(
        Uri.parse('https://wqaya.runasp.net/api/Allergic'),
        headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          'id': id,
          'medicalHistoryId': 0, // Assuming this is handled by the backend
          'allergenName': allergenName,
          'allergenType': allergenType,
          'severityLevel': severityLevel,
          'reaction': reaction,
          'diagnosisDate': diagnosisDate,
          'lastOccurrence': lastOccurrence,
          'addedmedicines': medicines,
          'notes': notes,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['succeeded'] == true) {
          emit(EditAllergySuccess());
        } else {
          print(responseData);
          print(1);
          emit(EditAllergyError(responseData['message'] ?? 'حدث خطأ في تعديل الحساسية'));
        }
      } else {
        print(response.statusCode);
        print(2);
        emit(EditAllergyError('حدث خطأ: ${response.statusCode}'));
      }
    } catch (e) {
      print(e.toString());
      print(3);
      emit(EditAllergyError('حدث خطأ أثناء تعديل الحساسية: $e'));
    }
  }

// Add these states to your AllergyCubit state class

  // Delete allergy
  Future<void> deleteAllergy({required int allergyId}) async {
    emit(DeleteAllergyLoading());
    try {


      final response = await http.delete(
        Uri.parse('$baseUrl/Allergic/$allergyId'),
        headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        emit(DeleteAllergySuccess());
      } else {
        emit(DeleteAllergyError('Failed to delete allergy: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DeleteAllergyError('Error: $e'));
    }
  }
}
