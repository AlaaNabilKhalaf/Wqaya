import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/about_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';


class HomeCustomAppBar extends StatelessWidget {
  const HomeCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: myWhiteColor,
      leading: const Padding(
        padding: EdgeInsets.only(right: 8.0,top: 5),
        child: CircleAvatar(
          radius: 35,
          foregroundImage: AssetImage(AssetsData.profilePicture),
        ),
      ),
      title:  Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegularText(
                text: 'name',
                fontSize: 15.sp,
                textColor: primaryColor,
                fontFamily: black,
              ),
              const SizedBox(height: 2,),
              RegularText(
                text: 'address',
                fontSize: 13.sp,
                textColor: primaryColor,
                fontFamily: regular,
              ),
            ],
          ),
        const Spacer(),
      const AboutButton()
        ],
      ),
    );
  }
}
