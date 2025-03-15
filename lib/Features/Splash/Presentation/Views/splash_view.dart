import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Views/welcome_view.dart';
import '../../../../Core/utils/assets_data.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/fonts.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  endSplash(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const WelcomeView()));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
endSplash();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
        endSplash();
          },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin:EdgeInsets.only(bottom: 5.h) ,
                  height: 208.h,width: 189.w,
                  child: Image.asset(AssetsData.splashLogo )),
              // SvgImage(imagePath: AssetsData.splashLogo,height: 208.h,width: 189.w,),
              RegularTextWithLocalization(text:'logo', fontSize: 30.sp, textColor: myWhiteColor, fontFamily: regular),

            ],
          ),
        ),
      ),
    );
  }
}
