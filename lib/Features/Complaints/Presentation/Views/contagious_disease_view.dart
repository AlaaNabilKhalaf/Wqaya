import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/surgeries_view.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaint_container.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/search_complaint_section.dart';

import '../../../../Core/widgets/custom_home_app_bar.dart';


class ContagiousDiseaseView extends StatefulWidget {
  const ContagiousDiseaseView({super.key});

  @override
  State<ContagiousDiseaseView> createState() => _FirstComplaintsViewState();
}

class _FirstComplaintsViewState extends State<ContagiousDiseaseView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegularText(
              text: "contagiousDiseases",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            SearchComplaintSection(text: "contagiousDiseases".tr(), searchText: "searchForContagiousDiseases".tr()),
            const SizedBox(height: 10,),
            const Flexible(child: ComplaintContainer(mainText: "addContagiousDisease", containerText: "enterContagiousDisease")),
            Row(
              children: [
                Expanded(
                  child: ComplaintsButton(
                    text: "cured",
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
                    text: "notCured",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SurgeriesView(),));
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

