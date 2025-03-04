import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class HomeCustomAppBar extends StatelessWidget {
  const HomeCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: Colors.white,
      leading: const Padding(
        padding: EdgeInsets.only(right: 8.0,top: 5),
        child: CircleAvatar(
          radius: 35,
          foregroundImage: AssetImage(AssetsData.profilePicture),
        ),
      ),
      title:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RegularText(
                text: 'name',
                fontSize: 15.sp,
                textColor: primaryColor,
                fontFamily: black,
              ),
              RegularText(
                text: " 👋 ",
                fontSize: 15.sp,
                textColor: primaryColor,
                fontFamily: black,
              ),
            ],
          ),
          const SizedBox(height: 3,),
          Row(
            children: [
              RegularText(
                text: 'address',
                fontSize: 13.sp,
                textColor: primaryColor,
                fontFamily: regular,
              ),
              const PlatformAdaptiveIcon(cupertinoIcon: Icons.keyboard_arrow_down_sharp, materialIcon: Icons.keyboard_arrow_down_sharp,color: primaryColor,),
              const Spacer(),
              const PlatformAdaptiveIcon(cupertinoIcon: Icons.notifications_none_outlined, materialIcon: Icons.notifications_none_outlined,color: primaryColor,)

            ],
          ),
        ],
      ),
    );
  }
}
