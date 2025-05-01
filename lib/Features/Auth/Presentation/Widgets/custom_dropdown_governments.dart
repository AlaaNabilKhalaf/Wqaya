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
  final Map<String, String> governoratesMap = {
    "الإسكندرية": "Alexandria",
    "أسوان": "Aswan",
    "أسيوط": "Asyut",
    "البحيرة": "Beheira",
    "بني سويف": "BeniSuef",
    "القاهرة": "Cairo",
    "الدقهلية": "Dakahlia",
    "دمياط": "Damietta",
    "الفيوم": "Fayoum",
    "الغربية": "Gharbia",
    "الجيزة": "Giza",
    "الإسماعيلية": "Ismailia",
    "كفر الشيخ": "KafrElSheikh",
    "الأقصر": "Luxor",
    "مطروح": "Matruh",
    "المنيا": "Minya",
    "المنوفية": "Monufia",
    "الوادي الجديد": "NewValley",
    "شمال سيناء": "NorthSinai",
    "بورسعيد": "PortSaid",
    "القليوبية": "Qalyubia",
    "قنا": "Qena",
    "البحر الأحمر": "RedSea",
    "الشرقية": "Sharqia",
    "سوهاج": "Sohag",
    "جنوب سيناء": "SouthSinai",
    "السويس": "Suez",
  };

  late String selectedArabicName;

  @override
  void initState() {
    super.initState();
    selectedArabicName = governoratesMap.keys.firstWhere((k) => governoratesMap[k] == "Cairo");
  }

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
          value: selectedArabicName,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: bottomColor,
          ),
          underline: const SizedBox(),
          items: governoratesMap.keys.map((String arabicName) {
            return DropdownMenuItem<String>(
              value: arabicName,
              child: Text(
                arabicName,
                style: TextStyle(
                  color: bottomColor,
                  fontSize: 12.sp,
                  fontFamily: medium,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newArabicName) {
            if (newArabicName != null) {
              setState(() {
                selectedArabicName = newArabicName;
              });
              String englishValue = governoratesMap[newArabicName]!;
              widget.onGovernorateChanged(englishValue); // Send English to backend
            }
          },
        ),
      ],
    );
  }
}
