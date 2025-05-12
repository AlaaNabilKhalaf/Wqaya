import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/custom_home_app_bar.dart';
import '../../../../Core/widgets/password_icon.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../Controller/api_profile_cubit.dart';
import '../../Controller/api_profile_states.dart';
import '../Widgets/profile_card.dart';
import 'get_code_to_change_phone_number.dart';

class EditPhoneNumberView extends StatefulWidget {
  const EditPhoneNumberView({super.key});

  @override
  State<EditPhoneNumberView> createState() => _EditPhoneNumberViewState();
}

class _EditPhoneNumberViewState extends State<EditPhoneNumberView> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController confirmNewPhoneNumberController = TextEditingController();
  bool passwordIsVisible = false;
  String? currentPassword;

  @override
  void initState() {
    super.initState();
    oldPasswordController.clear();
    phoneNumberController.clear();
    confirmNewPhoneNumberController.clear();
    currentPassword = CacheHelper().getDataString(key: 'currentPassword');
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    phoneNumberController.dispose();
    confirmNewPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiProfileCubit, ApiProfileStates>(
      listener: (context, state) {
        if (state is RequestChangePhoneSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GetCodeToChangePhoneNumber(phone: phoneNumberController.text),
            ),
          );
        } else if (state is RequestChangePhoneFailState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: myWhiteColor,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: HomeCustomAppBar(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100.h),
                  RegularTextWithLocalization(
                    text: 'welcomeToYou',
                    fontSize: 70.sp,
                    textColor: primaryColor,
                    fontFamily: bold,
                  ),
                  RegularTextWithLocalization(
                    text: 'inYourProfile',
                    fontSize: 30.sp,
                    textColor: primaryColor,
                    fontFamily: medium,
                  ),
                  SizedBox(height: 38.h),
                  ProfileCard(
                    cardAction: 'editPhoneNumber',
                    textColor: myWhiteColor,
                    cardColor: primaryColor,
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomTextFormField(
                      icon: GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordIsVisible = !passwordIsVisible;
                          });
                        },
                        child: PasswordIcon(isVisible: passwordIsVisible),
                      ),
                      isPasswordVisible: passwordIsVisible,
                      fieldController: oldPasswordController,
                      hintText: 'كلمة السر الحالية',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: CustomTextFormField(
                      textInputType: TextInputType.phone,
                      fieldController: phoneNumberController,
                      hintText: 'رقم الهاتف الجديد',
                    ),
                  ),
                  CustomTextFormField(
                    textInputType: TextInputType.phone,
                    fieldController: confirmNewPhoneNumberController,
                    hintText: 'اعادة ادخال رقم الهاتف الجديد',
                  ),
                  ProfileCard(
                    cardAction: 'getCode',
                    onTap: () {
                      if (oldPasswordController.text == currentPassword) {
                        if (phoneNumberController.text == confirmNewPhoneNumberController.text) {
                          context.read<ApiProfileCubit>().requestChangePhone(phoneNumberController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: errorColor,
                              content: RegularTextWithoutLocalization(
                                text: 'رقما الهاتف غير متطابقين',
                                fontSize: 20,
                                textColor: Colors.white,
                                fontFamily: medium,
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: errorColor,
                            content: RegularTextWithoutLocalization(
                              text: 'الرقم السري غير صحيح',
                              fontSize: 20,
                              textColor: Colors.white,
                              fontFamily: medium,
                            ),
                          ),
                        );
                      }
                    },
                    cardColor: primaryColor,
                    textColor: myWhiteColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
