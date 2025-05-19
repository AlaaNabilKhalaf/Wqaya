part of 'allergy_cubit.dart';

@immutable
sealed class AllergyState {}

class AllergyInitial extends AllergyState {}

// Get User Allergies States
class UserAllergyLoading extends AllergyState {}

class UserAllergyLoaded extends AllergyState {
  final List<AllergyModel> allergies;
  UserAllergyLoaded(this.allergies);
}

class UserAllergyError extends AllergyState {
  final String message;
  UserAllergyError(this.message);
}

// Search Allergies States
class SearchAllergyLoading extends AllergyState {}

class SearchAllergySuccess extends AllergyState {
  final List<AllergyModel> allergies;
  SearchAllergySuccess(this.allergies);
}

class SearchAllergyError extends AllergyState {
  final String message;
  SearchAllergyError(this.message);
}

// Add Allergy States
class AddAllergyLoading extends AllergyState {}

class AddAllergySuccess extends AllergyState {}

class AddAllergyError extends AllergyState {
  final String message;
  AddAllergyError(this.message);
}

// Edit Allergy States
class EditAllergyLoading extends AllergyState {}

class EditAllergySuccess extends AllergyState {}

class EditAllergyError extends AllergyState {
  final String message;
  EditAllergyError(this.message);
}

// Delete Allergy States
class DeleteAllergyLoading extends AllergyState {}

class DeleteAllergySuccess extends AllergyState {}

class DeleteAllergyError extends AllergyState {
  final String message;
  DeleteAllergyError(this.message);
}