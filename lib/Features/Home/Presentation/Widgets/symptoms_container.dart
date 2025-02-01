import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
class SymptomsContainer extends StatefulWidget {
  final String text;
  final VoidCallback onSelected;

  const SymptomsContainer({super.key, required this.text, required this.onSelected});

  @override
  State<SymptomsContainer> createState() => _SymptomsContainerState();
}

class _SymptomsContainerState extends State<SymptomsContainer> {
  bool isContainerSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            isContainerSelected = !isContainerSelected;
          });
          widget.onSelected(); // Notify parent about selection change
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isContainerSelected ? primaryColor : unselectedContainerColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: RegularText(
              text: widget.text,
              fontSize: 15.sp,
              textColor: myWhiteColor,
              fontFamily: medium,
              maxLine: 6,
            ),
          ),
        ),
      ),
    );
  }
}

