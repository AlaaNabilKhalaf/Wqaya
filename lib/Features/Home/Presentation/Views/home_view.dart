import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/first_complaints_view.dart';
import 'package:wqaya/Features/Home/Presentation/Views/x_ray_view.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/better_health_poster.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/home_container.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/symptom_container.dart';

import '../../../../Core/widgets/custom_home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> homeContainerItems = {
      "analysis": AssetsData.analysisPicture2,
      "xray": AssetsData.xrayPicture,
      "medicine": AssetsData.medicineBottle,
      "surgery": AssetsData.surgeryPicture,
    };

    final List<MapEntry<String, String>> itemsList = homeContainerItems.entries.toList();

    return  Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(preferredSize:Size.fromHeight(kToolbarHeight),
          child: HomeCustomAppBar()),
      body:  Padding(
          padding:  const EdgeInsets.all(8.0),
          child:
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200.h,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const XRayScreen() ,)),
                      child: HomeContainer(
                        text: itemsList[index].key,
                        image: itemsList[index].value,
                      ),
                    ),
                    itemCount: 4,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    BetterHealthPoster(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RegularTextWithLocalization(
                      text: 'currentComplain',
                      fontSize: 20.sp,
                      textColor: primaryColor,
                      fontFamily: bold,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RegularTextWithLocalization(
                      text: "complainReason",
                      fontSize: 20.sp,
                      textColor: primaryColor,
                      fontFamily: medium,
                    ),
                    const Spacer(),
                    RegularTextWithLocalization(
                      text: "symptoms",
                      fontSize: 20.sp,
                      textColor: primaryColor,
                      fontFamily: medium,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SliverFillRemaining(
                fillOverscroll: false,
                hasScrollBody: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: unselectedContainerColor
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      fillColor: Colors.red,
                                      border: InputBorder.none,
                                      label: RegularTextWithLocalization(
                                        text: "enterReason",
                                        fontSize: 10.sp,
                                        textColor: unselectedContainerColor,
                                        fontFamily: bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 250.h,
                        child: Column(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0, right: 5),
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                                  itemBuilder: (context, index) => const SymptomContainer(),
                                  itemCount: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SliverToBoxAdapter(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FirstComplaintsView(),
                    ),
                  ),
                  splashColor: textFieldColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: unselectedContainerColor
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RegularTextWithLocalization(
                          text: "showDetails",
                          fontSize: 20.sp,
                          textColor: primaryColor,
                          fontFamily: bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}



