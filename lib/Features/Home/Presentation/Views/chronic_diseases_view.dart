import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/home_cubit.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/symptoms_container.dart';
import 'package:wqaya/Features/NavBar/Presentation/Views/nav_bar_view.dart';

import '../../../../Core/widgets/custom_ alert.dart';

class ChronicDiseasesView extends StatefulWidget {
  const ChronicDiseasesView({super.key});

  @override
  State<ChronicDiseasesView> createState() => _ChronicDiseasesViewState();
}

class _ChronicDiseasesViewState extends State<ChronicDiseasesView> {
  // List<String> chronicDiseases = [
  //   "داء السكري",
  //   "ارتفاع ضغط الدم",
  //   "أمراض القلب والأوعية الدموية",
  //   "الربو المزمن",
  //   "التهاب المفاصل الروماتويدي",
  //   "قصور الغدة الدرقية",
  //   "فرط نشاط الغدة الدرقية",
  //   "أمراض الكلى المزمنة",
  //   "أمراض الكبد المزمنة",
  //   "التصلب المتعدد",
  //   "مرض باركنسون",
  //   "مرض الزهايمر",
  //   "الصداع النصفي المزمن",
  //   "الذئبة الحمراء",
  //   "الصدفية",
  //   "التهاب القولون التقرحي",
  //   "متلازمة القولون العصبي",
  //   "مرض كرون",
  //   "فقر الدم المنجلي",
  //   "الثلاسيميا",
  //   "هشاشة العظام",
  //   "داء النقرس",
  //   "التليف الكيسي",
  //   "الأكزيما المزمنة",
  //   "اضطراب ثنائي القطب",
  //   "الاكتئاب المزمن",
  //   "القلق المزمن",
  //   "اضطراب نقص الانتباه وفرط النشاط (ADHD)",
  //   "مرض اعتلال الشبكية السكري",
  //   "فشل القلب المزمن",
  // ];

  Set<int> selectedDiseases = {};

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchChronicDiseases(); // Call Cubit method
  }

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
        return CustomAlert(
          nextText: 'goToHome',
          nextScreenFunction: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NavBarView()));
          },
          confirmText: 'dataConfirmed',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SizedBox(
              height: kToolbarHeight,
            )),
        body: Column(
          children: [
            Center(
              child: RegularTextWithLocalization(
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
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        var hCubit = context.read<HomeCubit>();
                        if (state is SymptomLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        List<dynamic> diseases = [];

                        if (state is ChronicDiseasesLoaded) {
                          diseases = state.diseases;
                          hCubit.cachedDiseases.clear();
                          hCubit.cachedDiseases=state.diseases;
                        } else if (state is SubmitUserDiseasesLoadingState) {
                          diseases = hCubit.cachedDiseases;
                        }

                        if (diseases.isNotEmpty) {
                          return AlignedGridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: diseases.length,
                            itemBuilder: (context, index) => SymptomsContainer(
                              text: diseases[index].name,
                              isSelected: selectedDiseases.contains(diseases[index].id),
                              onSelected: () =>
                                  toggleSymptomSelection(diseases[index].id),
                            ),
                          );
                        } else {
                          return const Center(child: Text('Error loading diseases'));
                        }
                      },
                    )                  ],
                ),
              ),
            ),
            BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is SubmitUserDiseasesSuccessfulState){
                   _showSuccessDialog(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RegularButton(
                  width: double.infinity,
                  height: 50.h,
                  buttonColor: selectedDiseases.isEmpty
                      ? unselectedContainerColor
                      : primaryColor,
                  borderRadius: 10,
                  onTap: () {
                    context.read<HomeCubit>().submitUserDiseases(diseaseIds: selectedDiseases.toList());
                  },
                  child: RegularTextWithLocalization(
                    text: 'goToHome',
                    fontSize: 15.sp,
                    fontFamily: black,
                    textColor: myWhiteColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
