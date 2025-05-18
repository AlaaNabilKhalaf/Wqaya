part of 'ocr_cubit.dart';

@immutable
sealed class OcrState {}

final class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

class OcrSuccess extends OcrState {
  final List<MedicineModel> medicines;

   OcrSuccess(this.medicines);

  List<Object?> get props => [medicines];
}

class OcrError extends OcrState {
  final String message;

   OcrError(this.message);

  List<Object?> get props => [message];
}