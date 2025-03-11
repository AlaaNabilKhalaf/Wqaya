import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/widgets/custom_dropdown_phones.dart';
import 'package:wqaya/Features/Profile/Presentation/Views/profile_view.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_home_app_bar.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../Widgets/profile_card.dart';

class EditPhoneNumberView extends StatefulWidget {
  const EditPhoneNumberView({super.key});

  @override
  State<EditPhoneNumberView> createState() => _EditPhoneNumberViewState();
}
TextEditingController oldPasswordController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController confirmNewPhoneNumberController = TextEditingController();
bool passwordIsVisible = false;

class _EditPhoneNumberViewState extends State<EditPhoneNumberView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
        body:SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h,),

                RegularText(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
                RegularText(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
                SizedBox(height: 38.h,),
                ProfileCard(cardAction: 'editPhoneNumber', textColor: myWhiteColor,cardColor: primaryColor, onTap: (){
                }),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CustomTextFormField(
                    icon: GestureDetector(
                        onTap: (){
                          setState(() {
                            passwordIsVisible = !passwordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: passwordIsVisible )),
                    isPasswordVisible: passwordIsVisible,
                    fieldController: oldPasswordController, hintText: 'كلمة السر الحالية',),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width*0.64,
                          child: CustomTextFormField(fieldController: phoneNumberController, hintText: 'رقم الهاتف الجديد')),
                      Container(
                        alignment: Alignment.center,
                        height: 55.h,
                        width: MediaQuery.of(context).size.width*0.25,
                        decoration: BoxDecoration(
                            border: Border.all(color: bottomColor,width:2),
                            color: textFormBackgroundColor,
                            boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
                            borderRadius: BorderRadius.circular(20.r)),
                        child: const CustomDropdownPhones(),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 19.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.64,
                        child: CustomTextFormField(fieldController: confirmNewPhoneNumberController, hintText: 'اعادة ادخال رقم الهاتف الجديد')),
                    Container(
                      alignment: Alignment.center,
                      height: 55.h,
                      width: MediaQuery.of(context).size.width*0.25,
                      decoration: BoxDecoration(
                          border: Border.all(color: bottomColor,width:2),
                          color: textFormBackgroundColor,
                          boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
                          borderRadius: BorderRadius.circular(20.r)),
                      child: const CustomDropdownPhones(),
                    ),
                  ],
                ),
                ProfileCard(cardAction: 'confirm', onTap: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent dismissing by tapping outside
                    builder: (BuildContext context) {
                      return CustomAlert(nextScreenFunction: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileView()));
                      },nextText: 'back',);

                    },
                  );


                },cardColor: primaryColor,textColor: myWhiteColor,)



              ],
            ),
          ),
        )

    );

  }
}
