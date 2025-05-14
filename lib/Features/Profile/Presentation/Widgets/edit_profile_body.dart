import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/global_variables.dart';
import 'package:wqaya/Core/widgets/password_icon.dart';
import 'package:wqaya/Core/widgets/text_form_fields.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Profile/Presentation/Widgets/profile_card.dart';
import '../../../../Core/utils/fonts.dart';
import '../../../Auth/Presentation/Widgets/custom_dropdown_governments.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Controller/api_profile_cubit.dart';
import '../../Controller/api_profile_states.dart';

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool userKindIsMale = true;
  String selectedGovernorate = 'Cairo';
  bool passwordIsVisible = false;
@override
  void initState() {
  currentPassword = CacheHelper().getData(key: 'currentPassword');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            RegularTextWithLocalization(text: 'welcomeToYou', fontSize: 70.sp, textColor: primaryColor, fontFamily: bold),
            RegularTextWithLocalization(text: 'inYourProfile', fontSize: 30.sp, textColor: primaryColor, fontFamily: medium),
            SizedBox(height: 38.h,),
            ProfileCard(cardAction: 'editProfile', onTap: (){}),

            SizedBox(height: 30.h),

      // Password
      CustomTextFormField(
      fieldController: passwordController,
      hintText: "ادخل كلمة السر",
      icon: GestureDetector(
      onTap: () {
      setState(() {
      passwordIsVisible = !passwordIsVisible;
      });
      },
      child: PasswordIcon(isVisible: passwordIsVisible),
      ),
      isPasswordVisible: passwordIsVisible,
      ),
      SizedBox(height: 30.h),

            //Name
            CustomTextFormField(
                fieldController: nameController, hintText: 'الاسم'),
            // National ID Field
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: CustomTextFormField(
                textInputType: TextInputType.phone,
                fieldController: nationalIdController,
                hintText: 'الرقم القومي',
              ),
            ),

            // Age and Gender Fields
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Age Field
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.64,
                    child: CustomTextFormField(
                      textInputType: TextInputType.phone,
                      fieldController: ageController,
                      hintText: 'العمر',
                    ),
                  ),

                  // Gender Toggle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        userKindIsMale = !userKindIsMale;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 55.h,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: bottomColor, width: 2),
                        color: textFormBackgroundColor,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 10.r)
                        ],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: RegularTextWithLocalization(
                        text: userKindIsMale ? 'male' : 'female',
                        fontSize: 20.sp,
                        textColor: bottomColor,
                        fontFamily: medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Address and Governorate Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Address Field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.64,
                  child: CustomTextFormField(
                    fieldController: addressController,
                    hintText: 'العنوان',
                  ),
                ),

                // Governorate Dropdown
                Container(
                  alignment: Alignment.center,
                  height: 55.h,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    border: Border.all(color: bottomColor, width: 2),
                    color: textFormBackgroundColor,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 10.r)
                    ],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomDropdownButton(
                    onGovernorateChanged: (newValue) {
                      setState(() {
                        selectedGovernorate = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            BlocConsumer<ApiProfileCubit, ApiProfileStates>(
              listener: (context, state) {
                if (state is UpdateUserSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.green,

                        content: Text(state.message)),
                  );
                } else if (state is UpdateUserFailState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: errorColor,

                        content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                return state is UpdateUserLoadingState
                    ? const CircularProgressIndicator()
                    : ProfileCard(
                  cardAction: 'confirm',
                  onTap: () {
                    final name = nameController.text.trim();
                    final password = passwordController.text.trim();
                    final nationalId = nationalIdController.text.trim();
                    final ageText = ageController.text.trim();
                    final address = addressController.text.trim();
                    final governorate = selectedGovernorate;
if(password.isEmpty){
  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(
        backgroundColor: primaryColor,
        content: Text('من فضلك أدخل الرقم السري أولاً')),
  );
  return;
}
else if(currentPassword != password){
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
        backgroundColor: errorColor,

        content: Text('الرقم السري ليس صحيح')),
  );
  return;
}
else{
  final isAllEmpty = name.isEmpty &&
      nationalId.isEmpty &&
      ageText.isEmpty &&
      address.isEmpty &&
      (governorate.isEmpty || governorate == 'Cairo');

  if (isAllEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: primaryColor,

          content: Text('من فضلك أدخل البيانات أولاً')),
    );
    return;
  }

  // Validate national ID only if filled
  if (nationalId.isNotEmpty && nationalId.length != 14) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: primaryColor,

          content: Text('الرقم القومي يجب أن يكون 14 رقمًا')),
    );
    return;
  }

  // Validate age only if filled
  final age = ageText.isNotEmpty ? int.tryParse(ageText) : null;
  if (ageText.isNotEmpty && (age == null || age <= 0)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: primaryColor,

          content: Text('من فضلك أدخل عمرًا صحيحًا')),
    );
    return;
  }

  // ✅ إرسال البيانات بعد التأكد
  context.read<ApiProfileCubit>().updateUserData(
    displayedName: name,
    nationalId: nationalId,
    age: age ?? 0,
    gender: userKindIsMale ? 'Male' : 'Female',
    address: address,
    governorate: governorate,
  );
}



                  },
                  cardColor: primaryColor,
                  textColor: myWhiteColor,
                );
              },
            )




          ],

        ),
      ),
    );
  }
}
