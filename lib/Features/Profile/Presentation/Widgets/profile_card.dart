import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  required this.cardAction,
    required this.onTap,
    this.cardColor,
    this.textColor
  });
final String cardAction;
  final Function onTap;
  final Color? cardColor ;
  final Color? textColor ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h,),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
            borderRadius: BorderRadius.circular(15.r)
        ),
        child: RegularButton(buttonColor: cardColor??textFormBackgroundColor, borderRadius: 20.r, height: 55.h,borderWidth:1,borderColor: primaryColor,
            onTap: (){
          onTap();
        }, child:
            RegularTextWithLocalization(text: cardAction, fontSize: 16.sp, textColor: textColor??primaryColor, fontFamily: bold)),
      ),
    );
  }
}
