//
// import 'package:flutter/material.dart';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// class MyDropDownBottom extends StatefulWidget {
//   const MyDropDownBottom({super.key});
//   @override
//   State<MyDropDownBottom> createState() => _MyDropDownBottomState();
// }
//
// class _MyDropDownBottomState extends State<MyDropDownBottom> {
//   bool changerColor = false;
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Center(
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2<String>(
//           onMenuStateChange: (c) {
//             changerColor = c;
//             setState(() {});
//           },
//           selectedItemBuilder: (context) {
//             return items.map(
//               (item) {
//                 return Container(
//                   alignment: AlignmentDirectional.center,
//                   child: Text(
//                    '',
//                     style: const TextStyle(
//                       color: ,
//                       fontSize: 14,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     maxLines: 1,
//                   ),
//                 );
//               },
//             ).toList();
//           },
//           style: TextStyle(
//               fontFamily: arBold, fontSize: 14.sp, color: myBlackColor),
//           isExpanded: false,
//           hint: Row(
//             children: [
//               RegularText(
//                   text: selectedValue?.title ?? lang.chooseTheStatistics,
//                   //text: selectedValue?.title ?? lang.chooseTheStatistics,
//               textStyle: TextStyle(
//                   color: selectedValue?.title != null
//                       ?
//                   context.watch<ThemeCubit>().themeMode == ThemeMode.light ?
//                   myWhiteColor : myBlackColor
//                       : bottomNavIconsColor,
//                   fontFamily: arBold,
//                   fontSize: 14.sp
//               ),
//               )
//             ],
//           ),
//           items: items
//               .map((EnumModels item) => DropdownMenuItem<EnumModels>(
//                     value: item,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: Text(
//                             item.title,
//                             style:  TextStyle(
//                               fontSize: 14,
//                               fontFamily: arBold,
//                               color:
//                               context.watch<ThemeCubit>().themeMode == ThemeMode.light ?
//                               myBlackColor :
//                               myWhiteColor,
//
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (items.indexOf(item) != items.length - 1)
//                            Divider(
// color:
// context.watch<ThemeCubit>().themeMode == ThemeMode.light ?
// myBlackColor :
// myWhiteColor,
//
//                           ),
//                       ],
//                     ),
//                   ))
//               .toList(),
//           value: selectedValue,
//           onChanged: (EnumModels? value) {
//             setState(() {
//               selectedValue = value;
//               context
//                   .read<StatisticsFilterCubit>()
//                   .changeFilterType(value?.typeFilter);
//             });
//             //log('selected item ${context.read<StatisticsFilterCubit>().selectedFilter.toString()}');
//           },
//           buttonStyleData: ButtonStyleData(
//             height: 50.h,
//             width: double.infinity,
//             padding: const EdgeInsets.only(left: 14, right: 14),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.r),
//               border: Border.all(
//                 color: grayColor,
//               ),
//               color: selectedValue == null ? Colors.transparent : kPrimeColor,
//             ),
//           ),
//           iconStyleData: selectedValue != null
//               ? IconStyleData(
//                   icon: RotatedBox(
//                     quarterTurns: changerColor == false ? 1 : 3,
//                     child: const Icon(
//                       Icons.arrow_back_ios,
//                     ),
//                   ),
//                   iconSize: 22,
//                   iconEnabledColor: Colors.white,
//                 )
//               : IconStyleData(
//                   icon: RotatedBox(
//                     quarterTurns: changerColor == false ? 1 : 3,
//                     child: const Icon(
//                       Icons.arrow_back_ios,
//                     ),
//                   ),
//                   iconSize: 22,
//                   iconEnabledColor: kPrimeColor,
//                 ),
//           dropdownStyleData: DropdownStyleData(
//             elevation: 0,
//             maxHeight: 250.h,
//             scrollPadding: EdgeInsets.symmetric(
//               vertical: 10.h,
//             ),
//             isOverButton: false,
//             //   width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.r),
//               border: Border.all(
//                 color: grayColor,
//               ),
//               color:
//               context.watch<ThemeCubit>().themeMode == ThemeMode.light ?
//               myWhiteColor :
//               bottomNavDarkThemeColor,
//             ),
//             scrollbarTheme: ScrollbarThemeData(
//               radius: Radius.circular(40.r),
//             ),
//           ),
//           menuItemStyleData: MenuItemStyleData(
//             overlayColor: const MaterialStatePropertyAll(Colors.transparent),
//             height: 40.h,
//             // overlayColor: const MaterialStatePropertyAll(myBlackColor),
//             padding: EdgeInsets.only(left: 14.w, right: 14.w),
//           ),
//         ),
//       ),
//     );
//   }
// }
