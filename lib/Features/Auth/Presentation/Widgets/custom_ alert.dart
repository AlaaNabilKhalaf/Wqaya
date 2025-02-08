import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

import '../../../../Core/Utils/assets_data.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
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
            RegularText(text:'confirmed', fontSize: 50.sp, textColor: Colors.white, fontFamily: bold)
          ],
        ),
      ),
    );
  }
}
