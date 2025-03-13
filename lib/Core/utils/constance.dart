import 'dart:io';

import 'package:flutter/material.dart';

double getResponsiveSize(BuildContext context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = scaleFactor * fontSize;
  double lowerLimit = fontSize * 0.8;
  double upperLimit = fontSize * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  if (w <= 550) {
    return w / 400; // Mobile breakpoint
  } else if (w <= 900) {
    return w / 700; // Tablet breakpoint
  } else {
    return w / 1000; // Desktop breakpoint
  }
}

class PlatformAdaptiveIcon extends StatelessWidget {
  final IconData cupertinoIcon;
  final IconData materialIcon;
  final double size;
  final Color color;

  const PlatformAdaptiveIcon({super.key,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.size = 24.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Platform.isIOS ? cupertinoIcon : materialIcon,
      size: size,
      color: color,
    );
  }
}

