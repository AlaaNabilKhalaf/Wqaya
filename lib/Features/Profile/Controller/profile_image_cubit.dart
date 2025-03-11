import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_states.dart';
class ProfileImageCubit extends Cubit<ProfileImageStates>{
  ProfileImageCubit() : super (InitialProfileImageState());


  File? imgFile ;
  bool imagePicked = false;

//   void pickImageMethod( ImageSource source) async {
//   final ImagePicker picker = ImagePicker();
//   final XFile? img = await picker.pickImage(
//   source: source,
//   maxWidth: 400,
//   );
//   if (img == null) return;
//
//   imgFile = File(img.path); // convert it to a Dart:io file
//   emit(ProfileImagePikedState());
//
// }
  //

  void takeImageFromGallery(ImageSource gallery) async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;

    imgFile = File(img.path); // convert it to a Dart:io file
    emit(ProfileImagePikedState());

  }






}