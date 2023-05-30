import 'package:device_preview/device_preview.dart';
import 'package:easywalk/modules/splash/binding/splash_binding.dart';
import 'package:easywalk/provider/routes/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return ScreenUtilInit(
      designSize: const Size(374, 780),
      builder: ((context, child) {
        return GetMaterialApp(
          getPages: Pages.routes,
          locale: DevicePreview.locale(context),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
            fontFamily: 'Inter',
          ),
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          initialRoute: "/splash",
          initialBinding: SplashBinding(),
          smartManagement: SmartManagement.full,
          navigatorKey: Get.key,
          builder: DevicePreview.appBuilder,
        );
      }),
    );
  }
}
