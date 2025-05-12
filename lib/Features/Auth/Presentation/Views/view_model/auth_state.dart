part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class SignInLoadingState extends AuthState {}
final class SignInSuccessState extends AuthState {
  final String token;

  SignInSuccessState({required this.token});
}
final class SignInFailureState extends AuthState {
  final String error;

  SignInFailureState({required this.error});

}
final class RegisterLoadingState extends AuthState {}
final class RegisterSuccessState extends AuthState {
  final String message;
  final String userId;

  RegisterSuccessState({required this.message, required this.userId});
}
final class RegisterFailureState extends AuthState {
  final String message;
  RegisterFailureState({required this.message});
}
final class VerificationLoadingState extends AuthState {}
final class VerificationSuccessState extends AuthState {
  final String message;

  VerificationSuccessState({required this.message});
}
final class VerificationFailureState extends AuthState {
  final String error;

  VerificationFailureState({required this.error});}
class ForgotPasswordLoadingState extends AuthState {}
class ForgotPasswordSuccessState extends AuthState {
  final String message;

  ForgotPasswordSuccessState({required this.message});
}
class ForgotPasswordFailureState extends AuthState {
  final String error;

  ForgotPasswordFailureState({required this.error});
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final String message;
  ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailure extends AuthState {
  final String error;
  ResetPasswordFailure({required this.error});
}
class CheckCodeLoadingState extends AuthState {}
class CheckCodeSuccessState extends AuthState {
  final String message;
  CheckCodeSuccessState({required this.message});
}

class CheckCodeFailureState extends AuthState {
  final String error;
  CheckCodeFailureState({required this.error});
}

final class FollowUpLoadingState extends AuthState {}
final class FollowUpSuccessState extends AuthState {
}
final class FollowUpFailureState extends AuthState {
  final String error;

  FollowUpFailureState({required this.error});

}