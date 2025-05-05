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
