import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Profile/Presentation/Views/change_password_view.dart';
import 'package:wqaya/Features/Profile/Presentation/Views/edit_phone_number_view.dart';
import 'package:wqaya/Features/Profile/Presentation/Views/edit_profile_view.dart';
import 'package:wqaya/Features/Profile/Presentation/Views/exist_view.dart';
import 'package:wqaya/Features/Profile/Presentation/Widgets/profile_card.dart';
import '../Views/change_profile_picture_view.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
          RegularTextWithLocalization(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
          SizedBox(height: 38.h,),
          ProfileCard(cardAction: 'editProfile', onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileView()));
          }),
          ProfileCard(cardAction: 'changeProfilePicture', onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangeProfilePictureView()));
          }),
          ProfileCard(cardAction: 'editPhoneNumber', onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditPhoneNumberView()));
          }),
          ProfileCard(cardAction: 'changePassword', onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordView()));

          }),
          ProfileCard(cardAction: 'exist', onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ExistView()));

          }),

        ],
      ),
    );
  }
}
