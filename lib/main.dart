import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Features/NavBar/Presentation/Views/nav_bar_view.dart';
import 'package:wqaya/Features/NavBar/Presentation/view_model/bottom_nav_bar_cubit.dart';
import 'Core/bloc_observer/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'EG')],
      path: "assets/locals/translations",
      saveLocale: true,
      fallbackLocale: const Locale('ar', 'EG'),
      child: BlocProvider(
        create: (context) => BottomNavCubit(),
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
          home: NavBarView(), // Updated to use bottom navigation
        );
      },
    );
  }
}
