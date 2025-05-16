import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineInitial());

  // Use a Set to prevent duplicates
  final Set<int> selectedIds = {};
  final Set<String> selectedMedicineName = {};

  // Keep track of current medicines list
  List<MedicineModel> _currentMedicines = [];
  List<MedicineModel> get currentMedicines => _currentMedicines;

  // Add a method to toggle selection
  void toggleMedicineSelection(int medicineId) {
    if (selectedIds.contains(medicineId)) {
      selectedIds.remove(medicineId);
    } else {
      selectedIds.add(medicineId);
    }
    // Emit a state change while preserving the current medicines list
    emit(MedicineSelectionChanged(selectedIds.toList(), _currentMedicines));
  }
  void toggleMedicineSelectionByName(String medicineName) {
    if (selectedMedicineName.contains(medicineName)) {
      selectedMedicineName.remove(medicineName);
    } else {
      selectedMedicineName.add(medicineName);
    }
    // Emit a state change while preserving the current medicines list
    emit(MedicineSelectionChanged(selectedIds.toList(), _currentMedicines));
  }

  // Method to clear all selections
  void clearSelections() {
    selectedIds.clear();
    emit(MedicineSelectionChanged([], _currentMedicines));
  }

  Future<void> getUserMedicine() async {
    emit(UserMedicineLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/MedicalHistory/allmedicines?pageNumber=1&pageSize=111',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
        ),
      );
      final data = response.data as List;
      final medicines = data.map((e) => MedicineModel.fromJson(e)).toList();
      _currentMedicines = medicines; // Update current medicines list
      emit(UserMedicineLoaded(medicines));
    } catch (e) {
      emit(UserMedicineError('Failed to load medicines'));
    }
  }
  Future<void> searchMedicinesForAdding({required String keyword}) async {
    emit(SearchMedicineLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/Medicine/search?key=$keyword',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 ) {
        final responseData = response.data;
        if (responseData==[]){
          emit(SearchMedicineError('Invalid data format received from server.'));
        }
        if (responseData is Map<String, dynamic> && responseData['data'] is List) {
          final data = responseData['data'] as List;
          final medicines = data.map((e) => MedicineModel.fromJson(e)).toList();
          _currentMedicines = medicines;

          emit(SearchMedicineSuccess(medicines));
        } else {
          emit(SearchMedicineError('Invalid data format received from server.'));
        }
      } else if (response.statusCode == 400) {
        final message = response.data is Map && response.data['message'] != null
            ? response.data['message']
            : 'Bad request.';
        emit(SearchMedicineError(message));
      } else {
        emit(SearchMedicineError('Unexpected error: ${response.statusCode}'));
      }
    } catch (e, stacktrace) {
      print('Exception during search: $e');
      print(stacktrace);
      emit(SearchMedicineError('Failed to search medicines'));
    }
  }
  Future<void> searchGeneralMedicine({required String keyword}) async {
    emit(SearchMedicineLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/MedicalHistory/Search?key=$keyword',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List) {
          final medicines = responseData.map((e) => MedicineModel.fromJson(e)).toList();
          _currentMedicines = medicines;
          emit(SearchMedicineSuccess(medicines));
        } else {
          print(response.data);
          emit(SearchMedicineError('Unexpected response format. Expected a list.'));
        }
      } else if (response.statusCode == 400) {
        final message = response.data is Map && response.data['message'] != null
            ? response.data['message']
            : 'Bad request.';
        emit(SearchMedicineError(message));
      } else {
        emit(SearchMedicineError('Unexpected error: ${response.statusCode}'));
      }
    } catch (e, stacktrace) {
      print('Exception during search: $e');
      print(stacktrace);
      emit(SearchMedicineError('Failed to search medicines'));
    }
  }
// Add this method to your MedicineCubit class
  // Add this method to your MedicineCubit class
  Future<void> deleteMedicineAddedByUser({required int medicineId}) async {
    final dio = Dio();
    final String token = CacheHelper().getData(key: 'token');

    try {
      emit(DeleteMedicineLoading());

      final response = await dio.delete(
        'https://wqaya.runasp.net/api/MedicalHistory/UserMedicine?medicineId=$medicineId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(DeleteMedicineSuccess());
      } else {
        emit(DeleteMedicineError(errorMessage: "حدث خلل أثناء الحذف"));
      }
    } catch (e) {
      emit(DeleteMedicineError(errorMessage: "حدث خلل أثناء الحذف"));
    }
  }
  Future<void> deleteMedicineAddedBySystem({required int medicineId}) async {
    final dio = Dio();
    final String token = CacheHelper().getData(key: 'token');

    try {
      emit(DeleteMedicineLoading());

      final response = await dio.delete(
        'https://wqaya.runasp.net/api/MedicalHistory/SystemMedicine?medicineId=$medicineId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(DeleteMedicineSuccess());
      } else {
        emit(DeleteMedicineError(errorMessage: "حدث خلل أثناء الحذف"));
      }
    } catch (e) {
      emit(DeleteMedicineError(errorMessage: "حدث خلل أثناء الحذف"));
    }
  }
  Future<void> editUserMedicine({
   required MedicineModel medicine
  }) async {
    emit(EditMedicineLoading());
    try {
      final token = CacheHelper().getData(key: 'token');


      final response = await Dio().put(
        'https://wqaya.runasp.net/api/MedicalHistory/EditMedicineByPatient',
        data: {
          'id': medicine.id,
          'medicalHistryId': 0,
          'name': medicine.name,
          'dosageForm': medicine.dosageForm,
          'strength': medicine.strength,
          'unit': medicine.unit,
          'medicineType': medicine.medicineType,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Medicine updated response: ${response.data}');
      emit(EditMedicineSuccess());
      // Refresh the medicine list after editing
      await getUserMedicine();
    } catch (e) {
      print('Error updating medicine: $e');
      String errorMessage = 'Failed to update medicine';
      if (e is DioException && e.response != null) {
        // Extract specific error message from response if available
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
        print('Server error details: ${e.response!.data}');
      }
      emit(EditMedicineError(errorMessage: errorMessage));
    }
  }
  Future<void> addMedicineByHand({
    required String name,
    required String dosageForm,
    required double strength,
    required String unit,
    required String medicineType,
  }) async {
    emit(AddMedicineLoading());
    try {
      final token = CacheHelper().getData(key: 'token');
      print('Sending medicine data:');
      print('Name: $name');
      print('Dosage Form: $dosageForm');
      print('Strength: $strength');
      print('Unit: $unit');
      print('Medicine Type: $medicineType');

      final response = await Dio().post(
        'https://wqaya.runasp.net/api/MedicalHistory/MedicineByPatient',
        data: {
          'name': name,
          'dosageForm': dosageForm,
          'strength': strength,
          'unit': unit,
          'medicineType': medicineType,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Medicine added response: ${response.data}');
      emit(AddMedicineSuccess());
      // Refresh the medicine list after adding
      await getUserMedicine();
    } catch (e) {
      print('Error adding medicine: $e');
      String errorMessage = 'Failed to add medicine';
      if (e is DioException && e.response != null) {
        // Extract specific error message from response if available
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
        print('Server error details: ${e.response!.data}');
      }
      emit(AddMedicineError(errorMessage: errorMessage));
    }
  }
  // Method to update selection state while preserving medicines list
  void updateSelectionState() {
    emit(MedicineSelectionChanged(selectedIds.toList(), _currentMedicines));
  }

  // Add method to submit selected medicines
  Future<void> submitSelectedMedicines() async {
    emit(SubmittingMedicines());
    print(selectedIds);
    try {
      final token = CacheHelper().getData(key: 'token');
      final List<Map<String, dynamic>> body = selectedIds
          .map((id) => {'medicineId': id})
          .toList();
      final response = await Dio().post(
        'https://wqaya.runasp.net/api/MedicalHistory/MedicineFromList',
        data: body,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response.data);
      emit(MedicinesSubmitted());
      selectedIds.clear();
      await getUserMedicine();
    } catch (e) {
      emit(MedicineSubmissionError('Failed to submit medicines'));
    }
  }
}