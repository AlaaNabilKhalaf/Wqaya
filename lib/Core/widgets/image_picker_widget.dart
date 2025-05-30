import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/utils/assets_data.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_states.dart';
import '../../Features/Profile/Controller/profile_image_cubit.dart';
import '../Utils/colors.dart';

class ImagePickerWidget extends StatelessWidget {

  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileImageCubit>(context);

    return BlocBuilder<ProfileImageCubit,ProfileImageStates>(
      builder: (context , _){
        return  GestureDetector(
          onTap: (){
            context.read<ProfileImageCubit>().takeImageFromGallery();
            context.read<ProfileImageCubit>().imagePicked = true;
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            margin:  const EdgeInsets.symmetric(vertical: 18),
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: textFormBackgroundColor,
                boxShadow: [BoxShadow(color:Colors.grey.shade300,blurRadius: 10.r,)],
                borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: bottomColor,width: 2
              )
            ),
            child: Center(
              child: SizedBox(
                  height: 245,
                  width:double.infinity,
                  child:
              cubit.imgFile!=null? Image.file(
                cubit.imgFile!, fit: BoxFit.cover,)
              :
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsData.imagePicking),
                    RegularTextWithLocalization(text: 'pickTheImage', fontSize: 16.sp, textColor: primaryColor, fontFamily: regular)

                  ],
                ),
              )
              ),
            ),

          ),
        );
      },

    );

  }
}
