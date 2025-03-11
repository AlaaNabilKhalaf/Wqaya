import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/symptoms_container.dart';
import 'package:wqaya/Features/NavBar/Presentation/Views/nav_bar_view.dart';

import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class ChronicDiseasesView extends StatefulWidget {
  const ChronicDiseasesView({super.key});

  @override
  State<ChronicDiseasesView> createState() => _ChronicDiseasesViewState();
}

class _ChronicDiseasesViewState extends State<ChronicDiseasesView> {
  List<String> chronicDiseases = [
    "داء السكري",
    "ارتفاع ضغط الدم",
    "أمراض القلب والأوعية الدموية",
    "الربو المزمن",
    "التهاب المفاصل الروماتويدي",
    "قصور الغدة الدرقية",
    "فرط نشاط الغدة الدرقية",
    "أمراض الكلى المزمنة",
    "أمراض الكبد المزمنة",
    "التصلب المتعدد",
    "مرض باركنسون",
    "مرض الزهايمر",
    "الصداع النصفي المزمن",
    "الذئبة الحمراء",
    "الصدفية",
    "التهاب القولون التقرحي",
    "متلازمة القولون العصبي",
    "مرض كرون",
    "فقر الدم المنجلي",
    "الثلاسيميا",
    "هشاشة العظام",
    "داء النقرس",
    "التليف الكيسي",
    "الأكزيما المزمنة",
    "اضطراب ثنائي القطب",
    "الاكتئاب المزمن",
    "القلق المزمن",
    "اضطراب نقص الانتباه وفرط النشاط (ADHD)",
    "مرض اعتلال الشبكية السكري",
    "فشل القلب المزمن",
  ];

  Set<int> selectedDiseases = {}; // Track selected symptoms

  void toggleSymptomSelection(int index) {
    setState(() {
      if (selectedDiseases.contains(index)) {
        selectedDiseases.remove(index);
      } else {
        selectedDiseases.add(index);
      }
    });
  }
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  CustomAlert(
          nextText: 'goToHome',
          nextScreenFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const NavBarView()));
        },

          confirmText: 'dataConfirmed',);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),

      body: Column(
        children: [
          Center(
            child: RegularText(
              text: 'chronicDiseases',
              fontSize: 20.sp,
              textColor: primaryColor,
              fontFamily: black,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  AlignedGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chronicDiseases.length,
                    itemBuilder: (context, index) =>
                        SymptomsContainer(text: chronicDiseases[index],
                          onSelected: () => toggleSymptomSelection(index),),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RegularButton(
              width: double.infinity,
              height: 50.h,
              buttonColor: selectedDiseases.isEmpty
                  ? unselectedContainerColor
                  : primaryColor,
              borderRadius: 10,
              onTap: () {
                if (selectedDiseases.isNotEmpty) {
                  _showSuccessDialog(context);
                }
              },
              child: RegularText(
                text: 'goToHome',
                fontSize: 15.sp,
                fontFamily: black,
                textColor: myWhiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
