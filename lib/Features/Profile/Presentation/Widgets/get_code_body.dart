// ✅ GetCodeBody.dart - خاص بإدخال كود التحقق لتغيير الرقم

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/texts.dart';
import '../../../Auth/Presentation/Widgets/pin_code_widget.dart';
import '../../Controller/api_profile_cubit.dart';
import '../../Controller/api_profile_states.dart';

class GetCodeBody extends StatelessWidget {
  final String phone;
  const GetCodeBody({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiProfileCubit, ApiProfileStates>(
      listener: (context, state) {
        if (state is ChangePhoneSuccessState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تغيير الرقم بنجاح")),
          );
        } else if (state is ChangePhoneFailState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              RegularTextWithLocalization(
                text: 'welcomeToYou',
                fontSize: 70.sp,
                textColor: primaryColor,
                fontFamily: bold,
              ),
              SizedBox(height: 10.h),
              RegularTextWithLocalization(
                text: 'codeIsSent',
                fontSize: 30.sp,
                textColor: primaryColor,
                fontFamily: medium,
              ),
              SizedBox(height: 30.h),
              PinCodeWidget(
                nextScreen: () {},
                nextText: 'continue',
                verifyEmail: (verificationCode) {
                  context.read<ApiProfileCubit>().confirmChangePhone(
                    newPhone: phone,
                    code: int.tryParse(verificationCode) ?? 0,
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
