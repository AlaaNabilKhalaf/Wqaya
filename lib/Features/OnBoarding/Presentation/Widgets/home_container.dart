import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class HomeContainer extends StatelessWidget {
  final String text , image ;
  const HomeContainer({
    super.key, required this.text, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: unselectedContainerColor,
          borderRadius: BorderRadius.circular(15)
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(image,width: 100.w,fit: BoxFit.contain,),
          RegularTextWithLocalization(
            text: text,
            fontSize: 25.sp,
            textColor: myWhiteColor,
            fontFamily: black,
          ),

        ],
      ),
    );
  }
}
