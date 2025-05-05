import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/models/medicine_model.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineInitial());
  Future<void> getUserMedicine() async {
    emit(UserMedicineLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/MedicalHistory/medicines?pageNumber=1&pageSize=111',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
        ),
      );

      final data = response.data['data']['items'] as List;
      final medicines = data.map((e) => MedicineModel.fromJson(e)).toList();
      emit(UserMedicineLoaded(medicines));
    } catch (e) {
      emit(UserMedicineError('Failed to load medicines'));
    }
  }

}
