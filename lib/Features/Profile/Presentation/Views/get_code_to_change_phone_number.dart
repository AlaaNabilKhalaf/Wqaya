import 'package:flutter/material.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../Widgets/get_code_body.dart';

class GetCodeToChangePhoneNumber extends StatelessWidget {
  final String phone;

  const GetCodeToChangePhoneNumber({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: GetCodeBody(phone: phone),
    );
  }
}
