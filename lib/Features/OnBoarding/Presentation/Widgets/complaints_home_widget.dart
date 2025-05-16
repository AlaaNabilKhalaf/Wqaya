import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Complaints/Presentation/Views/complaints_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_visibility__cubit.dart';

class ComplaintsHomeWidget extends StatelessWidget {
  const ComplaintsHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<BottomNavVisibilityCubit>().hide();
        Navigator.of(context)
          .push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const ComplaintsView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ).then((_) {
        context.read<BottomNavVisibilityCubit>().show();
      });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
          color: unselectedContainerColor,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  RegularTextWithLocalization(
                    text: "الشكاوى",
                    fontSize: 20.sp,
                    textColor: myWhiteColor,
                    fontFamily: black,
                  ),
                ],
              ),
            ),
            Expanded(child: Image.asset(AssetsData.complaints,height: 80,)),
      
          ],
        ),
      ),
    );
  }
}
