import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Home/Presentation/Views/chronic_diseases_view.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/home_cubit.dart';
import 'package:wqaya/Features/Home/Presentation/Widgets/symptoms_container.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class SymptomsSufferedView extends StatefulWidget {
  const SymptomsSufferedView({super.key});

  @override
  State<SymptomsSufferedView> createState() => _SymptomsSufferedViewState();
}

class _SymptomsSufferedViewState extends State<SymptomsSufferedView> {
  final Map<int, int> selectedSymptomCategoryMap =
      {}; // symptomId -> categoryId

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchSymptomCategories(); // Call Cubit method
  }

  void toggleSymptomSelection(int symptomId, int categoryId) {
    setState(() {
      if (selectedSymptomCategoryMap.containsKey(symptomId)) {
        selectedSymptomCategoryMap.remove(symptomId);
      } else {
        selectedSymptomCategoryMap[symptomId] = categoryId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var hCubit = context.read<HomeCubit>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SizedBox(
            height: kToolbarHeight,
          ),
        ),
        body: Column(
          children: [
            Center(
              child: RegularTextWithLocalization(
                text: 'symptomsSuffer',
                fontSize: 20.sp,
                textColor: primaryColor,
                fontFamily: black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is SymptomLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: primaryColor,
                    ));
                  } else if (state is SymptomLoaded) {
                    final categories = state.categories;
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            for (var category in categories) ...[
                              if (category.symptoms.isNotEmpty) ...[
                                Text(
                                  category.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: black),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AlignedGridView.count(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: category.symptoms.length,
                                  itemBuilder: (context, index) {
                                    final symptom = category.symptoms[index];
                                    return SymptomsContainer(
                                      text: symptom.name,
                                      isSelected: selectedSymptomCategoryMap
                                          .containsKey(symptom.id),
                                      onSelected: () => toggleSymptomSelection(
                                          symptom.id, category.id),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ],
                        ),
                      ),
                    );
                  } else if (state is SymptomError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is SubmitUserSymptomsSuccessfulState ){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>const ChronicDiseasesView() ,));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RegularButton(
                  width: double.infinity,
                  height: 50.h,
                  buttonColor: selectedSymptomCategoryMap.isEmpty
                      ? unselectedContainerColor
                      : primaryColor,
                  borderRadius: 10,
                  onTap: () async {
                    if (selectedSymptomCategoryMap.isNotEmpty) {

                      await hCubit.submitUserSymptoms(
                          symptomIds: selectedSymptomCategoryMap.keys.toList());
                      print(selectedSymptomCategoryMap.keys
                          .toList()); // {symptomId: categoryId}
                    }
                  },
                  child: RegularTextWithLocalization(
                    text: "next",
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
