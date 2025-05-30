import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../../NavBar/Presentation/Views/nav_bar_view.dart';
import '../Views/forget_password_view.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool passwordIsVisible = false;

class _LoginViewBodyState extends State<LoginViewBody> {
  @override
  void initState() {
    // TODO: implement initState
    phoneNumberController.clear();
    passwordController.clear();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var aCubit = context.read<AuthCubit>();
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              RegularTextWithLocalization(
                  text: 'welcomeToYou',
                  fontSize: 70.sp,
                  textColor: primaryColor,
                  fontFamily: bold),
              RegularTextWithLocalization(
                  text: 'startLogin',
                  fontSize: 30.sp,
                  textColor: primaryColor,
                  fontFamily: medium),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                  textInputType: TextInputType.phone,
                  fieldController: phoneNumberController,
                  hintText: 'رقم الهاتف'),
              SizedBox(
                height: 19.h,
              ),
              CustomTextFormField(
                fieldController: passwordController,
                hintText: 'الرقم السري',
                icon: GestureDetector(
                    onTap: () {
                      setState(() {
                        passwordIsVisible = !passwordIsVisible;
                      });
                    },
                    child: PasswordIcon(isVisible: passwordIsVisible)),
                isPasswordVisible: passwordIsVisible,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordView()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 19.h, horizontal: 5.w),
                  child: RegularTextWithLocalization(
                      text: 'forgetPassword',
                      fontSize: 14.sp,
                      textColor: bottomColor,
                      fontFamily: medium),
                ),
              ),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is SignInSuccessState) {
                    debugPrint("Signed in");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavBarView()));
                  } else if (state is SignInFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: RegularTextWithLocalization(
                          text: state.error,
                          fontSize: 15.sp,
                          textColor: Colors.white,
                          fontFamily: bold,
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state is !SignInLoadingState?
                    RegularButton(
                        height: 55.h,
                        buttonColor: primaryColor,
                        borderRadius: 20.r,
                        onTap: () async {
                          await aCubit.signIn(
                              phoneNumber: phoneNumberController.text,
                              password: passwordController.text);
                        },
                        child: RegularTextWithLocalization(
                            text: 'login',
                            fontSize: 20.sp,
                            textColor: myWhiteColor,
                            fontFamily: semiBold)) : const Center(
                              child: CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ),
                            );
                  },
                ),
              ),
              const SizedBox(height: 150,)
            ],
          ),
        ],
      ),
    );
  }
}
