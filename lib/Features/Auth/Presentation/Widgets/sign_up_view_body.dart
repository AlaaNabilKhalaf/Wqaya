import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/text_form_fields.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/get_code_to_sign_in.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/social_login_widget.dart';

import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/custom_dropdown_phones.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}
TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordConfirmController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool passwordIsVisible = false;
bool confirmPasswordIsVisible = false;

class _SignUpViewBodyState extends State<SignUpViewBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              RegularText(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
              RegularText(text: 'startSignUp', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(fieldController: nameController, hintText: 'الاسم'),
              SizedBox(height: 30.h,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.64,
                      child: CustomTextFormField(fieldController: phoneNumberController, hintText: 'رقم الهاتف')),
                  Container(
                    alignment: Alignment.center,
                    height: 55.h,
                    width: MediaQuery.of(context).size.width*0.25,
                    decoration: BoxDecoration(
                        border: Border.all(color: bottomColor,width:2),
                        color: textFormBackgroundColor,
                        boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
                        borderRadius: BorderRadius.circular(20.r)),
                    child: const CustomDropdownPhones(),
                  ),
                ],
              ),
              SizedBox(height: 30.h,),

              CustomTextFormField(
                isPasswordVisible: passwordIsVisible,
                fieldController: passwordController, hintText: 'الرقم السري',

                icon: GestureDetector(
                  onTap: (){
                    setState(() {
                      passwordIsVisible = !passwordIsVisible;
                    });
                  },
                  child: PasswordIcon(isVisible: passwordIsVisible )),
              ),

              SizedBox(height: 30.h,),

              CustomTextFormField(
                  isPasswordVisible: confirmPasswordIsVisible,
                  icon: GestureDetector(
                      onTap: (){
                        setState(() {
                          confirmPasswordIsVisible = !confirmPasswordIsVisible;
                        });
                      },
                      child: PasswordIcon(isVisible: confirmPasswordIsVisible )),

                  fieldController: passwordConfirmController, hintText: 'تاكيد الرقم السري'),
              SizedBox(height: 30.h,),

              RegularButton(
                  height: 55.h,
                  buttonColor: primaryColor, borderRadius: 20.r, onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const GetCodeToSignIn()));

              }, child: RegularText(text: 'getCode', fontSize: 20.sp, textColor: myWhiteColor, fontFamily: semiBold))

            ],
          ),

         const SocialLoginWidget()

        ],
      ),
    );
  }
}
