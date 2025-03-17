import 'package:flutter/material.dart';
import 'package:wqaya/Features/Profile/Presentation/Widgets/exist_view_body.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class ExistView extends StatelessWidget {
  const ExistView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), child: CustomAppBar()),
      body: ExistViewBody(),

    );

}}
