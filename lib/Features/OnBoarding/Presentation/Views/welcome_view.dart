import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Views/on_boarding_view.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/image_container.dart';
import '../../../../Core/widgets/regular_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      const ImageContainer(image: AssetsData.boarding1),

          Column(
            children: [
              RegularText(text: 'welcome', fontSize: 30.sp, textColor: primaryColor, fontFamily: black),
              RegularText(
                  text: 'weAimeTo', fontSize: 25.sp,
                  textAlign: TextAlign.center,
                  textColor: primaryColor, fontFamily: medium),
            ],
          ),

        Padding(
          padding:  EdgeInsets.only(bottom: 48.h),
          child: RegularButton(
              width: 44.w, height: 44.h, buttonColor: primaryColor, borderRadius: 15.r, onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const OnBoardingView()));

          },
              child: const Icon(Icons.arrow_back_rounded,color: myWhiteColor,)),
        )

        ],
      ),

    );
  }
}
