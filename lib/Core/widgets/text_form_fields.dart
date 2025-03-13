import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/widgets/password_icon.dart';
import '../Utils/fonts.dart';
import '../utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.fieldController,
      required this.hintText,
      this.icon,
      this.isPasswordVisible,
      this.validatorMethod,
      this.textInputType});

  final TextEditingController fieldController;

  final String hintText;

  final bool? isPasswordVisible;

  final Widget? icon;

  final TextInputType? textInputType;

  final String? Function(String?)? validatorMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10.r,
        )
      ], borderRadius: BorderRadius.circular(15.r)),
      child: TextFormField(
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        keyboardType: textInputType ?? TextInputType.text,
        validator: validatorMethod,
        cursorColor: primaryColor,
        obscureText: isPasswordVisible ?? false,
        decoration: InputDecoration(
          filled: true,
          fillColor: textFormBackgroundColor,
          labelText: hintText,
          labelStyle: TextStyle(
              color: bottomColor, fontSize: 16.sp, fontFamily: medium),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: bottomColor,
            width: 1,
          )),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: errorColor,
            width: 1,
          )),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          suffixIcon: icon,
          hintText: hintText,
          hintStyle: TextStyle(
              color: bottomColor, fontSize: 16.sp, fontFamily: medium),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: bottomColor, width: 2),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        controller: fieldController,
      ),
    );
  }
}

class CustomPasswordFormField extends StatelessWidget {
  const CustomPasswordFormField(
      {super.key,
      required this.fieldController,
      required this.hintText,
      this.icon,
      this.isPassword,
      this.validatorMethod});

  final TextEditingController fieldController;

  final String hintText;

  final bool? isPassword;

  final Widget? icon;

  final String? Function(String?)? validatorMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 10.r,
        )
      ], borderRadius: BorderRadius.circular(15.r)),
      child: TextFormField(
        validator: validatorMethod,
        cursorColor: primaryColor,
        keyboardType: TextInputType.text,
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
          filled: true,
          fillColor: textFormBackgroundColor,
          labelText: hintText,
          labelStyle: TextStyle(
              color: bottomColor, fontSize: 16.sp, fontFamily: medium),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: errorColor,
            width: 1,
          )),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: errorColor,
            width: 1,
          )),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          suffixIcon: PasswordIcon(
            isVisible: isPassword ?? false,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: bottomColor, fontSize: 16.sp, fontFamily: medium),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: bottomColor, width: 2),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        controller: fieldController,
      ),
    );
  }
}

// class CustomTextField extends StatelessWidget {
//   const CustomTextField({
//     super.key,
//     required this.fieldController,
//     required this.hintText,
//     this.icon,
//     this.isPassword,
//   });
//   final TextEditingController fieldController ;
//   final String hintText ;
//   final bool? isPassword ;
//   final Widget? icon ;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
//           borderRadius: BorderRadius.circular(15.r)
//       ),
//       child: TextField(
//         onTapOutside: (v){
//         },
//          cursorHeight: 25,
//         showCursor: true,
//         cursorColor: primaryColor,
//         keyboardType: TextInputType.text,
//         obscureText: isPassword?? false,
//         decoration: InputDecoration(
//           fillColor: textFormBackgroundColor,
//           filled: true,
//
//           labelText: hintText,
//           labelStyle: TextStyle(
//               color: bottomColor,
//               fontSize: 16.sp,
//               fontFamily: medium
//           ),
//
//           border:  const OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: errorColor,
//                 width: 1,
//               )
//           ),
//           errorBorder: const OutlineInputBorder(
//
//               borderSide: BorderSide(
//                 color: errorColor,
//                 width: 1,
//               )
//           ),
//           focusedBorder: OutlineInputBorder(
//               borderSide:  const BorderSide(
//                   color: primaryColor,
//                   width: 1
//               ),
//             borderRadius: BorderRadius.circular(20.r),
//
//           ),
//           suffixIcon: icon,
//           hintText: hintText,
//           hintStyle: TextStyle(
//               color: bottomColor,
//               fontSize: 16.sp,
//               fontFamily: medium
//           ),
//           enabledBorder: OutlineInputBorder(
//               borderSide:  const BorderSide(
//                   color: bottomColor,
//                   width: 2
//               ),
//             borderRadius: BorderRadius.circular(20.r),
//
//           ) ,
//
//         ),
//         controller: fieldController,
//
//
//       ),
//     );
//   }
// }
