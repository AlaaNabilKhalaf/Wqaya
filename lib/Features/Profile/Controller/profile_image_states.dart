abstract class ProfileImageStates {}

class InitialProfileImageState extends ProfileImageStates{}
class ProfileImagePickedState extends ProfileImageStates{}
class UploadProfilePictureFailState extends ProfileImageStates{
  UploadProfilePictureFailState(
      {
        required this.message
      });
  String message ;
}
class UploadProfilePictureLoadingState extends ProfileImageStates{}
class UploadProfilePictureSuccessState extends ProfileImageStates{
  UploadProfilePictureSuccessState({
    required this.message
  });
  String message ;
}
