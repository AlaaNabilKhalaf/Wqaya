import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/utils/assets_data.dart';
import '../../../../Core/widgets/texts.dart';

class DeveloperNamesWidget extends StatelessWidget {
  const DeveloperNamesWidget({
    super.key,
    required this.name1,
     required this.name2,
    required this.name3
  });
  final String name1;
  final String name2;
  final String name3;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:5),
          child: Image.asset(AssetsData.smallDot),
        ),

        Padding(
          padding: const EdgeInsets.only(top:5,bottom: 3,right: 5),
          child: RegularTextWithLocalization(
              text:name1,
              fontSize: 18.sp, textColor: primaryColor, fontFamily: light),
        ),
        SizedBox(width: 30.w,),
        name2 != ""?
        Padding(
          padding: const EdgeInsets.only(top:5,bottom: 3,right: 5),
          child: RegularTextWithLocalization(
              text:name2,
              fontSize: 18.sp, textColor: primaryColor, fontFamily: light),
        ) : const SizedBox(),
        name3 != ""?
        Padding(
          padding: const EdgeInsets.only(top:5,bottom: 3,right:30,),
          child: RegularTextWithLocalization(
              text: name3,
              fontSize: 18.sp, textColor: primaryColor, fontFamily: light),
        ) : const SizedBox(),
      ],
    );
  }
}