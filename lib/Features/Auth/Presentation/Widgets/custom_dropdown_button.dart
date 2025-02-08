import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}



class _CustomDropdownButtonState extends State<CustomDropdownButton> {
// List of governments
final List<String> governments = [
'الغريبة',
'القاهرة',
'الإسكندرية',
'أسوان',
'المنصورة',
];

// Selected government
String selectedGovernment = 'الغريبة';

@override
Widget build(BuildContext context) {
return Row(
mainAxisSize: MainAxisSize.min,
children: [
DropdownButton<String>(
dropdownColor: myWhiteColor,
menuWidth: MediaQuery.of(context).size.width*0.27,
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
