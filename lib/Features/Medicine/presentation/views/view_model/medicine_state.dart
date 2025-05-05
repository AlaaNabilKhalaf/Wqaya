part of 'medicine_cubit.dart';

@immutable
sealed class MedicineState {}

final class MedicineInitial extends MedicineState {}
class UserMedicineLoading extends MedicineState {}

class UserMedicineLoaded extends MedicineState {
  final List<MedicineModel> medicines;

  UserMedicineLoaded(this.medicines);
}

class UserMedicineError extends MedicineState {
  final String message;

  UserMedicineError(this.message);
}