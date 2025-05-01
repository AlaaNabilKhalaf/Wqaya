import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/utils/assets_data.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/following_up_form_fields.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../Widgets/social_login_widget.dart';

class FollowingUpView extends StatelessWidget {
  const FollowingUpView({super.key});
 @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar()),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            //Text
            Column(
              children: [
                RegularTextWithLocalization(text:'followingUp', fontSize: 40.sp, textColor: primaryColor, fontFamily: bold),
                //Dots Image
                Padding(
                  padding:  EdgeInsets.only(top: 30.h, bottom: 10.h),
                  child: SizedBox(
                      height: 8.h,width: 36.w,
                      child: Image.asset(AssetsData.dots)),
                ),
              ],
            ),
            //Text Form Fields
                      Expanded(child: const FollowingUpFormFields()),
          ],
          ),
        ),
      ),
    );
  }
}
