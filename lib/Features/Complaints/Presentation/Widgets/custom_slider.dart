import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}


class _CustomSliderState extends State<CustomSlider> {
  double sliderValue = 0.3;

  @override
  Widget build(BuildContext context) {
    double maxWidth = getResponsiveSize(context, fontSize: 250);
    return Stack(
      children: [
        Container(
          width: getResponsiveSize(context, fontSize: maxWidth),
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: unselectedContainerColor,
          ),
        ),
        Container(
          width: getResponsiveSize(context, fontSize: sliderValue * maxWidth),
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: primaryColor,
          ),
        ),
        SizedBox(
          width: maxWidth,
          height: 25,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0), // Thumb size
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              thumbColor: Colors.transparent,
              activeTrackColor: primaryColor,
              inactiveTrackColor: primaryColor,
            ),
            child: Slider(
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
            ),
          ),
        ),
        Positioned(
          right: 10,
          child: RegularText(
            text: "0",
            fontSize: 10.sp,
            textColor: myWhiteColor,
            fontFamily: medium,
          ),
        ),
        Positioned(
          left: 10,
          child: RegularText(
            text: "10",
            fontSize: 10.sp,
            textColor: myWhiteColor,
            fontFamily: medium,
          ),
        )
      ],
    );
  }
}
