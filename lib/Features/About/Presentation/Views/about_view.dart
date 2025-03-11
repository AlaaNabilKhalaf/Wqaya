import 'package:flutter/material.dart';
import 'package:wqaya/Core/Utils/colors.dart';

import '../../../../Core/widgets/custom_app_bar.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),

    );
  }
}
