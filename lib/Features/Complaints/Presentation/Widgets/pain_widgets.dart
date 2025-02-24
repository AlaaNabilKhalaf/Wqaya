import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/custom_slider.dart';

class PainWidgets extends StatefulWidget {

  const PainWidgets({super.key});

  @override
  State<PainWidgets> createState() => _PainWidgetsState();
}

class _PainWidgetsState extends State<PainWidgets> {
  int index=0;
  final List<String> durations=[
    "dayToWeek",
    "weekToTwoWeeks",
    "twoWeeksToMonth",
    "monthToMore",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RegularText(
              text: "painScale",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            const SizedBox(width: 10,),
            Column(
              children: [
                SizedBox(height: 10.h,),
                CustomSlider(),
              ],
            ),
          ],
        ),
        Row(
          children: [
            RegularText(
              text: "painDuration",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(height: 10.h,),
                InkWell(
                  radius: 15,
                  onTap: () {
                    if(index==3){
                      index = 0;
                    }else {
                      index++;
                    }
                    setState(() {
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: unselectedContainerColor)),
                    child: Row(
                      children: [
                        RegularText(
                          text: durations[index],
                          fontSize: 20.sp,
                          textColor: primaryColor,
                          fontFamily: medium,
                        ),
                        Transform.rotate(
                          angle: 1.5708,
                          child : const PlatformAdaptiveIcon(
                            cupertinoIcon: Icons.switch_left, materialIcon: Icons.switch_left,
                            color: primaryColor,
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

          ],
        ),
      ],
    );
  }
}
