import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Features/NavBar/Presentation/Widgets/custom_bottom_nav_bar.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_bar_cubit.dart';


class BotView extends StatelessWidget {
  const BotView({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text("Chat Bot"));
}



class NavBarView extends StatelessWidget {
  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, state) {
        var bottomNavCubit = context.read<BottomNavCubit>();

        return Scaffold(
          backgroundColor: myWhiteColor,
          body: Stack(
            children: List.generate(bottomNavCubit.pages.length, (index) {
              return Offstage(
                offstage: bottomNavCubit.state != index,
                child: Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (_) => bottomNavCubit.pages[index],
                  ),
                ),
              );
            }),
          ),
          bottomNavigationBar: CustomBottomNavBar(icons: BottomNavCubit().icons, labels: BottomNavCubit().labels),
        );
      },
    );
  }
}
