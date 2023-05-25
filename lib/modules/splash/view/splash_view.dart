import 'package:card_swiper/card_swiper.dart';
import 'package:easywalk/modules/splash/controller/splash_controller.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Swiper(
          // indicatorLayout: PageIndicatorLayout.DROP,
          itemCount: 3,
          itemBuilder: ((context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/illust/description_${index + 1}.png",
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Text(
                    controller.titleList[index],
                    style: AppTextStyles.size17Bold,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    controller.contentList[index],
                    style: AppTextStyles.size12Regular,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
