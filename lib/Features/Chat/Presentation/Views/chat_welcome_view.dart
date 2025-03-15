import 'package:flutter/material.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../../../NavBar/Presentation/Views/nav_bar_view.dart';
import '../Widgets/chat_welcome_view_body.dart';
import 'package:wqaya/Core/utils/colors.dart';


class ChatWelcomeView extends StatelessWidget {
  const ChatWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhiteColor,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(backButtonFunction: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const NavBarView()));
          },)),
      body: const ChatWelcomeViewBody(),
    );
  }
}
