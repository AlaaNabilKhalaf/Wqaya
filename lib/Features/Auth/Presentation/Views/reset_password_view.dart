import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';

import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../../Profile/Presentation/Widgets/profile_card.dart';
import '../Widgets/social_login_widget.dart';
import 'login_view.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}
TextEditingController newPasswordController = TextEditingController();
TextEditingController confirmNewPasswordController = TextEditingController();
bool newPasswordIsVisible = false;
bool confirmNewPasswordIsVisible = false;
class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar()),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              RegularText(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
              RegularText(text: 'resetPassword', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(
                      icon: GestureDetector(
                          onTap: (){
                            setState(() {
                              newPasswordIsVisible = !newPasswordIsVisible;
                            });
                          },
                          child: PasswordIcon(isVisible: newPasswordIsVisible )),
                      isPasswordVisible: newPasswordIsVisible,
                      fieldController: newPasswordController, hintText: 'كلمة السر الجديدة',),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(
                      icon: GestureDetector(
                          onTap: (){
                            setState(() {
                              confirmNewPasswordIsVisible = !confirmNewPasswordIsVisible;
                            });
                          },
                          child: PasswordIcon(isVisible: confirmNewPasswordIsVisible )),
                      isPasswordVisible: confirmNewPasswordIsVisible,
                      fieldController: confirmNewPasswordController, hintText: 'اعادة كتابة كلمة السر الجديدة',),
                  ),
                  // SizedBox(width: 100.h,),

                  ProfileCard(cardAction: 'confirm', onTap: (){
                    showDialog(
                      context: context,
                      barrierDismissible: false, // Prevent dismissing by tapping outside
                      builder: (BuildContext context) {
                        return CustomAlert(
                          nextScreenFunction: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginView()));
                        },nextText: 'backToLogin',);
                      },
                    );


                  },cardColor: primaryColor,textColor: myWhiteColor,)

                ],
              ),

              const Spacer(),
              const SocialLoginWidget()
            ],
          ),
        )
    );
  }
}
