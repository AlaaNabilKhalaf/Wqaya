import 'package:flutter/material.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/widgets/texts.dart';

class ComplaintsButton extends StatefulWidget {
  final String text,fontFamily ;
  final Color textColor , borderColor , buttonColor;
  final double fontSize ;
  final Function onTap ;
  const ComplaintsButton({super.key, required this.text, required this.fontFamily, required this.textColor, required this.borderColor, required this.buttonColor, required this.fontSize, required this.onTap});

  @override
  State<ComplaintsButton> createState() => _ComplaintsButtonState();
}

class _ComplaintsButtonState extends State<ComplaintsButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      splashColor: textFieldColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: widget.buttonColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: widget.borderColor
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:RegularText(
              text: widget.text,
              fontSize: widget.fontSize,
              textColor: widget.textColor,
              fontFamily: widget.fontFamily,
            ),

          ),
        ),
      ),
    );

  }
}
