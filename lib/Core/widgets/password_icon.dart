import 'package:flutter/material.dart';

import '../Utils/colors.dart';

class PasswordIcon extends StatelessWidget {
  const PasswordIcon({
    super.key,
  required this.isVisible
  });
final bool isVisible ;
  @override
  Widget build(BuildContext context) {
    return Icon(
      isVisible? Icons.visibility_off : Icons.remove_red_eye ,
      color: bottomColor,
      size: 22,
    );
  }
}
