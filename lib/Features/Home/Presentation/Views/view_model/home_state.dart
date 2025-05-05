part of 'home_cubit.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}
final class HomeInitial extends HomeState {}


class SymptomInitial extends HomeState {}

class SymptomLoading extends HomeState {}
class SubmitUserSymptomsLoadingState extends HomeState {}
class SubmitUserSymptomsSuccessfulState extends HomeState {}
class SubmitUserSymptomsFailureState extends HomeState {}
class SubmitUserDiseasesLoadingState extends HomeState {}
class SubmitUserDiseasesSuccessfulState extends HomeState {}
class SubmitUserDiseasesFailureState extends HomeState {}

class UserMedicineLoading extends HomeState {}

class UserMedicineLoaded extends HomeState {
  final List<MedicineModel> medicines;

  UserMedicineLoaded(this.medicines);
}

class UserMedicineError extends HomeState {
  final String message;

  UserMedicineError(this.message);
}
class SymptomLoaded extends HomeState {
  final List<SymptomCategory> categories;

  SymptomLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}
class SymptomError extends HomeState {
  final String message;

  SymptomError(this.message);

  @override
  List<Object> get props => [message];
}
class ChronicDiseasesLoaded extends HomeState {
  final List<ChronicDiseaseModel> diseases;

  ChronicDiseasesLoaded({required this.diseases});


  @override
  List<Object> get props => [diseases];
}
class RayLoading extends HomeState {}

class RaySuccess extends HomeState {
  final List<RayModel> rays;
  RaySuccess(this.rays);
}

class RayError extends HomeState {
  final String message;
  RayError(this.message);
}
class AddRayLoading extends HomeState {}

class AddRaySuccess extends HomeState {
}

class AddRayError extends HomeState {
}class DeleteRayLoading extends HomeState {}

class DeleteRaySuccess extends HomeState {
}

class DeleteRayError extends HomeState {
  final String message;

  DeleteRayError({required this.message});

}