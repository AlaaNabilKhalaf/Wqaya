// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wqaya/Core/Utils/colors.dart';
// import 'package:wqaya/Core/Utils/fonts.dart';
// import 'package:wqaya/Features/Complaints/Presentation/Views/new_complaint_view.dart';
// import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';
//
// class ButtonCollection extends StatelessWidget {
//   const ButtonCollection({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Flexible(
//               child: ComplaintsButton(
//                 text: "save",
//                 fontFamily: bold,
//                 textColor: primaryColor,
//                 borderColor: unselectedContainerColor,
//                 buttonColor: textFieldColor,
//                 fontSize: 20.sp,
//                 onTap:(){
//                 debugPrint("Save");
//                 } ,
//               ),
//             ),
//             Flexible(
//               child: ComplaintsButton(
//                 text: "anotherComplaint",
//                 fontFamily: bold,
//                 textColor: primaryColor,
//                 borderColor: unselectedContainerColor,
//                 buttonColor: textFieldColor,
//                 fontSize: 20.sp,
//                 onTap:(){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const NewComplaintView(),));
//                 } ,
//               ),
//             ),
//           ],
//         ),
//         ComplaintsButton(
//           text: "pastComplaints",
//           fontFamily: bold,
//           textColor: primaryColor,
//           borderColor: unselectedContainerColor,
//           buttonColor: textFieldColor,
//           fontSize: 20.sp,
//           onTap:(){
//           } ,
//         ),
//       ],
//     );
//   }
// }
