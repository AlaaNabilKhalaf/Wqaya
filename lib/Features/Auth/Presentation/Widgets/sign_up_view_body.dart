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
import '../../../../Core/widgets/custom_dropdown_phones.dart';

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
                RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
                RegularTextWithLocalization(text: 'startSignUp', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
              ],
            ),
             SizedBox(height: 30.h,),

            //TEXT FIELDS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(fieldController: nameController, hintText: 'الاسم'),
                SizedBox(height: 15.h,),
                CustomTextFormField(
                  fieldController: emailController, hintText: 'البريد الإلكتروني',
                  icon: GestureDetector(
                      onTap: (){
                        setState(() {
                          passwordIsVisible = !passwordIsVisible;
                        });
                      },
                      child: PasswordIcon(isVisible: passwordIsVisible )),
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.64,
                        child: CustomTextFormField(
                            textInputType: TextInputType.phone,
                            fieldController: phoneNumberController, hintText: 'رقم الهاتف')),
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

                SizedBox(height: 15.h,),
                CustomTextFormField(
                  isPasswordVisible: passwordIsVisible,
                  fieldController: passwordController, hintText: 'الرقم السري',

                  icon: GestureDetector(
                    onTap: (){
                      setState(() {
                        passwordIsVisible = !passwordIsVisible;
                      });
                    },
                    child: PasswordIcon(isVisible: passwordIsVisible )),
                ),
                SizedBox(height: 15.h,),
                CustomTextFormField(
                    isPasswordVisible: confirmPasswordIsVisible,
                    icon: GestureDetector(
                        onTap: (){
                          setState(() {
                            confirmPasswordIsVisible = !confirmPasswordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: confirmPasswordIsVisible )),

                    fieldController: passwordConfirmController, hintText: 'تاكيد الرقم السري'),
                SizedBox(height: 15.h,),

      // Here is The
      BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (kDebugMode) {
            print(phoneNumberController.text.length);
          }
          if (state is RegisterFailureState) {
            if (passwordController.text != passwordConfirmController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: RegularTextWithoutLocalization(
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
            else if (!emailRegex.hasMatch(emailController.text)){
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: RegularTextWithoutLocalization(
                      text: "ahmed@example.com\nالبريد الالكتروني يجب أن يكون بهذه الصورة",
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
            else if (phoneNumberController.text.length!=10||phoneNumberController.text.length!=11){
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: RegularTextWithoutLocalization(
                      text: "ادخل رقم هاتف صحيح",
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
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: RegularTextWithoutLocalization(
                    text: "كلمة السر يجب ان تكون 8 احرف\n و تشمل حرف 'Capital' ",
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
          else if (state is RegisterSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: RegularTextWithoutLocalization(
                  text: state.message,
                  fontSize: 15.sp,
                  textColor: Colors.white,
                  fontFamily: bold,
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GetCodeToSignIn()),
                );
              }
            });
          }
        },
        builder: (context, state) {
          var aCubit = context.read<AuthCubit>();
          return state is !RegisterLoadingState?
          RegularButton(
            height: 55.h,
            buttonColor: primaryColor,
            borderRadius: 20.r,
            onTap: ()
            {
              aCubit.register(
                name: nameController.text,
                email: emailController.text,
                password: passwordController.text,
                phoneNumber: phoneNumberController.text.startsWith('0')
                    ? phoneNumberController.text
                    : "0${phoneNumberController.text}",
                confirmedPassword: passwordConfirmController.text,
              );

              // This Method Is For Caching The Password ONLY
                CacheHelper().saveData(key: 'currentPassword', value: passwordController.text);

              // Debug prints
              // debugPrint(nameController.text);
              debugPrint(phoneNumberController.text);
              debugPrint(passwordController.text);
              debugPrint(passwordConfirmController.text);
              debugPrint(emailController.text);
            },

            child: RegularTextWithLocalization(
              text: 'getCode',
              fontSize: 20.sp,
              textColor: myWhiteColor,
              fontFamily: semiBold,
            ),
          ) :
          const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        },
      ),              ],
            ),
            SizedBox(height: 60.h,),

           const SocialLoginWidget()

          ],
        ),
      ),
    );
  }
}
