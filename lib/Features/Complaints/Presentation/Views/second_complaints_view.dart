import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/contagious_disease_view.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaint_container.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/pain_widgets.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/search_complaint_section.dart';

import '../../../../Core/widgets/custom_home_app_bar.dart';


class SecondComplaintsView extends StatefulWidget {
  const SecondComplaintsView({super.key});

  @override
  State<SecondComplaintsView> createState() => _FirstComplaintsViewState();
}

class _FirstComplaintsViewState extends State<SecondComplaintsView> {

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
            const PainWidgets(),
            const SizedBox(height: 40,),
            RegularText(
              text: "foodSensitivity",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: medium,
            ),
            SearchComplaintSection(text: "foodSensitivity".tr(), searchText: "searchForFood".tr()),
            const SizedBox(height: 10,),
             const Flexible(child: ComplaintContainer(mainText: "addFood", containerText: "enterFood")),
            Row(
              children: [
                Expanded(
                  child: ComplaintsButton(
                    text: "next",
                    fontFamily: bold,
                    textColor: primaryColor,
                    borderColor: unselectedContainerColor,
                    buttonColor: textFieldColor,
                    fontSize: 20.sp,
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ContagiousDiseaseView(),));
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

