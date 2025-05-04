import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/model/home_models.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());


  Future<void> fetchSymptomCategories() async {
    emit(SymptomLoading());

    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/SymptomsCategories/page',
        queryParameters: {
          'pageNumber': 1,
          'pageSize': 111,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 && response.data['succeeded'] == true) {
        final items = response.data['data']['items'] as List;
        final categories = items
            .map((item) => SymptomCategory.fromJson(item))
            .toList();

        emit(SymptomLoaded(categories));
      } else {
        emit(SymptomError(response.data['message'] ?? 'Unknown API error'));
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message ?? 'Network error';
      emit(SymptomError(msg));
    } catch (e) {
      emit(SymptomError('Unexpected error: $e'));
    }
  }
  void fetchChronicDiseases() async {
    emit(SymptomLoading());
    try {
      final response = await Dio().get(
        'https://wqaya.runasp.net/api/Diseases/ChronicDiseases?pageNumber=1&pageSize=111',
        options: Options(headers: {
          'Authorization': 'Bearer ${CacheHelper().getData(key: 'token')}', // insert your token variable
          'accept': '*/*'
        }),
      );
      final items = response.data['data']['items'] as List;
      final diseases = items.map((e) => ChronicDiseaseModel.fromJson(e)).toList();
      emit(ChronicDiseasesLoaded(diseases: diseases));
    } catch (e) {
      emit(SymptomError('Failed to load chronic diseases'));
    }
  }
}
