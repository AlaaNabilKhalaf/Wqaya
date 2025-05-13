import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/Utils/fonts.dart';
import '../../../../Core/widgets/text_form_fields.dart';
import '../../../../Core/widgets/texts.dart';
import '../../Controller/api_profile_cubit.dart';
import '../../Controller/api_profile_states.dart';
import 'profile_card.dart';

class GetCodeBody extends StatefulWidget {
  final String phone;

  const GetCodeBody({super.key, required this.phone});

  @override
  State<GetCodeBody> createState() => _GetCodeBodyState();
}

class _GetCodeBodyState extends State<GetCodeBody> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiProfileCubit, ApiProfileStates>(
      listener: (context, state) {
        if (state is ChangePhoneSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: RegularTextWithoutLocalization(
                text: state.message,
                fontSize: 18,
                textColor: Colors.white,
                fontFamily: medium,
              ),
            ),
          );
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is ChangePhoneFailState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: errorColor,
              content: RegularTextWithoutLocalization(
                text: state.message,
                fontSize: 18,
                textColor: Colors.white,
                fontFamily: medium,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              SizedBox(
                width: 400.w,
                child: RegularTextWithoutLocalization(
                  text: 'ادخل كود التحقق المرسل إلى بريدك الإلكتروني',
                  fontSize: 22.sp,
                  fontFamily: medium,
                  textColor: primaryColor,
                  maxLine: 3,
                ),
              ),
              SizedBox(height: 30.h),
              CustomTextFormField(
                textInputType: TextInputType.number,
                fieldController: codeController,
                hintText: 'أدخل الكود هنا',
              ),
              const Spacer(),
              // SizedBox(height: 40.h),
              state is ChangePhoneLoadingState
                  ? const CircularProgressIndicator()
                  : ProfileCard(
                cardAction: 'تأكيد تغيير الرقم',
                cardColor: primaryColor,
                textColor: Colors.white,
                onTap: () {
                  if (codeController.text.isEmpty || codeController.text.length != 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: errorColor,
                        content: RegularTextWithoutLocalization(
                          text: 'من فضلك أدخل كود مكون من 4 أرقام',
                          fontSize: 18,
                          textColor: Colors.white,
                          fontFamily: medium,
                        ),
                      ),
                    );
                    return;
                  }

                  final int code = int.tryParse(codeController.text) ?? 0;
                  context.read<ApiProfileCubit>().changePhone(widget.phone, code);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
