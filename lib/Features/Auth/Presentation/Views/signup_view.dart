import 'package:flutter/material.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/sign_up_view_body.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),
body: SignUpViewBody(),
    );
  }
}
