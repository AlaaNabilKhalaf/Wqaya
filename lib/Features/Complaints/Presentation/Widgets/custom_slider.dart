import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/view_model/complaint_cubit.dart';

// Updated CustomSlider to report pain level values
class CustomSlider extends StatefulWidget {
  final Function(double) onValueChanged;
  final double? initialValue; // Value in the 0–10 scale

  const CustomSlider({
    super.key,
    required this.onValueChanged,
    this.initialValue,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    // Use initialValue if provided (convert 0–10 to 0–1 scale), otherwise default to 0.3
    sliderValue = (widget.initialValue != null)
        ? (widget.initialValue!.clamp(0, 10) / 10)
        : 0.3;

    // Trigger initial callback if initialValue is provided
    if (widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onValueChanged(sliderValue * 10);
      });
    }
  }

  String mapPainToSeverity(double painLevel) {
    int pain = (painLevel * 10).round();

    if (pain <= 1) return 'Trivial';
    if (pain <= 2) return 'Low';
    if (pain <= 4) return 'Moderate';
    if (pain <= 5) return 'Medium';
    if (pain <= 6) return 'Significant';
    if (pain <= 7) return 'High';
    if (pain <= 8) return 'Severe';
    if (pain <= 9) return 'Critical';
    return 'Fatal';
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = getResponsiveSize(context, fontSize: 250);
    return Stack(
      children: [
        Container(
          width: maxWidth,
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: unselectedContainerColor,
          ),
        ),
        Container(
          width: sliderValue * maxWidth,
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
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
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
                widget.onValueChanged(value * 10);
              },
            ),
          ),
        ),
        Positioned(
          right: 10,
          child: RegularTextWithLocalization(
            text: "0",
            fontSize: 10.sp,
            textColor: myWhiteColor,
            fontFamily: medium,
          ),
        ),
        Positioned(
          left: 10,
          child: RegularTextWithLocalization(
            text: "10",
            fontSize: 10.sp,
            textColor: myWhiteColor,
            fontFamily: medium,
          ),
        ),
        Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              ComplaintEnums.severityOptionsArabic[mapPainToSeverity(sliderValue)] ?? "",
              style: TextStyle(
                fontSize: 12.sp,
                color: primaryColor,
                fontFamily: medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
