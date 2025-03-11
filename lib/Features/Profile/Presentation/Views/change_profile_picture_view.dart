import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Features/Profile/Presentation/Views/profile_view.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/custom_home_app_bar.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
        body:SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h,),

                RegularText(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
                RegularText(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
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
               SizedBox(height: 200.h,),
                ProfileCard(cardAction: 'confirm', onTap: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent dismissing by tapping outside
                    builder: (BuildContext context) {
                      return CustomAlert(nextScreenFunction: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileView()));
                      },nextText: 'back',);

                    },
                  );


                },cardColor: primaryColor,textColor: myWhiteColor,)



              ],
            ),
          ),
        )

    );
  }
}
