import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/xray_view.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaint_container.dart';
import 'package:wqaya/Features/Complaints/Presentation/Widgets/complaints_button.dart';

import '../../../../Core/widgets/custom_home_app_bar.dart';

class SurgeriesView extends StatefulWidget {
  const SurgeriesView({super.key});

  @override
  State<SurgeriesView> createState() => _SurgeriesViewState();
}

class _SurgeriesViewState extends State<SurgeriesView> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomeCustomAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegularText(
              text: "surgery",
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: bold,
            ),
            const Flexible(
              child: ComplaintContainer(
                mainText: "",
                containerText: "surgeryType",
                isMainTextRequired: true,
              ),
            ),
            const SizedBox(height: 10),
            const Flexible(
              child: ComplaintContainer(
                mainText: "",
                containerText: "surgeryReason",
                isMainTextRequired: true,
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: textFieldColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: unselectedContainerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "chooseSurgeryDate"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: bold,
                        color: primaryColor,
                      ),
                    ).tr(),
                    const Icon(Icons.calendar_today, color: primaryColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
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
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ComplaintsButton(
                    text: "next",
                    fontFamily: bold,
                    textColor: primaryColor,
                    borderColor: unselectedContainerColor,
                    buttonColor: textFieldColor,
                    fontSize: 20.sp,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const XrayView(),));
                    },
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

