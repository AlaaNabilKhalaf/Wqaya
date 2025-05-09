// Updated medicine_state.dart file
part of 'medicine_cubit.dart';

@immutable
abstract class MedicineState {}

class MedicineInitial extends MedicineState {}

// Loading States
class UserMedicineLoading extends MedicineState {}
class SearchMedicineLoading extends MedicineState {}

// Success States
class UserMedicineLoaded extends MedicineState {
  final List<MedicineModel> medicines;
  UserMedicineLoaded(this.medicines);
}

class SearchMedicineSuccess extends MedicineState {
  final List<MedicineModel> medicines;
  SearchMedicineSuccess(this.medicines);
}

// Error States
class UserMedicineError extends MedicineState {
  final String message;
  UserMedicineError(this.message);
}

class SearchMedicineError extends MedicineState {
  final String message;
  SearchMedicineError(this.message);
}

// Selection State - Modified to include medicines list
class MedicineSelectionChanged extends MedicineState {
  final List<int> selectedIds;
  final List<MedicineModel> medicines; // Keep track of current medicines
  MedicineSelectionChanged(this.selectedIds, this.medicines);
}

// Submission States
class SubmittingMedicines extends MedicineState {}
class MedicinesSubmitted extends MedicineState {}
class MedicineSubmissionError extends MedicineState {
  final String message;
  MedicineSubmissionError(this.message);
}
class AddMedicineSuccess extends MedicineState {}
class AddMedicineLoading extends MedicineState {}
class AddMedicineError extends MedicineState {
  final String errorMessage;

  AddMedicineError({required this.errorMessage});
}
class DeleteMedicineSuccess extends MedicineState {}
class DeleteMedicineLoading extends MedicineState {}
class DeleteMedicineError extends MedicineState {
  final String errorMessage;

  DeleteMedicineError({required this.errorMessage});
}