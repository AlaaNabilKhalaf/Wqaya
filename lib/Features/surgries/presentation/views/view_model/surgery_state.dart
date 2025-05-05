import 'package:equatable/equatable.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';

abstract class SurgeryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SurgeryInitial extends SurgeryState {}

class UserSurgeriesLoading extends SurgeryState {}

class UserSurgeriesLoaded extends SurgeryState {
  final List<Surgery> surgeries;

  UserSurgeriesLoaded(this.surgeries);

  @override
  List<Object?> get props => [surgeries];
}

class UserSurgeriesError extends SurgeryState {
  final String errorMessage;

  UserSurgeriesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
// Add Surgery States
class AddSurgeryLoading extends SurgeryState {}

class AddSurgerySuccess extends SurgeryState {
  final String message;

  AddSurgerySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddSurgeryError extends SurgeryState {
  final String errorMessage;

  AddSurgeryError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
class EditSurgeryLoading extends SurgeryState {}

class EditSurgerySuccess extends SurgeryState {
  final String message;

  EditSurgerySuccess(this.message);
}

class EditSurgeryError extends SurgeryState {
  final String error;

  EditSurgeryError(this.error);
}

// Delete surgery states
class DeleteSurgeryLoading extends SurgeryState {}

class DeleteSurgerySuccess extends SurgeryState {
  final String message;

  DeleteSurgerySuccess(this.message);
}

class DeleteSurgeryError extends SurgeryState {
  final String error;

  DeleteSurgeryError(this.error);
}
