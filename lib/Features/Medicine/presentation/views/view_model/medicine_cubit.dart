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
        ),
      );

      final data = response.data['data'] as List;
      final medicines = data.map((e) => MedicineModel.fromJson(e)).toList();
      _currentMedicines = medicines; // Update current medicines list
      emit(SearchMedicineSuccess(medicines));
    } catch (e) {
      emit(SearchMedicineError('Failed to search medicines'));
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