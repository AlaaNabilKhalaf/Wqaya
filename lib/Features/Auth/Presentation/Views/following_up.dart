import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/assets_data.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class FollowingUpView extends StatelessWidget {
  const FollowingUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(30.h),
          child: const CustomAppBar()),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RegularText(text: 'followingUP', fontSize: 40.sp, textColor: primaryColor, fontFamily: bold),
        Image.asset(AssetsData.dots),

      ],
      ),
    );
  }
}
