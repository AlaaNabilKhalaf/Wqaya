import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';

import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../../Profile/Presentation/Widgets/profile_card.dart';
import '../Widgets/social_login_widget.dart';
import 'login_view.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

TextEditingController newPasswordController = TextEditingController();
TextEditingController confirmNewPasswordController = TextEditingController();
bool newPasswordIsVisible = false;
bool confirmNewPasswordIsVisible = false;

class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar()),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              RegularText(
                  text: 'welcomeToYou',
                  fontSize: 70.sp,
                  textColor: primaryColor,
                  fontFamily: bold),
              RegularText(
                  text: 'resetPassword',
                  fontSize: 30.sp,
                  textColor: primaryColor,
                  fontFamily: medium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(
                      icon: GestureDetector(
                          onTap: () {
                            setState(() {
                              newPasswordIsVisible = !newPasswordIsVisible;
                            });
                          },
                          child: PasswordIcon(isVisible: newPasswordIsVisible)),
                      isPasswordVisible: newPasswordIsVisible,
                      fieldController: newPasswordController,
                      hintText: 'كلمة السر الجديدة',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(
                      icon: GestureDetector(
                          onTap: () {
                            setState(() {
                              confirmNewPasswordIsVisible =
                                  !confirmNewPasswordIsVisible;
                            });
                          },
                          child: PasswordIcon(
                              isVisible: confirmNewPasswordIsVisible)),
                      isPasswordVisible: confirmNewPasswordIsVisible,
                      fieldController: confirmNewPasswordController,
                      hintText: 'اعادة كتابة كلمة السر الجديدة',
                    ),
                  ),
                  // SizedBox(width: 100.h,),

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (newPasswordController.text == confirmNewPasswordController.text){
                        if (state is ResetPasswordSuccess){
                          {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomAlert(
                                  nextScreenFunction: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const LoginView()));
                                  },
                                  nextText: 'backToLogin',
                                );
                              },
                            );
                          }
                        } else if (state is ResetPasswordFailure){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: RegularText(
                                text: state.error,
                                fontSize: 15.sp,
                                textColor: Colors.white,
                                fontFamily: bold,
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: RegularText(
                                text: "كلمات السر غير متطابقة",
                                fontSize: 15.sp,
                                textColor: Colors.white,
                                fontFamily: bold,
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }


                    },
                    builder: (context, state) {
                      var aCubit= context.read<AuthCubit>();
                      return ProfileCard(
                        cardAction: 'confirm',
                        onTap: (){

                         aCubit.resetPassword(code: CacheHelper().getData(key: 'resetPassCode'), newPassword:newPasswordController.text );
                        } ,
                        cardColor: primaryColor,
                        textColor: myWhiteColor,
                      );
                    },
                  )
                ],
              ),
              const Spacer(),
              const SocialLoginWidget()
            ],
          ),
        ));
  }
}
