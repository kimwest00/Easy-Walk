import 'package:card_swiper/card_swiper.dart';
import 'package:easywalk/modules/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemCount: 3,
        itemBuilder: ((context, index) {
          return Row(
            children: [
              Image.asset(
                "assets/images/illust/description_1.png",
              ),
              Text(controller.titleList[index]),
              Text(controller.contentList[index]),
            ],
          );
        }),
      ),
    );
  }
}
