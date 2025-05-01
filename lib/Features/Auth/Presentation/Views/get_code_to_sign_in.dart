import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/following_up_view.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/get_code_sign_in_body.dart';

import '../../../../Core/widgets/custom_app_bar.dart';
class GetCodeToSignIn extends StatelessWidget {
  const GetCodeToSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerificationLoadingState) {

          } else if (state is VerificationSuccessState) {
            Navigator.pop(context);
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FollowingUpView(),
              ),
            );
          } else if (state is VerificationFailureState) {
            Navigator.pop(context);
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
        builder: (context, state) {
          return const GetCodeSignInBody();
        },
      )
    );
  }
}
