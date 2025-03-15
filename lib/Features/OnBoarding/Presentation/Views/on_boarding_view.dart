import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/image_container.dart';
import '../../../../Core/utils/fonts.dart';
import '../Widgets/auth_switch_bottom.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      body: Column(
        children: [
          const ImageContainer(image: AssetsData.boarding2),
          SizedBox(height: 70.h,),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const  AuthSwitchBottom(),
                SizedBox(height: 80.h,),
                RegularTextWithLocalization(text:'pleaseCreateYourAccount', fontSize: 20.sp, textColor: primaryColor, fontFamily: bold),

                // Padding(
                //   padding:  EdgeInsets.only(bottom: 48.h),
                //   child: RegularButton(
                //       width: 45.w, height: 45.h, buttonColor: primaryColor, borderRadius: 15.r, onTap: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context)=> const NavBarView()));
                //
                //   },
                //       child: const Icon(Icons.arrow_back_rounded,color: myWhiteColor,)),
                // ),
              ],
            ),
          )


        ],
      ),

    );
  }
}
