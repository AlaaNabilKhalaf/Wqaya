import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/symptom_container.dart';

class SymOrMedSearch extends StatelessWidget {
  final bool isSym ;
  const SymOrMedSearch({
    super.key, required this.isSym,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RegularText(
                  text: isSym?"symptoms":"medicine",
                  fontSize: 20.sp,
                  textColor: primaryColor,
                  fontFamily: semiBold,
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: unselectedContainerColor
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                          keyboardType: TextInputType.multiline,
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          maxLines: null,
                          decoration:  InputDecoration(
                              fillColor: Colors.red,
                              border: InputBorder.none,
                              label: RegularText(
                                text: isSym?"symptomSearch":"medicineSearch",
                                fontSize: 13.sp,
                                textColor: unselectedContainerColor,
                                fontFamily: bold,
                              ),
                              icon: const PlatformAdaptiveIcon(
                                cupertinoIcon: Icons.search,
                                materialIcon: Icons.search,
                                color: unselectedContainerColor,
                              )
                          )
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: myWhiteColor,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 10,),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemBuilder: (context, index) => const SymptomContainer(),
                itemCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
