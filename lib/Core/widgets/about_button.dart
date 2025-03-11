import 'package:flutter/material.dart';

import '../../Features/About/Presentation/Views/about_view.dart';
import '../Utils/colors.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutView()));
      },
      child: const Icon(Icons.info_outlined, color: primaryColor,size: 28,),
    );
  }
}
