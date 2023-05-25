import 'package:easywalk/modules/home/view/home_view.dart';
import 'package:easywalk/provider/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/splash/view/splash_view.dart';

class Pages {
  static final routes = [
    GetPage(
      title: "스플래시 화면",
      name: Routes.splash,
      page: () => const SplashScreen(),
      transition: Transition.noTransition,
      curve: Curves.easeIn,
      popGesture: false,
    ),
    GetPage(
      title: "홈 화면",
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.noTransition,
      curve: Curves.easeIn,
      popGesture: false,
    )
  ];
}
