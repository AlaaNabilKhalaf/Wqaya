abstract class ApiProfileStates {}

class InitialApiProfileState extends ApiProfileStates{}

// CHANGE PASSWORDS STATES
class ChangePasswordLoadingState extends ApiProfileStates{}

class ChangePasswordSuccessState extends ApiProfileStates{
  ChangePasswordSuccessState({
    required this.message
  });
  String message ;
}

class ChangePasswordFailState extends ApiProfileStates{
  ChangePasswordFailState({
     required this.message
});
  String message ;
}



// DELETE USER STATES
class DeleteUserLoadingState extends ApiProfileStates {}

class DeleteUserSuccessState extends ApiProfileStates {
  final String message;
  DeleteUserSuccessState({required this.message});
}

class DeleteUserFailState extends ApiProfileStates {
  final String error;
  DeleteUserFailState({required this.error});
}


// Request Change Phone States
class RequestChangePhoneLoadingState extends ApiProfileStates {}
class RequestChangePhoneSuccessState extends ApiProfileStates {
  final String message;
  RequestChangePhoneSuccessState({required this.message});
}
class RequestChangePhoneFailState extends ApiProfileStates {
  final String error;
  RequestChangePhoneFailState({required this.error});
}

// Confirm Change Phone States
class ChangePhoneLoadingState extends ApiProfileStates {}
class ChangePhoneSuccessState extends ApiProfileStates {
  final String message;
  ChangePhoneSuccessState({required this.message});
}
class ChangePhoneFailState extends ApiProfileStates {
  final String error;
  ChangePhoneFailState({required this.error});
}
