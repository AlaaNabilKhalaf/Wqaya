import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_state.dart';

class SurgeryCubit extends Cubit<SurgeryState> {
  final SurgeryRepository surgeryRepository;
  List<Surgery> _surgeries = [];
  Timer? _searchDebounce;

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

  Future<void> searchUserSurgeries({required String keyword}) async {
    emit(SearchSurgeriesLoading());
    try {
      if (keyword.trim().isEmpty) {
        // If search is empty, load all surgeries
        await getUserSurgeries();
        return;
      }

      final response = await surgeryRepository.searchUserSurgeries(keyword);
      emit(SearchSurgeriesSuccess(response));
    } catch (e) {
      emit(SearchSurgeriesError('حدث خطأ أثناء تنفيذ البحث: ${e.toString()}'));
    }
  }

  void onSearchChanged(String query) {
    // Cancel previous debounce timer
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce!.cancel();
    }

    // Setup new timer
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        // If search field is empty, fetch all surgeries
        getUserSurgeries();
      } else {
        // Otherwise perform search
        searchUserSurgeries(keyword: query);
      }
    });
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

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}