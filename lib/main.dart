import 'package:easywalk/modules/splash/binding/splash_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(374, 780),
      builder: ((context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
            fontFamily: 'Inter',
          ),
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          initialRoute: "/splash",
          initialBinding: SplashBinding(),
          smartManagement: SmartManagement.full,
          navigatorKey: Get.key,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          ),
        );
      }),
    );
  }
}
