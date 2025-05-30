// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wqaya/Core/utils/colors.dart';
// import 'package:wqaya/Core/utils/constance.dart';
// import 'package:wqaya/Core/utils/fonts.dart';
// import 'package:wqaya/Core/widgets/custom_home_app_bar.dart';
// import 'package:wqaya/Core/widgets/texts.dart';
// import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';
// import 'package:wqaya/Features/Complaints/Presentation/Widgets/custom_slider.dart';
// import 'package:wqaya/Features/Complaints/Presentation/Widgets/sym_or_med_search.dart';
//
// class NewComplaintView extends StatefulWidget {
//   const NewComplaintView({super.key});
//
//   @override
//   State<NewComplaintView> createState() => _ComplaintsViewState();
// }
//
// class _ComplaintsViewState extends State<NewComplaintView> {
//   final List<String> durations=[
//     "dayToWeek",
//     "weekToTwoWeeks",
//     "twoWeeksToMonth",
//     "monthToMore",
//   ];
//   int index=0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: myWhiteColor,
//       appBar: const PreferredSize(
//           preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             RegularTextWithLocalization(
//               text: "newComplain",
//               fontSize: 20.sp,
//               textColor: primaryColor,
//               fontFamily: bold,
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             RegularTextWithLocalization(
//               text: "complainReason",
//               fontSize: 20.sp,
//               textColor: primaryColor,
//               fontFamily: medium,
//             ),
//             Flexible(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: textFieldColor,
//                                   borderRadius: BorderRadius.circular(15),
//                                   border: Border.all(
//                                       color: unselectedContainerColor)),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: TextField(
//                                     keyboardType: TextInputType.multiline,
//                                     onTapOutside: (event) => FocusManager
//                                         .instance.primaryFocus
//                                         ?.unfocus(),
//                                     maxLines: null,
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.red,
//                                       border: InputBorder.none,
//                                       label: RegularTextWithLocalization(
//                                         text: "enterReason",
//                                         fontSize: 10.sp,
//                                         textColor: unselectedContainerColor,
//                                         fontFamily: bold,
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SymOrMedSearch(isSym: true,),
//             const SymOrMedSearch(isSym: false,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 RegularTextWithLocalization(
//                   text: "painScale",
//                   fontSize: 20.sp,
//                   textColor: primaryColor,
//                   fontFamily: medium,
//                 ),
//                 const SizedBox(width: 10,),
//                 Column(
//                   children: [
//                     SizedBox(height: 10.h,),
//                     const CustomSlider(),
//                   ],
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 RegularTextWithLocalization(
//                   text: "painScale",
//                   fontSize: 20.sp,
//                   textColor: primaryColor,
//                   fontFamily: medium,
//                 ),
//                 const Spacer(),
//                 Column(
//                   children: [
//                     SizedBox(height: 10.h,),
//                     InkWell(
//                       radius: 15,
//                       onTap: () {
//                         if(index==3){
//                           index = 0;
//                         }else {
//                           index++;
//                         }
//                         setState(() {
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         decoration: BoxDecoration(
//                             color: textFieldColor,
//                             borderRadius: BorderRadius.circular(15),
//                             border: Border.all(
//                                 color: unselectedContainerColor)),
//                         child: Row(
//                           children: [
//                             RegularTextWithLocalization(
//                               text: durations[index],
//                               fontSize: 20.sp,
//                               textColor: primaryColor,
//                               fontFamily: medium,
//                             ),
//                             Transform.rotate(
//                               angle: 1.5708,
//                               child : const PlatformAdaptiveIcon(
//                                 cupertinoIcon: Icons.switch_left, materialIcon: Icons.switch_left,
//                                 color: primaryColor,
//                               ),
//                             )
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//
//               ],
//             ),
//             Row(
//               children: [
//                 Flexible(
//                   child: ComplaintsButton(
//                     text: "save",
//                     fontFamily: bold,
//                     textColor: primaryColor,
//                     borderColor: unselectedContainerColor,
//                     buttonColor: textFieldColor,
//                     fontSize: 20.sp,
//                     onTap:(){
//                    debugPrint("Save");
//                     } ,
//                   ),
//                 ),
//                 Flexible(
//                   child: ComplaintsButton(
//                     text: "anotherComplaint",
//                     fontFamily: bold,
//                     textColor: primaryColor,
//                     borderColor: unselectedContainerColor,
//                     buttonColor: textFieldColor,
//                     fontSize: 20.sp,
//                     onTap:(){
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => const NewComplaintView(),));
//                     } ,
//                   ),
//                 ),
//               ],
//             ),
//             ComplaintsButton(
//               text: "pastComplaints",
//               fontFamily: bold,
//               textColor: primaryColor,
//               borderColor: unselectedContainerColor,
//               buttonColor: textFieldColor,
//               fontSize: 20.sp,
//               onTap:(){
//               } ,
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
