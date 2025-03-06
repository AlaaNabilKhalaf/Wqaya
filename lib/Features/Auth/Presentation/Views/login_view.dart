import 'package:flutter/material.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../Widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return    const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar()),
        body: LoginViewBody()
    );
  }
}
