import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

import '../Utils/colors.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    this.confirmText,
    this.nextText,

    required this.nextScreenFunction
  });
  final String? confirmText;
  final String? nextText;
final Function nextScreenFunction;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: GestureDetector(
          onTap: (){
            nextScreenFunction();
          },
          child: Container(
            width: 350.w,
            height: 350.h,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Check Icon
                SizedBox(
                  child: Image.asset("assets/images/auth_view/check.png"),
                ),
                SizedBox(height: 20.h),
                // Confirmation Text
                RegularTextWithLocalization(text: confirmText??'confirmed', fontSize: 40.sp, textColor: Colors.white, fontFamily: bold),
                Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 10),
                  child: GestureDetector(
                    onTap: (){
                   nextScreenFunction();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RegularTextWithLocalization(text:nextText?? 'next', fontSize: 20.sp, textColor: myWhiteColor, fontFamily: bold),
                        nextText != '' ?const Icon(Icons.arrow_forward_rounded, color: myWhiteColor,size: 23,) : const SizedBox()
                      ],),
                  ),
                )
              ],
            ),
          ),

      ),
    );
  }
}
