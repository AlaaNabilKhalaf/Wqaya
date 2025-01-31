import 'package:flutter/cupertino.dart';


class RegularText extends StatelessWidget {
 const RegularText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.fontFamily,
    this.textOverflow,
    this.maxLine,
    this.textAlign,
    this.textDirection
  });

  final double fontSize ;

  final String text ;

  final String fontFamily ;
  final int? maxLine;
  final Color textColor;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {

    return Text(

      text,
      overflow: textOverflow?? TextOverflow.ellipsis,
      textAlign: textAlign?? TextAlign.center,
      maxLines: maxLine,
      textDirection: textDirection,
      style: TextStyle(
        fontFamily: fontFamily,
            fontSize: fontSize,
            color: textColor,
      ),
    );
  }
}

