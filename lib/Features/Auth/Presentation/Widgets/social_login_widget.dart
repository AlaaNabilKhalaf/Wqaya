import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/social_bottoms_container.dart';
import '../../../../Core/Utils/assets_data.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/texts.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(height: 40.h,),

        //Others Bottom
        RegularText(text: 'other', fontSize: 16.sp, textColor: primaryColor, fontFamily: semiBold),
SizedBox(height: 20.h,),
        //Social Bottoms
        SizedBox(
          width: 200,height: 45.h,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SocialBottomsContainer(image: AssetsData.apple,),
              SocialBottomsContainer(image: AssetsData.facebook,),
              SocialBottomsContainer(image: AssetsData.google,),

            ],
          ),
        )
      ],
    );
  }
}
