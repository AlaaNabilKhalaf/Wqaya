import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/global_variables.dart';
import 'package:wqaya/Core/widgets/text_form_fields.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/get_code_to_sign_in.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/social_login_widget.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/regular_button.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordConfirmController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();

bool passwordIsVisible = false;
bool confirmPasswordIsVisible = false;

class _SignUpViewBodyState extends State<SignUpViewBody> {
  @override
  void initState() {
    // TODO: implement initState
    phoneNumberController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
    emailController.clear();
    nameController.clear();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    passwordConfirmController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TEXTS
            Column(
              children: [
                RegularTextWithLocalization(
                    text: 'welcomeToYou',
                    fontSize: 70.sp,
                    textColor: primaryColor,
                    fontFamily: bold),
                RegularTextWithLocalization(
                    text: 'startSignUp',
                    fontSize: 30.sp,
                    textColor: primaryColor,
                    fontFamily: medium),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),

            //TEXT FIELDS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                    fieldController: nameController, hintText: 'الاسم'),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextFormField(
                  fieldController: emailController,
                  hintText: 'البريد الإلكتروني',
                  icon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordIsVisible = !passwordIsVisible;
                        });
                      },
                      child: PasswordIcon(isVisible: passwordIsVisible)),
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextFormField(
                    textInputType: TextInputType.phone,
                    fieldController: phoneNumberController,
                    hintText: 'رقم الهاتف'),

                SizedBox(
                  height: 15.h,
                ),
                CustomTextFormField(
                  isPasswordVisible: passwordIsVisible,
                  fieldController: passwordController,
                  hintText: 'الرقم السري',
                  icon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordIsVisible = !passwordIsVisible;
                        });
                      },
                      child: PasswordIcon(isVisible: passwordIsVisible)),
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextFormField(
                    isPasswordVisible: confirmPasswordIsVisible,
                    icon: GestureDetector(
                        onTap: () {
                          setState(() {
                            confirmPasswordIsVisible =
                                !confirmPasswordIsVisible;
                          });
                        },
                        child:
                            PasswordIcon(isVisible: confirmPasswordIsVisible)),
                    fieldController: passwordConfirmController,
                    hintText: 'تاكيد الرقم السري'),
                SizedBox(
                  height: 15.h,
                ),
                // Here is The
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state is RegisterLoadingState ?
                      const Center(child: CircularProgressIndicator(color: primaryColor,)):
                    RegularButton(
                      height: 55.h,
                      buttonColor: primaryColor,
                      borderRadius: 20.r,
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).registerPatient(
                          email: emailController.text,
                          displayedName: nameController.text,
                          phoneNumber: phoneNumberController.text,
                          password: passwordController.text,
                          confirmedPassword: passwordConfirmController.text,
                          context: context,
                        );
                      },
                      child: RegularTextWithLocalization(
                        text: 'getCode',
                        fontSize: 20.sp,
                        textColor: myWhiteColor,
                        fontFamily: semiBold,
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              height: 60.h,
            ),
          ],
        ),
      ),
    );
  }
}
