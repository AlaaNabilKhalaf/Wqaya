import 'package:flutter/material.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import 'package:wqaya/Core/utils/colors.dart';

import '../Widgets/active_chat_view_body.dart';


class ActiveChatView extends StatelessWidget {
  const ActiveChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),
      body: ActiveChatViewBody(),
    );
  }
}
