import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';

class SocialBottomsContainer extends StatelessWidget {
  const SocialBottomsContainer({
    super.key,
  required this.image
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 44.h,width: 60.w,
      decoration: BoxDecoration(
        color: bottomColor,
        borderRadius: BorderRadius.circular(10.r)
      ),

      child: Image.asset(image,height:19.h,width: 19.w,),
    );
  }
}
