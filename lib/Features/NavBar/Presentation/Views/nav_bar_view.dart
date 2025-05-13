import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Features/NavBar/Presentation/Widgets/custom_bottom_nav_bar.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_bar_cubit.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_visibility__cubit.dart';

class NavBarView extends StatelessWidget {
  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, state) {
        var bottomNavCubit = context.read<BottomNavCubit>();
        return PopScope(
          canPop: false, // Prevents the default back behavior
          onPopInvokedWithResult: (didPop,result) {
            if (didPop) return;
            final NavigatorState navState = bottomNavCubit.navigatorKeys[state].currentState!;
            if (navState.canPop()) {
              navState.pop();
            } else {
              SystemNavigator.pop();
            }
          },
          child: Scaffold(
            backgroundColor: myWhiteColor,
            body: Stack(
              children: List.generate(bottomNavCubit.pages.length, (index) {
                return Offstage(
                  offstage: bottomNavCubit.state != index,
                  child: Navigator(
                    key: bottomNavCubit.navigatorKeys[index],
                    onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (_) => bottomNavCubit.pages[index],
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: BlocBuilder<BottomNavVisibilityCubit, bool>(
              builder: (context, isVisible) {
                return isVisible
                    ? CustomBottomNavBar(
                  icons: bottomNavCubit.icons,
                  labels: bottomNavCubit.labels,
                )
                    : const SizedBox.shrink();
              },
            ),

          ),
        );
      },
    );
  }
}
