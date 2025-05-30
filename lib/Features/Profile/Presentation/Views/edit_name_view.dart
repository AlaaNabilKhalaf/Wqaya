import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_home_app_bar.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../Widgets/profile_card.dart';

class EditNameView extends StatefulWidget {
  const EditNameView({super.key});

  @override
  State<EditNameView> createState() => _EditNameViewState();
}
TextEditingController passwordController = TextEditingController();
TextEditingController newNameController = TextEditingController();
TextEditingController confirmNewNameController = TextEditingController();
bool passwordIsVisible = false;

class _EditNameViewState extends State<EditNameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.h,),

              RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
              RegularTextWithLocalization(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
              Column(
                children: [
                  SizedBox(height: 38.h,),

                  ProfileCard(cardAction: 'editName', textColor: myWhiteColor,cardColor: primaryColor, onTap: (){
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
                      fieldController: passwordController, hintText: ' كلمة السر',),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(fieldController: newNameController, hintText: ' الاسم الجديد',),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(fieldController: confirmNewNameController, hintText: 'اعادة كتابة الاسم الجديد',),
                  ),

                  ProfileCard(cardAction: 'confirm', onTap: (){
                    showDialog(
                      context: context,
                      barrierDismissible: true, // Prevent dismissing by tapping outside
                      builder: (BuildContext context) {
                        return CustomAlert (
                          nextText: '',
                          nextScreenFunction: (){},);

                      },
                    );


                  },cardColor: primaryColor,textColor: myWhiteColor,)

                ],
              ),




            ],
          ),
        ),
      )

    );

  }
}
