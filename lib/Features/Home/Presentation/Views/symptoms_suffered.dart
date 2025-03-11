import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Home/Presentation/Views/chronic_diseases_view.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/symptoms_container.dart';

import '../../../../Core/widgets/custom_app_bar.dart' ;

class SymptomsSufferedView extends StatefulWidget {
  const SymptomsSufferedView({super.key});

  @override
  State<SymptomsSufferedView> createState() => _SymptomsSufferedViewState();
}

class _SymptomsSufferedViewState extends State<SymptomsSufferedView> {
  List<String> symptoms = [
    "شعور بالرغبة في التقيؤ",
    "إرتفاع درجة حرارة الجسم",
    "ألم أو توهج في الحلق",
    "ألم العضلات أو المفاصل",
    "التعرق المفرط أثناء النوم",
    "حكة مستمرة أو مؤلمة",
    "الشعور بعدم التوازن أو دوران الرأس",
    "تكرار حركة الأمعاء مع براز رخو أو مائي",
    "إدراج محتويات المعدة عبر الفم",
    "صعوبة في البلع أو قلة مرات الإخراج",
    "ألم أو انزعاج في منطقة المعدة",
    "انسداد أو صعوبة في التنفس عبر الأنف",
    "فقدان الطاقة والشعور بالإجهاد",
    "ارتفاع الجسم بسبب البرد أو الحمى",
    "التهاب الجبين أو الفك السفلي",
    "شعور بالرغبة في التقيؤ",
    "إرتفاع درجة حرارة الجسم",
    "ألم أو توهج في الحلق",
    "ألم العضلات أو المفاصل",
    "التعرق المفرط أثناء النوم",
    "حكة مستمرة أو مؤلمة",
    "الشعور بعدم التوازن أو دوران الرأس",
    "تكرار حركة الأمعاء مع براز رخو أو مائي",
    "إدراج محتويات المعدة عبر الفم",
    "صعوبة في البلع أو قلة مرات الإخراج",
    "ألم أو انزعاج في منطقة المعدة",
    "انسداد أو صعوبة في التنفس عبر الأنف",
    "فقدان الطاقة والشعور بالإجهاد",
    "ارتفاع الجسم بسبب البرد أو الحمى",
    "التهاب الجبين أو الفك السفلي",
  ];
  bool isSymptomPressed = false;

  Set<int> selectedSymptoms = {}; // Track selected symptoms

  void toggleSymptomSelection(int index) {
    setState(() {
      if (selectedSymptoms.contains(index)) {
        selectedSymptoms.remove(index);
      } else {
        selectedSymptoms.add(index);
      }
    });
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
              text: "symptomsSuffer",
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
                    itemCount: symptoms.length,
                    itemBuilder: (context, index) =>
                        SymptomsContainer(text: symptoms[index], onSelected: () => toggleSymptomSelection(index),),
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
              buttonColor: selectedSymptoms.isEmpty?unselectedContainerColor : primaryColor,
              borderRadius: 10,
              onTap: () {
                if (selectedSymptoms.isNotEmpty){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChronicDiseasesView(),));
                }
              },
              child: RegularText(
                text: "next",
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
