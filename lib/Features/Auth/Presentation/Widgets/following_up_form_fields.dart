import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/regular_button.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../../Home/Presentation/Views/symptoms_suffered.dart';
import 'custom_dropdown_governments.dart';

class FollowingUpFormFields extends StatefulWidget {
  const FollowingUpFormFields({super.key});

  @override
  State<FollowingUpFormFields> createState() => _FollowingUpFormFieldsState();
}

class _FollowingUpFormFieldsState extends State<FollowingUpFormFields> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool userKindIsMale = true;
  String selectedGovernorate = 'Cairo';

  @override
  Widget build(BuildContext context) {
    var aCubit = context.read<AuthCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 80,),
        // National ID Field
        CustomTextFormField(
          textInputType: TextInputType.phone,
          fieldController: idController,
          hintText: 'الرقم القومي',
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
        // Next Button
        const Spacer(),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is FollowUpSuccessState) {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SymptomsSufferedView()),
                );
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state is !FollowUpLoadingState ?
                RegularButton(
                  height: 55.h,
                  buttonColor: primaryColor,
                  borderRadius: 20.r,
                  onTap: () async {
                    final nationalId = idController.text.trim();
                    final ageText = ageController.text.trim();
                    final address = addressController.text.trim();

                    if (nationalId.isEmpty ||
                        ageText.isEmpty ||
                        address.isEmpty ||
                        selectedGovernorate.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('من فضلك املأ جميع الحقول المطلوبة'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Stop execution
                    }

                    // Try parsing age
                    int? age = int.tryParse(ageText);
                    if (age == null || age <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى إدخال عمر صالح'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    print(CacheHelper().getData(key: 'token'));
                    print(CacheHelper().getData(key: 'name'));
                    print(nationalId);
                    print(age);
                    print(userKindIsMale ? 'Male' : 'Female');
                    print(address);
                    print(selectedGovernorate);

                    await aCubit.updateUser(
                      token: CacheHelper().getData(key: 'token'),
                      displayedName: CacheHelper().getData(key: 'name'),
                      nationalId: nationalId,
                      age: age,
                      gender: userKindIsMale ? 'Male' : 'Female',
                      address: address,
                      governorate: selectedGovernorate,
                    );
                  },
                  child: RegularTextWithLocalization(
                    text: 'next',
                    fontSize: 20.sp,
                    textColor: myWhiteColor,
                    fontFamily: semiBold,
                  ),
                ) : const CircularProgressIndicator(backgroundColor: primaryColor,);
              },
            ),
          ),
        ),
        const SizedBox(height: 100,),
      ],
    );
  }
}
