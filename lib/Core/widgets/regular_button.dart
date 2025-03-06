import 'package:flutter/cupertino.dart';
import 'package:wqaya/Core/Utils/colors.dart';

class RegularButton extends StatelessWidget {
  const RegularButton({
    super.key,
    required this.child,
     this.width,
     this.height,
    this.borderColor,
    this.borderWidth,
    required this.buttonColor,
    required this.borderRadius,
    required this.onTap
  });

  final Widget child ;
  final double? width;
  final double? height;
  final double? borderWidth;
  final Color buttonColor ;
  final Color? borderColor ;
  final double borderRadius ;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        height: height, width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(
            color: borderColor??myWhiteColor,
            width: borderWidth??0
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}
