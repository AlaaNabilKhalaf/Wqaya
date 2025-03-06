import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/colors.dart';
import '../Utils/fonts.dart';

class CustomDropdownPhones extends StatefulWidget {
  const CustomDropdownPhones({super.key});

  @override
  State<CustomDropdownPhones> createState() => _CustomDropdownPhonesState();
}

class _CustomDropdownPhonesState extends State<CustomDropdownPhones> {
// List of governments
  final List<String> governments = [
    '+020',
    '+050',
    '+080',
    '+040',
    '+090',
  ];

// Selected government
  String selectedGovernment = '+020';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          dropdownColor: myWhiteColor,
          menuWidth: MediaQuery.of(context).size.width*0.25,
          elevation: 2,
          borderRadius: BorderRadius.circular(25.r),
          value: selectedGovernment,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: bottomColor, // Dropdown arrow color
          ),
          underline: const SizedBox(), // Removes the default underline
          items: governments.map((String government) {
            return DropdownMenuItem<String>(
              value: government,
              child: Text(
                government,
                style: TextStyle(
                    color: bottomColor, // Text color
                    fontSize: 16.sp,
                    fontFamily: medium
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedGovernment = newValue!;
            });
          },
        ),
      ],
    );
  }
}
