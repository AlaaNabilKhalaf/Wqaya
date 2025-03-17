import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/utils/assets_data.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Chat/Presentation/Views/active_chat_view.dart';

import '../../../../Core/Utils/colors.dart';

class ChatWelcomeViewBody extends StatefulWidget {
  const ChatWelcomeViewBody({super.key});

  @override
  State<ChatWelcomeViewBody> createState() => _ChatWelcomeViewBodyState();
}

class _ChatWelcomeViewBodyState extends State<ChatWelcomeViewBody> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 0, end: -350).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _startChat() {
    _controller.forward().then((_) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const ActiveChatView(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Image.asset(AssetsData.chatMainIcon, height: 200.sp),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: RegularTextWithLocalization(
                text: 'howCanIHelpYou',
                fontSize: 30.sp,
                textColor: primaryColor,
                fontFamily: light,
              ),
            ),
            const Spacer(),
            RegularButton(
              height: 55.sp,
              buttonColor: const Color(0xff7EB8FF),
              borderRadius: 20,
              onTap: _startChat,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RegularTextWithLocalization(
                      text: 'askMe',
                      fontSize: 20,
                      textColor: myWhiteColor,
                      fontFamily: semiBold,
                    ),
                    Icon(Icons.send, color: myWhiteColor),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
