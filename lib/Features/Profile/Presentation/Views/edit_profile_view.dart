import 'package:flutter/material.dart';
import 'package:wqaya/Features/Profile/Presentation/Widgets/edit_profile_body.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), child: CustomAppBar()),
      body: EditProfileBody(),

    );

  }
}
