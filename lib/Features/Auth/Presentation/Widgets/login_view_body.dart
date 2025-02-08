import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/social_login_widget.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import 'custom_dropdown_phones.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}
TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordController = TextEditingController();
class _LoginViewBodyState extends State<LoginViewBody> {
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
              RegularText(text: 'startLogin', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 19.h,),

              CustomTextFormField(fieldController: passwordController, hintText: 'الرقم السري'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 19.h,horizontal: 5.w),
                child: RegularText(text: 'forgetPassword', fontSize: 12.sp, textColor: bottomColor, fontFamily: medium),
              ),
              RegularButton(
                  height: 55.h,
                  buttonColor: primaryColor, borderRadius: 20.r, onTap: (){}, child: RegularText(text: 'login', fontSize: 20.sp, textColor: myWhiteColor, fontFamily: semiBold))

            ],
          ),


          const SocialLoginWidget()
        ],
      ),
    );
  }
}
