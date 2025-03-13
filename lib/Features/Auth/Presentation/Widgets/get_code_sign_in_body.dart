import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/pin_code_widget.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/texts.dart';
import '../Views/following_up_view.dart';

class GetCodeSignInBody extends StatelessWidget {
  const GetCodeSignInBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>(); // Access your Cubit

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          RegularText(
            text: 'welcomeToYou',
            fontSize: 70.sp,
            textColor: primaryColor,
            fontFamily: bold,
          ),
          SizedBox(height: 10.h),
          RegularText(
            text: 'codeIsSent',
            fontSize: 30.sp,
            textColor: primaryColor,
            fontFamily: medium,
          ),
          SizedBox(height: 30.h),
          PinCodeWidget(
            nextText: 'continue',
            nextScreen: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FollowingUpView(),
                ),
              );
            },
            verifyEmail: (verificationCode) {
              authCubit.verifyEmail(verificationCode: verificationCode);
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}