import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_states.dart';

class ProfileImageCubit extends Cubit<ProfileImageStates> {
  ProfileImageCubit() : super(InitialProfileImageState());

  File? imgFile;
  bool imagePicked = false;
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wqaya.runasp.net"));

  void takeImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );
    if (img == null) return;

    imgFile = File(img.path);
    imagePicked = true;
    emit(ProfileImagePickedState());
  }

  Future<void> uploadProfilePicture() async {
    if (imgFile == null) {
      emit(UploadProfilePictureFailState(message: "لم يتم اختيار صورة"));
      return;
    }

    emit(UploadProfilePictureLoadingState());

    try {
      String fileName = imgFile!.path.split('/').last;

      FormData formData = FormData.fromMap({
        "profilePic": await MultipartFile.fromFile(imgFile!.path, filename: fileName),
      });

      final response = await _dio.put(
        "/api/Patient/profile-pic",
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "accept": "*/*",
          "Authorization": "Bearer ${CacheHelper().getData(key: 'token')}",
        }),

      );
      if(CacheHelper().getData(key: 'profileImage') == null){
        CacheHelper().saveData(key: 'profileImage', value: imgFile);

      }else{
        CacheHelper().removeData(key: 'profileImage');
        CacheHelper().saveData(key: 'profileImage', value: imgFile);
      }

      emit(UploadProfilePictureSuccessState(message: "تم تغيير الصورة بنجاح"));
    } on DioException catch (e) {
      emit(UploadProfilePictureFailState(message: e.response?.data?.toString() ?? "خطأ غير معروف من السيرفر"));
    }
  }
}
