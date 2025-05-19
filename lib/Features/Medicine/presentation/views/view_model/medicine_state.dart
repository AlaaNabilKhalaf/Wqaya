part of 'medicine_cubit.dart';

@immutable
abstract class MedicineState {}

class MedicineInitial extends MedicineState {}

class UserMedicineLoading extends MedicineState {}

class UserMedicineLoaded extends MedicineState {
  final List<MedicineModel> medicines;
  UserMedicineLoaded(this.medicines);
}

class UserMedicineError extends MedicineState {
  final String message;
  UserMedicineError(this.message);
}

class SearchMedicineLoading extends MedicineState {}

class SearchMedicineSuccess extends MedicineState {
  final List<MedicineModel> medicines;
  SearchMedicineSuccess(this.medicines);
}

class SearchMedicineError extends MedicineState {
  final String message;
  SearchMedicineError(this.message);
}

class MedicineSelectionChanged extends MedicineState {
  final List<int> selectedIds;
  final List<MedicineModel> medicines;
  MedicineSelectionChanged(this.selectedIds, this.medicines);
}

// New state for when selections are confirmed
class MedicineSelectionConfirmed extends MedicineState {
  final List<int> selectedIds;
  final List<String> selectedMedicineNames;
  MedicineSelectionConfirmed(this.selectedIds, this.selectedMedicineNames);
}

class MedicineSelectionChangedComplaint extends MedicineState {
  final List<String> selectedMedicines;
  MedicineSelectionChangedComplaint({required this.selectedMedicines});
}

class SubmittingMedicines extends MedicineState {}

class MedicinesSubmitted extends MedicineState {}

class MedicineSubmissionError extends MedicineState {
  final String message;
  MedicineSubmissionError(this.message);
}

class DeleteMedicineLoading extends MedicineState {}

class DeleteMedicineSuccess extends MedicineState {}

class DeleteMedicineError extends MedicineState {
  final String errorMessage;
  DeleteMedicineError({required this.errorMessage});
}

class EditMedicineLoading extends MedicineState {}

class EditMedicineSuccess extends MedicineState {}

class EditMedicineError extends MedicineState {
  final String errorMessage;
  EditMedicineError({required this.errorMessage});
}

class AddMedicineLoading extends MedicineState {}

class AddMedicineSuccess extends MedicineState {}

class AddMedicineError extends MedicineState {
  final String errorMessage;
  AddMedicineError({required this.errorMessage});
}