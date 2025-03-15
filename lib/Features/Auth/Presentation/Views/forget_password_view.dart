import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/social_login_widget.dart';

import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_app_bar.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import 'get_code_to_reset_password.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

TextEditingController emailController = TextEditingController();

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              RegularTextWithLocalization(
                  text: 'welcomeToYou',
                  fontSize: 70.sp,
                  textColor: primaryColor,
                  fontFamily: bold),
              RegularTextWithLocalization(
                  text: 'enterEmail',
                  fontSize: 30.sp,
                  textColor: primaryColor,
                  fontFamily: medium),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: CustomTextFormField(
                          textInputType: TextInputType.phone,
                          fieldController: emailController,
                          hintText: 'البريد الالكتروني'),
                    ),
                  ],
                ),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if(emailController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: RegularTextWithLocalization(
                          text: "ادخل البريد الالكتروني",
                          fontSize: 15.sp,
                          textColor: Colors.white,
                          fontFamily: bold,
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );                  }
                  else {
                    if(state is ForgotPasswordSuccessState){
                      CacheHelper().saveData(key: 'emailToResetPass', value: emailController.text);
                      if(context.mounted){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const GetCodeToResetPassword()));
                      } else if(state is ForgotPasswordFailureState){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: RegularTextWithLocalization(
                              text: state.message,
                              fontSize: 15.sp,
                              textColor: Colors.white,
                              fontFamily: bold,
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }

                    }

                  }
                },
                builder: (context, state) {
                  var aCubit = context.read<AuthCubit>();
                  return state is !ForgotPasswordLoadingState ?
                  RegularButton(
                      height: 55.h,
                      buttonColor: primaryColor,
                      borderRadius: 20.r,
                      onTap: () {
                        aCubit.forgotPassword(email: emailController.text);
                      },
                      child: RegularTextWithLocalization(
                          text: 'getCode',
                          fontSize: 20.sp,
                          textColor: myWhiteColor,
                          fontFamily: semiBold)) :const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                },
              ),
              const Spacer(),
              const SocialLoginWidget()
            ],
          ),
        ));
  }
}
