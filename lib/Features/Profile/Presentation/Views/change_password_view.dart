import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/cache/cache_helper.dart';
import '../../../../Core/utils/global_variables.dart';
import '../../../../Core/widgets/custom_ alert.dart';
import '../../../../Core/widgets/custom_home_app_bar.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../Controller/api_profile_cubit.dart';
import '../../Controller/api_profile_states.dart';
import '../Widgets/profile_card.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();

}


class _ChangePasswordViewState extends State<ChangePasswordView> {

  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController ;
  late TextEditingController confirmNewPasswordController;
  bool currentPasswordIsVisible = false;
  bool newPasswordIsVisible = false;
  bool confirmNewPasswordIsVisible = false;
  @override
  @override
  void initState() {
    super.initState();
    currentPassword = CacheHelper().getData(key: 'currentPassword');
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myWhiteColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), child: HomeCustomAppBar()),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80.h,),

                RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
                RegularTextWithLocalization(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
                SizedBox(height: 38.h,),
                ProfileCard(cardAction: 'changePassword', textColor: myWhiteColor,cardColor: primaryColor, onTap: (){
                }),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CustomTextFormField(
                    icon: GestureDetector(
                        onTap: (){
                          setState(() {
                            currentPasswordIsVisible = !currentPasswordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: currentPasswordIsVisible )),
                    isPasswordVisible: currentPasswordIsVisible,
                    fieldController: oldPasswordController, hintText: 'كلمة السر الحالية',),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CustomTextFormField(
                    icon: GestureDetector(
                        onTap: (){
                          setState(() {
                            newPasswordIsVisible = !newPasswordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: newPasswordIsVisible )),
                    isPasswordVisible: newPasswordIsVisible,
                    fieldController: newPasswordController, hintText: 'كلمة السر الجديدة',),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CustomTextFormField(
                    icon: GestureDetector(
                        onTap: (){
                          setState(() {
                            confirmNewPasswordIsVisible = !confirmNewPasswordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: confirmNewPasswordIsVisible )),
                    isPasswordVisible: confirmNewPasswordIsVisible,
                    fieldController: confirmNewPasswordController, hintText: 'اعادة كتابة كلمة السر الجديدة',),
                ),



                BlocConsumer<ApiProfileCubit, ApiProfileStates>(
                  listener: (context, state) {

                    if(currentPassword! == oldPasswordController.text.toString()){
                      if (newPasswordController.text == confirmNewPasswordController.text){

                if(state is ChangePasswordSuccessState){
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CustomAlert(
                        nextScreenFunction: () {},
                        nextText: '',
                      );
                    },
                  );
                }

                else if(state is ChangePasswordFailState){
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
                      else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: RegularTextWithoutLocalization(
                                text: "كلمات السر الجديدة غير متطابقة",
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
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: RegularTextWithoutLocalization(
                            text: "كلمة السر الحالية خاطئة",
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
                  builder: (context, state) {
                    return ProfileCard(
                      cardAction: 'confirm',
                      onTap: (){
                        context.read<ApiProfileCubit>().changePassword(
                            oldPasswordController.text,
                            newPasswordController.text,
                            confirmNewPasswordController.text);
                      } ,
                      cardColor: primaryColor,
                      textColor: myWhiteColor,
                    );
                  },
                )




              ],
            ),
          ),
        )

    );
  }
}
