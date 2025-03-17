import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Features/Chat/Presentation/Views/chat_welcome_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_bar_cubit.dart';

import '../../../../Core/utils/assets_data.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;

  const CustomBottomNavBar({
    super.key,
    required this.icons,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Stack(
          clipBehavior: Clip.none, // Allow floating button overflow
          children: [
            ClipPath(
              clipper: CustomNavBarClipper(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                color: primaryColor,
                height: 86.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(icons.length, (index) {
                    if (index == 1) return SizedBox(width: 60.w); // Space for FAB

                    bool isSelected = currentIndex == index;
                    return IconButton(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icons[index],
                            color: isSelected ? Colors.white : Colors.white70,
                            size: isSelected ? 26 : 22,
                          ),
                          Text(
                            labels[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: isSelected ? 16 : 14,
                              fontFamily: bold,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        context.read<BottomNavCubit>().updateIndex(index);
                      },
                    );
                  }),
                ),
              ),
            ),
            // Floating Chatbot Icon
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 35.w,
              bottom: 40.h, // More elevation
              child: GestureDetector(
                onTap: () async {
                  if(context.mounted) {
                    await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ChatWelcomeView()),);
                    context.read<BottomNavCubit>().updateIndex(0); // Return to home on pop
                  }},
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(AssetsData.chatBotIcon),
                  // child: Icon(
                  //   icons[1], // Chatbot icon
                  //   color: currentIndex == 1 ? Colors.white : Colors.white70,
                  //   size: 28,
                  // ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double fabRadius = 35; // Radius of floating button

    Path path = Path();
    path.lineTo(size.width / 2 - fabRadius - 10, 0);
    path.quadraticBezierTo(
        size.width / 2 - fabRadius, 0, size.width / 2 - fabRadius + 5, fabRadius - 10);
    path.arcToPoint(
      Offset(size.width / 2 + fabRadius - 5, fabRadius - 10),
      radius: Radius.circular(fabRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(
        size.width / 2 + fabRadius, 0, size.width / 2 + fabRadius + 10, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
