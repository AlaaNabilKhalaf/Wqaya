import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wqaya/Features/Splash/Presentation/Views/splash_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Core/bloc_observer/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  // await CacheNetwork.cacheInitialization();
  await ScreenUtil.ensureScreenSize();
  runApp(const Wqaya());
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
          return const MaterialApp(
            locale: Locale("ar"),
            debugShowCheckedModeBanner: false,
            home:SplashView(),);
   },
    );}}
