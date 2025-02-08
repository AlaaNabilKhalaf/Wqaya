import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/get_code_body.dart';

import '../../../../Core/widgets/custom_app_bar.dart';
class GetCodeView extends StatelessWidget {
  const GetCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(30.h),
          child: const CustomAppBar()),
      body: const GetCodeBody()
    );
  }
}
