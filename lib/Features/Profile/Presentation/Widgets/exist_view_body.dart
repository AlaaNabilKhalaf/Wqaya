import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/login_view.dart';

import '../../../../Core/utils/fonts.dart';
import '../../../../Core/widgets/custom_ alert.dart';

class ExistViewBody extends StatefulWidget {
  const ExistViewBody({super.key});

  @override
  State<ExistViewBody> createState() => _ExistViewBodyState();
}
bool logoutBottom1isActive = false;
bool logoutBottom2isActive = false;
Color confirmBottomColor = textFormBackgroundColor;
Color confirmWordColor = primaryColor;
class _ExistViewBodyState extends State<ExistViewBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
              RegularTextWithLocalization(text: 'onLogoutScreen', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
            ],
          ),
          Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 18.w),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10.r,
                    )]),
                  child: RegularButton(buttonColor: logoutBottom1isActive? primaryColor : textFormBackgroundColor, borderRadius: 20.r, onTap: (){
                    setState(() {
                      logoutBottom1isActive = !logoutBottom1isActive;
                      logoutBottom2isActive = false;
                      confirmBottomColor = primaryColor;
                      confirmWordColor =Colors.white;
                    });
                  },height: 55.h,borderColor: primaryColor,borderWidth: 1, child: RegularTextWithLocalization(text: 'justLogout', fontSize: 20.sp, textColor: logoutBottom1isActive? Colors.white : primaryColor, fontFamily: semiBold,),)),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 18.w),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10.r,
                    )]),
                  child: RegularButton(buttonColor: logoutBottom2isActive? primaryColor : textFormBackgroundColor, borderRadius: 20.r, onTap: (){
                    setState(() {
                      logoutBottom2isActive = !logoutBottom2isActive;
                      logoutBottom1isActive = false;
                      confirmBottomColor = primaryColor;
                      confirmWordColor =Colors.white;
                    });
                  },height: 55.h,borderColor: primaryColor,borderWidth: 1, child: RegularTextWithLocalization(text: 'logoutAndDeleteAccount', fontSize: 20.sp, textColor: logoutBottom2isActive? Colors.white : primaryColor, fontFamily: semiBold,),)),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 18.w),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10.r,
                    )]),
                  child: RegularButton(buttonColor: confirmBottomColor, borderRadius: 20.r, onTap: (){
                if(confirmBottomColor == primaryColor){
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CustomAlert(
                        nextScreenFunction: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginView()));
                        },
                        nextText: 'exist',

                      );
                    },
                  );
                }
                    
                    
                  },height: 55.h,borderColor: primaryColor,borderWidth: 1, child: RegularTextWithLocalization(text: 'confirm', fontSize: 20.sp, textColor: confirmWordColor, fontFamily: semiBold,),)),
            ],
          ),

        ],
      ),
    );
  }
}
