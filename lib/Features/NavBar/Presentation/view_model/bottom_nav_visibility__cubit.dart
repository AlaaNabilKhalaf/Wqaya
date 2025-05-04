import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavVisibilityCubit extends Cubit<bool> {
  BottomNavVisibilityCubit() : super(true);

  void show() => emit(true);
  void hide() => emit(false);
}
