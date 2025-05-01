import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/get_code_to_sign_in.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import 'package:wqaya/Features/Auth/Presentation/Widgets/sign_up_view_body.dart';
import '../../../../Core/Utils/colors.dart';
import '../../../../Core/widgets/custom_app_bar.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: myWhiteColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar()),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red, content: Text(state.message)));
          } else if (state is RegisterSuccessState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const GetCodeToSignIn()));
          }
        },
        child: const SignUpViewBody(),
      ),
    );
  }
}
