import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/widgets/regular_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import '../../../../Core/utils/fonts.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../OnBoarding/Presentation/Views/welcome_view.dart';
import '../../../Profile/Controller/api_profile_cubit.dart';
import '../../Controller/api_profile_states.dart';

class ExistViewBody extends StatefulWidget {
  const ExistViewBody({super.key});

  @override
  State<ExistViewBody> createState() => _ExistViewBodyState();
}

bool justLogoutBottomIsActive = false;
bool logoutAndDeleteAccountBottomIsActive = false;
Color confirmBottomColor = textFormBackgroundColor;
Color confirmWordColor = primaryColor;

class _ExistViewBodyState extends State<ExistViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiProfileCubit, ApiProfileStates>(
      listener: (context, state) {
        if (state is DeleteUserSuccessState) {
          CacheHelper().removeData(key: 'token');
          CacheHelper().removeData(key: 'profileImage');

          showDialog(
            context: context,
            builder: (context) {
              return CustomAlert(
                nextText: '',
                nextScreenFunction: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const WelcomeView()));
                },
              );
            },
          );
        } else if (state is DeleteUserFailState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
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
                      text: 'onLogoutScreen',
                      fontSize: 30.sp,
                      textColor: primaryColor,
                      fontFamily: medium),
                ],
              ),
              Column(
                children: [

                  // Only Logout
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 18.w),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10.r,
                        )
                      ]),
                      child: RegularButton(
                        buttonColor: justLogoutBottomIsActive
                            ? primaryColor
                            : textFormBackgroundColor,
                        borderRadius: 20.r,
                        onTap: () {
                          setState(() {
                            justLogoutBottomIsActive = true;
                            logoutAndDeleteAccountBottomIsActive = false;
                            confirmBottomColor = primaryColor;
                            confirmWordColor = Colors.white;
                          });
                        },
                        height: 55.h,
                        borderColor: primaryColor,
                        borderWidth: 1,
                        child: RegularTextWithLocalization(
                          text: 'justLogout',
                          fontSize: 20.sp,
                          textColor: justLogoutBottomIsActive
                              ? Colors.white
                              : primaryColor,
                          fontFamily: semiBold,
                        ),
                      )),
// Logout and Delete Account
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 18.w),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10.r,
                        )
                      ]),
                      child: RegularButton(
                        buttonColor: logoutAndDeleteAccountBottomIsActive
                            ? primaryColor
                            : textFormBackgroundColor,
                        borderRadius: 20.r,
                        onTap: () {
                          setState(() {
                            logoutAndDeleteAccountBottomIsActive = true;
                            justLogoutBottomIsActive = false;
                            confirmBottomColor = primaryColor;
                            confirmWordColor = Colors.white;
                          });
                        },
                        height: 55.h,
                        borderColor: primaryColor,
                        borderWidth: 1,
                        child: RegularTextWithLocalization(
                          text: 'logoutAndDeleteAccount',
                          fontSize: 20.sp,
                          textColor: logoutAndDeleteAccountBottomIsActive
                              ? Colors.white
                              : primaryColor,
                          fontFamily: semiBold,
                        ),
                      )),

                  // Confirm
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 18.w),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10.r,
                      )
                    ]),
                    child: RegularButton(
                      buttonColor: confirmBottomColor,
                      borderRadius: 20.r,
                      onTap: () {
                        if (confirmBottomColor == primaryColor &&
                            justLogoutBottomIsActive) {
                          CacheHelper().removeData(key: 'token');
                          CacheHelper().removeData(key: 'profileImage');
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return CustomAlert(
                                nextText: '',
                                nextScreenFunction: () {
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (_) => const WelcomeView()));
                                },
                              );

                            },
                          );
                        }

                        if (confirmBottomColor == primaryColor &&
                            logoutAndDeleteAccountBottomIsActive) {
                          final email =
                              CacheHelper().getData(key: 'email') ?? "";
                          context.read<ApiProfileCubit>().deleteUser(email);
                        }
                      },
                      height: 55.h,
                      borderColor: primaryColor,
                      borderWidth: 1,
                      child: state is DeleteUserLoadingState
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : RegularTextWithLocalization(
                        text: 'confirm',
                        fontSize: 20.sp,
                        textColor: confirmWordColor,
                        fontFamily: semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
