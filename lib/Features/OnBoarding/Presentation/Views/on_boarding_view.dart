import 'package:flutter/material.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Features/OnBoarding/Presentation/Widgets/image_container.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          ImageContainer(image: AssetsData.boarding2),

        ],
      ),

    );
  }
}
