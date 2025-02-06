import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/constance.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_bar_cubit.dart';

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
    return ClipPath(
      clipper: CustomNavBarClipper(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                bool isSelected = currentIndex == index;
                return IconButton(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        color: isSelected ? Colors.white : Colors.white70,
                        size: isSelected
                            ? getResponsiveSize(context, fontSize: 32)
                            : getResponsiveSize(context, fontSize: 26),
                      ),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: isSelected ? 14 : 12,
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
          );
        },
      ),
    );
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(0, 0, 40, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}