import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../../NavBar/Presentation/Views/nav_bar_view.dart';
import 'custom_dropdown_governments.dart';

class FollowingUpFormFields extends StatefulWidget {
  const FollowingUpFormFields({super.key});

  @override
  State<FollowingUpFormFields> createState() => _FollowingUpFormFieldsState();
}

class _FollowingUpFormFieldsState extends State<FollowingUpFormFields> {
  TextEditingController idController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool userKindIsMale = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextFormField(fieldController: idController, hintText: 'الرقم القومي'),
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 30.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                // height: 55.h,
                  width: MediaQuery.of(context).size.width*0.64,

                  child: CustomTextFormField(fieldController: ageController, hintText: 'العمر')),


              GestureDetector(
                onTap: (){
                  setState(() {
                    userKindIsMale = !userKindIsMale;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 55.h,
                  width: MediaQuery.of(context).size.width*0.25,
                  decoration: BoxDecoration(
                    border: Border.all(color: bottomColor,width:2),
                      color: textFormBackgroundColor,
                      boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
                      borderRadius: BorderRadius.circular(20.r)),
                  child:RegularText(text: userKindIsMale? 'male' :'female' , fontSize: 20.sp, textColor: bottomColor, fontFamily: medium)
                ),
              ),


            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width*0.64,

                child: CustomTextFormField(fieldController: addressController, hintText: 'العنوان')),
            Container(
              alignment: Alignment.center,
              height: 55.h,
              width: MediaQuery.of(context).size.width*0.25,
              decoration: BoxDecoration(
                  border: Border.all(color: bottomColor,width:2),
                  color: textFormBackgroundColor,
                  boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
                  borderRadius: BorderRadius.circular(20.r)),
              child: const CustomDropdownButton()

            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h, ),
          child: RegularButton(
              height: 55.h,
              buttonColor: primaryColor, borderRadius: 20.r, onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const NavBarView()));
          }, child: RegularText(text: 'next', fontSize: 20.sp, textColor: myWhiteColor, fontFamily: semiBold)),
        ),
      ],
    );
  }
}
