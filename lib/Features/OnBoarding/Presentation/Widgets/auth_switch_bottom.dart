import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';

import '../../../../Core/utils/colors.dart';
import '../../../Auth/Presentation/Views/login_view.dart';
import '../../../Auth/Presentation/Views/signup_view.dart';

class AuthSwitchBottom extends StatelessWidget {
  const AuthSwitchBottom({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47.h,
      margin: EdgeInsets.symmetric(horizontal: 22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: primaryColor
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
      children: [
        Expanded(child: RegularButton(
            borderColor: Colors.transparent,

            buttonColor: bottomColor , borderRadius: 22.r, onTap: (){

              Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginView()));

        },
            child: RegularTextWithLocalization(text: 'login', fontSize: 16.sp, textColor: myWhiteColor, fontFamily: bold))),

        Expanded(child: RegularButton(
          borderColor: Colors.transparent,
            buttonColor: primaryColor , borderRadius: 0, onTap: (){

          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpView()));

        },
            child: RegularTextWithLocalization(text: 'signup', fontSize: 16.sp, textColor: myWhiteColor, fontFamily: bold))),
      ],
      ),
    );
  }
}
