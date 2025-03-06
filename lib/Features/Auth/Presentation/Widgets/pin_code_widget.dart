import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_ alert.dart';

class PinCodeWidget extends StatelessWidget {
  const PinCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
      PinCodeTextField(
        appContext: context,
        length: 4,
        onCompleted: (v){
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissing by tapping outside
            builder: (BuildContext context) {
              return const CustomAlert();
            },
          );
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(15.r),
          borderWidth: 0,
          fieldHeight: 60,
          fieldWidth: 60,
          inactiveFillColor:const Color(0xffEBF0F5),
          activeFillColor: primaryColor,
          selectedFillColor: const Color(0xffEBF0F5),
          inactiveColor: const Color(0xffEBF0F5),
          selectedColor: const Color(0xffEBF0F5),
          activeColor: primaryColor,
        ),
        keyboardType: TextInputType.number,
        enableActiveFill: true,
      );
  }
}
