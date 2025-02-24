import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/cust_app_bar.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaint_container.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';

class SurgriesView extends StatelessWidget {
  const SurgriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), child: CustAppBar()),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegularText(
              text: "surgery",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            const Flexible(child: ComplaintContainer(mainText: "addSurgery", containerText: "")),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: ComplaintsButton(
                    text: "skip",
                    fontFamily: bold,
                    textColor: primaryColor,
                    borderColor: unselectedContainerColor,
                    buttonColor: textFieldColor,
                    fontSize: 20.sp,
                    onTap:(){
                    } ,
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: ComplaintsButton(
                    text: "next",
                    fontFamily: bold,
                    textColor: primaryColor,
                    borderColor: unselectedContainerColor,
                    buttonColor: textFieldColor,
                    fontSize: 20.sp,
                    onTap:(){
                    } ,
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
