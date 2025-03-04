import 'package:flutter/material.dart';
import 'package:wqaya/Features/Profile/Presentation/Widgets/profile_view_body.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/cust_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
      body: ProfileViewBody(),

    );

  }
}
