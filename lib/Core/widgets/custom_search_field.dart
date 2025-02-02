import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/colors.dart';
import '../Utils/fonts.dart';

class SearchField extends StatefulWidget {


  const SearchField ({
    super.key,
    required this.hintText,

  });
  final String hintText ;

  @override
  State<SearchField> createState() => _SearchFieldState();

}


class _SearchFieldState extends State<SearchField> {
  late TextEditingController fieldController ;


  @override
  void initState() {
    // TODO: implement initState
    fieldController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    fieldController.clear();
    fieldController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
onTapOutside: (v){
  FocusManager.instance.primaryFocus?.unfocus();
},
      cursorHeight: 25,
      showCursor: true,
      cursorColor: primaryColor,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        fillColor:
            myWhiteColor,
        filled: true,

        labelStyle: TextStyle(
            color: bottomColor,
            fontSize: 16.sp,
            fontFamily: medium
        ),
        // border:  const OutlineInputBorder(
        //
        //     borderSide: BorderSide(
        //       color: errorColor,
        //       width: 1,
        //
        //     )
        // ),

        focusedBorder: OutlineInputBorder(
            borderSide:  const BorderSide(
                color: primaryColor,
                width: 1
            ),
            borderRadius: BorderRadius.circular(8)
        ),

        suffixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("test"),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,fontFamily: medium
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.transparent,
                width: 2
            ),

            borderRadius: BorderRadius.circular(8.r)
        ) ,

      ),
      controller: fieldController,

    );
  }
}
