import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Core/utils/colors.dart';
import 'package:wqaya/Core/utils/fonts.dart';
import 'package:wqaya/Core/widgets/texts.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_visibility__cubit.dart';
import 'package:wqaya/Features/OCR/presentation/views/ocr_view.dart';
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
        //  const AboutButton()
          Column(
            children: [
              const SizedBox(height: 2,),
              IconButton(onPressed: () {
                context.read<BottomNavVisibilityCubit>().hide();
                Navigator.of(context)
                    .push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const OCRView(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                ).then((_) {
                  context.read<BottomNavVisibilityCubit>().show();
                });
              }, icon: const Center(child: Icon(Icons.camera_alt_outlined,color: primaryColor,))),
            ],
          )
        ],
      ),
    );
  },);
  }
}
