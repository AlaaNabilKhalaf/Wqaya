import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';

import 'about_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.title, this.leading, this.actions});
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 59.w,
      elevation: 0,
      backgroundColor: myWhiteColor,
      forceMaterialTransparency: true,
      title: Text(
        title ?? "",
),
      leading: leading ??
          const AboutButton(),

      actions: actions ??
          [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  // size: 20,
                  Icons.arrow_forward_rounded,
                  color: primaryColor,
                )),
          ],
      centerTitle: true,
    );
  }
}





