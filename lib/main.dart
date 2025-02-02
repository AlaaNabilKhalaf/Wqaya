import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wqaya/Features/Splash/Presentation/Views/splash_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Core/bloc_observer/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  // await CacheNetwork.cacheInitialization();
  await ScreenUtil.ensureScreenSize();
  runApp(
      EasyLocalization(
      supportedLocales: const [Locale('ar', 'EG')],
      path: "assets/locals/translations",
      saveLocale: true,
      fallbackLocale: const Locale('ar', 'EG'),
      child: const Wqaya()));
}

class Wqaya extends StatelessWidget {
  const Wqaya({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // This Method is controlling the status bar appearance.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return
      ScreenUtilInit(
        enableScaleWH: ()=>false,
        enableScaleText: ()=>false,
        designSize: const Size(393, 852),
    minTextAdapt: true,
    splitScreenMode: true,
   builder: ( _ , child ){
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            home:const SplashView(),);
   },
    );}}
