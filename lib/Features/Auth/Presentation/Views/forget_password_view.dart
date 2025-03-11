import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/social_login_widget.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../../../../Core/widgets/custom_dropdown_phones.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import 'get_code_to_reset_password.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}
TextEditingController phoneNumberController = TextEditingController();

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              RegularText(text: 'enterPhoneNumber', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
              Padding(
                padding: const EdgeInsets.only(top: 40,bottom: 19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.64,
                        child: CustomTextFormField(
                            textInputType: TextInputType.phone,
                            fieldController: phoneNumberController, hintText: 'رقم الهاتف')),
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
              ),
              RegularButton(
                  height: 55.h,
                  buttonColor: primaryColor, borderRadius: 20.r, onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const GetCodeToResetPassword()));

              }, child: RegularText(text: 'getCode', fontSize: 20.sp, textColor: myWhiteColor, fontFamily: semiBold)),
const Spacer(),
              const SocialLoginWidget()
            ],
          ),
        )
    );
  }
}
