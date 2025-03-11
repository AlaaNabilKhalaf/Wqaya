import 'package:flutter/material.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/get_code_reset_body.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class GetCodeToResetPassword extends StatelessWidget {
  const GetCodeToResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: myWhiteColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar()),
        body: GetCodeResetBody()
    );
  }

}
