import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';


class RegularTextWithLocalization extends StatelessWidget {
  const RegularTextWithLocalization({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.fontFamily,
    this.textOverflow,
    this.maxLine,
    this.textAlign,

  });

  final double fontSize ;

  final String text ;

  final String fontFamily ;
  final int? maxLine;
  final Color textColor;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {

    return Text(
      text,
      overflow: textOverflow?? TextOverflow.ellipsis,
      textAlign: textAlign?? TextAlign.center,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
      ),
    ).tr();
  }
}

class RegularTextWithoutLocalization extends StatelessWidget {
  const RegularTextWithoutLocalization({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.fontFamily,
    this.textOverflow,
    this.maxLine,
    this.textAlign,

  });

  final double fontSize ;

  final String text ;

  final String fontFamily ;
  final int? maxLine;
  final Color textColor;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {

    return Text(
      text,
      overflow: textOverflow?? TextOverflow.ellipsis,
      textAlign: textAlign?? TextAlign.center,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
      ),
    );
  }
}

