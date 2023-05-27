import 'package:card_swiper/card_swiper.dart';
import 'package:easywalk/modules/splash/controller/splash_controller.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/global_colors.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 160.h),
        child: Swiper(
          // indicatorLayout: PageIndicatorLayout.DROP,
          pagination: SwiperPagination(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            builder: DotSwiperPaginationBuilder(
                color: AppColors.deactiveIcon,
                activeColor: AppColors.mainPrimary,
                size: 7.h,
                activeSize: 7.h),
          ),
          itemCount: 3,
          itemBuilder: ((context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/illust/description_${index + 1}.png",
                    height: 284.h,
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
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (() async {
                            await Get.toNamed('/home');
                          }),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
                              "시작하기",
                              //TODO: textstyle 수정
                              style: AppTextStyles.size16Bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //TODO: 맨마지막 인덱스에 도달했을때 버튼 visible 처리
                  //TODO: pagination 1-way만 가능하게
                  index == 2
                      ? Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (() async {
                                  await Get.toNamed('/home');
                                }),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Text(
                                    "시작하기",
                                    //TODO: textstyle 수정
                                    style: AppTextStyles.size16Bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
