import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/second_complaints_view.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaint_container.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/sym_or_med_search.dart';

import '../../../../Core/widgets/custom_home_app_bar.dart';


class FirstComplaintsView extends StatefulWidget {
  const FirstComplaintsView({super.key});

  @override
  State<FirstComplaintsView> createState() => _FirstComplaintsViewState();
}

class _FirstComplaintsViewState extends State<FirstComplaintsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Flexible(
              child: ComplaintContainer(
                mainText: "currentComplain",
                containerText: "complainReason",
              ),
            ),
            const SymOrMedSearch(isSym: true,),
            const SymOrMedSearch(isSym: false,),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondComplaintsView(),));
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


