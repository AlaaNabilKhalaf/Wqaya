abstract class ApiProfileStates {}

class InitialApiProfileState extends ApiProfileStates{}
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

