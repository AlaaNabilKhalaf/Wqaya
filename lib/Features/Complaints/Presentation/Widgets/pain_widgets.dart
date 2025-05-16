import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/custom_slider.dart';

// Updated PainWidgets to connect with severity levels

class PainWidgets extends StatefulWidget {
  final Function(double) onPainLevelChanged;
  final Function(String) onDurationChanged;

  const PainWidgets({
    super.key,
    required this.onPainLevelChanged,
    required this.onDurationChanged,
  });

  @override
  State<PainWidgets> createState() => _PainWidgetsState();
}

class _PainWidgetsState extends State<PainWidgets> {
  int index = 0;
  final List<String> durations = [
    "Hours",
    "Days",
    "Weeks",
    "Months",
    "Years",
  ];

  // Arabic translations for the durations
  final Map<String, String> durationTranslations = {
    "Hours": "ساعات",
    "Days": "أيام",
    "Weeks": "أسابيع",
    "Months": "شهور",
    "Years": "سنوات",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RegularTextWithLocalization(
              text: "مدة الألم",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(height: 10.h),
                InkWell(
                  radius: 15,
                  onTap: () {
                    if (index == durations.length - 1) {
                      index = 0;
                    } else {
                      index++;
                    }
                    setState(() {});

                    // Notify parent about the duration change
                    widget.onDurationChanged(durations[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: textFieldColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: unselectedContainerColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          durationTranslations[durations[index]] ?? durations[index],
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: primaryColor,
                            fontFamily: medium,
                          ),
                        ),
                        Transform.rotate(
                          angle: 1.5708,
                          child: const PlatformAdaptiveIcon(
                            cupertinoIcon: Icons.switch_left,
                            materialIcon: Icons.switch_left,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const RegularTextWithLocalization(
              text: "مستوى الألم",
              fontSize: 18,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                SizedBox(height: 10.h),
                CustomSlider(
                  onValueChanged: (value) {
                    // Pass the pain level value back to the parent
                    widget.onPainLevelChanged(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}