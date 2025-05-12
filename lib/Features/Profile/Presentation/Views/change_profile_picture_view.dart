import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/global_variables.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_cubit.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_states.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/custom_home_app_bar.dart';
import '../../../../Core/widgets/image_picker_widget.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../Widgets/profile_card.dart';

class ChangeProfilePictureView extends StatefulWidget {
  const ChangeProfilePictureView({super.key});

  @override
  State<ChangeProfilePictureView> createState() => _ChangeProfilePictureViewState();
}
TextEditingController currentPasswordController = TextEditingController();
bool passwordIsVisible = false;


class _ChangeProfilePictureViewState extends State<ChangeProfilePictureView> {

  @override
  void initState() {
    // TODO: implement initState
    currentPassword = CacheHelper().getData(key: 'currentPassword');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
                RegularTextWithLocalization(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
                SizedBox(height: 38.h,),
                ProfileCard(cardAction: 'changeProfilePicture', textColor: myWhiteColor,cardColor: primaryColor, onTap: (){
                }),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CustomTextFormField(
                    icon: GestureDetector(
                        onTap: (){
                          setState(() {
                            passwordIsVisible = !passwordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: passwordIsVisible )),
                    isPasswordVisible: passwordIsVisible,
                    fieldController: currentPasswordController, hintText: 'كلمة السر الحالية',),
                ),
                const ImagePickerWidget(),

                BlocConsumer<ProfileImageCubit,ProfileImageStates>(
                  listener: (context , state){
                    if (state is UploadProfilePictureFailState){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: RegularTextWithoutLocalization(
                            text: state.message,
                            fontSize: 15.sp,
                            textColor: Colors.white,
                            fontFamily: bold,
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else if (state is UploadProfilePictureSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: RegularTextWithoutLocalization(
                            text: state.message,
                            fontSize: 15.sp,
                            textColor: Colors.white,
                            fontFamily: bold,
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },

                  builder: (context , state ){
                  return state is !UploadProfilePictureLoadingState?
                  ProfileCard(cardAction: 'confirm',
                    onTap: () {
                      if (currentPassword! == currentPasswordController.text.toString()) {
                        BlocProvider.of<ProfileImageCubit>(context).uploadProfilePicture();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: RegularTextWithoutLocalization(
                              text: "كلمة السر الحالية خاطئة",
                              fontSize: 15.sp,
                              textColor: Colors.white,
                              fontFamily: bold,
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },

                    cardColor: primaryColor,textColor: myWhiteColor,)  :
                  const Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                  ),
                  );
                },

                )



              ],
            ),
          ),
        )

    );
  }
}
