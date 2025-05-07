import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class ComplaintsHomeWidget extends StatelessWidget {
  const ComplaintsHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
        color: unselectedContainerColor,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                RegularTextWithLocalization(
                  text: "الشكاوى",
                  fontSize: 20.sp,
                  textColor: myWhiteColor,
                  fontFamily: black,
                ),
              ],
            ),
          ),
          Expanded(child: Image.asset(AssetsData.complaints,height: 80,)),

        ],
      ),
    );
  }
}
