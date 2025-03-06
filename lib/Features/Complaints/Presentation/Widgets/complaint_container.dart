import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class ComplaintContainer extends StatefulWidget {
  final String mainText , containerText ;

   const ComplaintContainer({
    super.key, required this.mainText, required this.containerText,isMainTextRequired
  });

  @override
  State<ComplaintContainer> createState() => _ComplaintContainerState();
}

class _ComplaintContainerState extends State<ComplaintContainer> {
  bool isMainTextRequired = false ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMainTextRequired==true ?RegularText(
          text: widget.mainText,
          fontSize: 20.sp,
          textColor: primaryColor,
          fontFamily: bold,
        ):const SizedBox(),
         SizedBox(
          height: isMainTextRequired==false ? 0 : 15,
        ),
        RegularText(
          text: widget.containerText,
          fontSize: 20.sp,
          textColor: primaryColor,
          fontFamily: medium,
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
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
                                  color: unselectedContainerColor)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextField(
                                keyboardType: TextInputType.multiline,
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: Colors.red,
                                  border: InputBorder.none,
                                  label: RegularText(
                                    text: "enterReason",
                                    fontSize: 10.sp,
                                    textColor: unselectedContainerColor,
                                    fontFamily: bold,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
