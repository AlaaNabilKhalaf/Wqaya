import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/utils/fonts.dart';

class SymptomContainer extends StatelessWidget {
  const SymptomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: textFieldColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(2, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Text(
                "highTemp",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: primaryColor,
                  fontFamily: bold,
                ),
                softWrap: true,
              ).tr(),
            ),
            const Spacer(),
            const PlatformAdaptiveIcon(
              cupertinoIcon: Icons.check_box,
              materialIcon: Icons.check_box_outline_blank,
              color: unselectedContainerColor,
            ),
          ],
        ),
      ),
    );
  }
}
