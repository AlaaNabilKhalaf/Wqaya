import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/symptom_container.dart';

class SearchComplaintSection extends StatelessWidget {
  final String text,searchText ;
  const SearchComplaintSection({super.key, required this.text, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

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
                                text: searchText,
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
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                childAspectRatio: 4,
              ),
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemBuilder: (context, index) => const SymptomContainer(),
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
