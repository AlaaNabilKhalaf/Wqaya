import 'package:flutter/material.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/get_code_sign_in_body.dart';

import '../../../../Core/widgets/custom_app_bar.dart';
class GetCodeToSignIn extends StatelessWidget {
  const GetCodeToSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),
      body: GetCodeSignInBody()
    );
  }
}
