import 'package:easywalk/modules/home/controller/home_controller.dart';
import 'package:easywalk/modules/home/widget/home_widget.dart';
import 'package:easywalk/util/global_colors.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(children: [
          GoogleMap(
            onMapCreated: ((GoogleMapController controller) {}),
            initialCameraPosition: CameraPosition(
              target: controller.initialPosition.value, // 초기 지도 위치 설정
              zoom: 13.0,
            ),
          ),
          Image.asset(
            "assets/images/container/bg_header_purple.png",
            width: 500.w,
          ),
          Positioned(
            top: 45.h,
            left: 20.w,
            child: Column(
              children: [
                Text(
                  "안녕하세요,  오늘 하루는 어떠신가요?",
                  style: AppTextStyles.size16Bold.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text("EASY WALK는 다양한 경로를 통해\n목적지까지 안전하게 도착할 수 있도록 서비스를 제공합니다.",
                    style: AppTextStyles.size10SemiBold.copyWith(
                      color: AppColors.white,
                    ))
              ],
            ),
          ),
          Positioned(
            top: 171.h,
            child: RoadMapContainer(
                startDestinationController:
                    controller.startDestinationController,
                endDestinationController: controller.endDestinationController),
          ),
        ]),
      ),
    );
  }
}
