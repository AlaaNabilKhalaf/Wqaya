import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../Core/Utils/colors.dart';

class PinCodeWidget extends StatelessWidget {
  const PinCodeWidget({
    super.key,
    required this.nextScreen,
    required this.verifyEmail, // Add this parameter
    this.nextText,
  });

  final Function nextScreen;
  final Function(String) verifyEmail; // Method to verify email
  final String? nextText;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        onCompleted: (verificationCode) {
          verifyEmail(verificationCode);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              );
            },
          );
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(15.r),
          borderWidth: 0,
          fieldHeight: 60,
          fieldWidth: 60,
          inactiveFillColor: const Color(0xffEBF0F5),
          activeFillColor: primaryColor,
          selectedFillColor: const Color(0xffEBF0F5),
          inactiveColor: const Color(0xffEBF0F5),
          selectedColor: const Color(0xffEBF0F5),
          activeColor: primaryColor,
        ),
        keyboardType: TextInputType.number,
        enableActiveFill: true,
      ),
    );
  }
}