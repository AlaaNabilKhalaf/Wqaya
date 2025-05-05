part of 'ray_cubit.dart';

@immutable
sealed class RayCubitState {}

final class RayCubitInitialState extends RayCubitState {}
class RayLoading extends RayCubitState {}

class RaySuccess extends RayCubitState {
  final List<RayModel> rays;
  RaySuccess(this.rays);
}

class RayError extends RayCubitState {
  final String message;
  RayError(this.message);
}
class AddRayLoading extends RayCubitState {}

class AddRaySuccess extends RayCubitState {
}

class AddRayError extends RayCubitState {
}class DeleteRayLoading extends RayCubitState {}

class DeleteRaySuccess extends RayCubitState {
}

class DeleteRayError extends RayCubitState {
  final String message;

  DeleteRayError({required this.message});

}
class EditRayLoading extends RayCubitState {}
class EditRaySuccess extends RayCubitState {}
class EditRayError extends RayCubitState {
  final String? message;
  EditRayError({this.message});
}
class SearchRaysLoading extends RayCubitState {}

class SearchRaysSuccess extends RayCubitState {
  final List<RayModel> rays;

  SearchRaysSuccess(this.rays);
}

class SearchRaysError extends RayCubitState {
  final String message;

  SearchRaysError(this.message);
}