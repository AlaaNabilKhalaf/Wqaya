import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../Widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight(30.h),
            child: const CustomAppBar()),
        body: const LoginViewBody()
    );
  }
}
