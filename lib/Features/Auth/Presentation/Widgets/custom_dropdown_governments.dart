import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';

class CustomDropdownButton extends StatefulWidget {
  final Function(String) onGovernorateChanged;

  const CustomDropdownButton({super.key, required this.onGovernorateChanged});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  List<String> governorates = [
    "Alexandria", "Aswan", "Asyut", "Beheira", "BeniSuef", "Cairo", "Dakahlia",
    "Damietta", "Fayoum", "Gharbia", "Giza", "Ismailia", "KafrElSheikh", "Luxor",
    "Matruh", "Minya", "Monufia", "NewValley", "NorthSinai", "PortSaid", "Qalyubia",
    "Qena", "RedSea", "Sharqia", "Sohag", "SouthSinai", "Suez"
  ];

  String selectedGovernorate = 'Cairo';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          dropdownColor: myWhiteColor,
          menuWidth: MediaQuery.of(context).size.width * 0.30,
          elevation: 2,
          borderRadius: BorderRadius.circular(25.r),
          value: selectedGovernorate,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: bottomColor,
          ),
          underline: const SizedBox(),
          items: governorates.map((String governorate) {
            return DropdownMenuItem<String>(
              value: governorate,
              child: Text(
                governorate,
                style: TextStyle(
                  color: bottomColor,
                  fontSize: 12.sp,
                  fontFamily: medium,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedGovernorate = newValue!;
            });
            widget.onGovernorateChanged(newValue!); // Notify parent widget
          },
        ),
      ],
    );
  }
}