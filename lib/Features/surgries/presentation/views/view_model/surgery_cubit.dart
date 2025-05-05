import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_state.dart';

// Cubit
class SurgeryCubit extends Cubit<SurgeryState> {
  final SurgeryRepository surgeryRepository;
  List<Surgery> _surgeries = [];

  SurgeryCubit({required this.surgeryRepository}) : super(SurgeryInitial());

  Future<void> getUserSurgeries() async {
    emit(UserSurgeriesLoading());
    try {
      final surgeries = await surgeryRepository.getUserSurgeries();
      _surgeries = surgeries;
      emit(UserSurgeriesLoaded(_surgeries));
    } catch (e) {
      emit(UserSurgeriesError(e.toString()));
    }
  }

  Future<void> addUserSurgery(AddSurgery surgery) async {
    // Store the current state to return to after operation
    final currentState = state;

    emit(AddSurgeryLoading());
    try {
      final success = await surgeryRepository.addUserSurgery(surgery);

      if (success) {
        emit(AddSurgerySuccess("تمت إضافة العملية الجراحية بنجاح"));
        // Refresh the surgeries list
        await getUserSurgeries();
      } else {
        emit(AddSurgeryError("فشل في إضافة العملية الجراحية"));
        // Return to previous state if user has already loaded surgeries
        if (currentState is UserSurgeriesLoaded) {
          emit(UserSurgeriesLoaded(_surgeries));
        }
      }
    } catch (e) {
      emit(AddSurgeryError(e.toString()));
      // Return to previous state if user has already loaded surgeries
      if (currentState is UserSurgeriesLoaded) {
        emit(UserSurgeriesLoaded(_surgeries));
      }
    }
  }
  Future<void> editUserSurgery(Surgery surgery) async {
    // Store the current state to return to after operation
    final currentState = state;

    emit(EditSurgeryLoading());
    try {
      final success = await surgeryRepository.editUserSurgery(surgery);

      if (success) {
        emit(EditSurgerySuccess("تم تحديث العملية الجراحية بنجاح"));
        // Refresh the surgeries list
        await getUserSurgeries();
      } else {
        emit(EditSurgeryError("فشل في تحديث العملية الجراحية"));
        // Return to previous state if user has already loaded surgeries
        if (currentState is UserSurgeriesLoaded) {
          emit(UserSurgeriesLoaded(_surgeries));
        }
      }
    } catch (e) {
      emit(EditSurgeryError(e.toString()));
      // Return to previous state if user has already loaded surgeries
      if (currentState is UserSurgeriesLoaded) {
        emit(UserSurgeriesLoaded(_surgeries));
      }
    }
  }

  Future<void> deleteUserSurgery(int surgeryId) async {
    final currentState = state;

    emit(DeleteSurgeryLoading());
    try {
      final success = await surgeryRepository.deleteUserSurgery(surgeryId);

      if (success) {
        emit(DeleteSurgerySuccess("تم حذف العملية الجراحية بنجاح"));
       await getUserSurgeries();
      } else {
        emit(DeleteSurgeryError("فشل في حذف العملية الجراحية"));
        if (currentState is UserSurgeriesLoaded) {
          emit(UserSurgeriesLoaded(_surgeries));
        }
      }
    } catch (e) {
      emit(DeleteSurgeryError(e.toString()));
      if (currentState is UserSurgeriesLoaded) {
        emit(UserSurgeriesLoaded(_surgeries));
      }
    }
  }
}