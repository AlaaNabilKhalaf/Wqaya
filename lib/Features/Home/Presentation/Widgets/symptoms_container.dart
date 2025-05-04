import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';

class SymptomsContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onSelected;

  const SymptomsContainer({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : unselectedContainerColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                color: myWhiteColor,
                fontFamily: medium,
              ),
              maxLines: 6,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
