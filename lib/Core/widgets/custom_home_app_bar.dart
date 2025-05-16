import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/about_button.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_cubit.dart';
import 'package:wqaya/Features/Profile/Controller/profile_image_states.dart';


class HomeCustomAppBar extends StatelessWidget {
  const HomeCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileImageCubit>(context);

 return BlocBuilder<ProfileImageCubit,ProfileImageStates>(builder: (context, _){
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: myWhiteColor,
      leading:  Padding(
        padding: const EdgeInsets.only(right: 8.0,top: 5),
        child: InkWell(
          onTap: () {
            print(CacheHelper().getData(key: 'token'));
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            height: 110.h,width: 110.w,
            decoration:  BoxDecoration(
                color: const Color(0xff0094FD),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff0094FD),width: 1)
            ),
            child:  cubit.imgFile!=null? Image.file(
                cubit.imgFile!, fit: BoxFit.cover,)  : const Icon(Icons.person , color: myWhiteColor,size: 35,),
          ),
        ),
      ),
      title:  Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegularTextWithLocalization(
                text: 'name',
                fontSize: 15.sp,
                textColor: primaryColor,
                fontFamily: black,
              ),
              const SizedBox(height: 2,),

              RegularTextWithLocalization(
                text: 'address',
                fontSize: 13.sp,
                textColor: primaryColor,
                fontFamily: regular,
              ),
            ],
          ),
          const Spacer(),
          const AboutButton()
        ],
      ),
    );
  },);
  }
}
