import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.fieldController,
  });

  final TextEditingController fieldController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldController,
      cursorColor: myWhiteColor,
      style: const TextStyle(fontFamily: medium, color: myWhiteColor),
      decoration: InputDecoration(
        hoverColor: myWhiteColor,
        filled: true,
        fillColor: primaryColor,
        hintStyle: TextStyle(
          color: myWhiteColor.withValues(alpha:.7),
          fontFamily: medium,
          fontSize: 16.sp,
        ),
        hintText: "Ask me about your health...",
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}