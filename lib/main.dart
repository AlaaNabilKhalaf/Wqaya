import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/cache/cache_helper.dart';
import 'package:wqaya/Features/Analysis/Presentation/views/view_model/analysis_cubit.dart';
import 'package:wqaya/Features/Auth/Presentation/Views/view_model/auth_cubit.dart';
import 'package:wqaya/Features/Home/Presentation/Views/view_model/home_cubit.dart';
import 'package:wqaya/Features/Medicine/presentation/views/view_model/medicine_cubit.dart';
import 'package:wqaya/Features/NavBar/Presentation/Views/nav_bar_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_bar_cubit.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_visibility__cubit.dart';
import 'package:wqaya/Features/Rays/presentation/views/view_model/ray_cubit.dart';
import 'package:wqaya/Features/Splash/Presentation/Views/splash_view.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/models/surgery_models.dart';
import 'package:wqaya/Features/surgries/presentation/views/view_model/surgery_cubit.dart';
import 'Core/bloc_observer/bloc_observer.dart';
import 'Features/Profile/Controller/profile_image_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheHelper().init();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'EG')],
      path: "assets/locals/translations",
      saveLocale: true,
      fallbackLocale: const Locale('ar', 'EG'),
      child: MultiBlocProvider(providers: [

        BlocProvider<BottomNavCubit>(
          create: (context) => BottomNavCubit(),),
        BlocProvider<BottomNavVisibilityCubit>(
          create: (context) => BottomNavVisibilityCubit(),),
        BlocProvider<ProfileImageCubit>(
            create: (context) => ProfileImageCubit()),
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit()),
        BlocProvider<HomeCubit>(
            create: (context) => HomeCubit()),
        BlocProvider<RayCubit>(
            create: (context) => RayCubit()),
        BlocProvider<MedicineCubit>(
            create: (context) => MedicineCubit())
        ,BlocProvider<AnalysisCubit>(
            create: (context) => AnalysisCubit()),
        BlocProvider<SurgeryCubit>(
          create: (context) => SurgeryCubit(
            surgeryRepository: SurgeryRepository(),
          ),
        ),
      ],
        child: const Wqaya(),
      ),
    ),
  );
}

class Wqaya extends StatelessWidget {
  const Wqaya({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return ScreenUtilInit(
      enableScaleWH: () => false,
      enableScaleText: () => false,
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: const Locale('ar', 'EG'),
          // Force Arabic
          debugShowCheckedModeBanner: false,
          home: CacheHelper().getData(key: 'token').toString().isNotEmpty? const NavBarView() :const SplashView(), // Updated to use bottom navigation
        );
      },
    );
  }
}
