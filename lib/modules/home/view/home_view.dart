import 'package:easywalk/modules/home/controller/home_controller.dart';
import 'package:easywalk/modules/home/widget/home_widget.dart';
import 'package:easywalk/provider/api/directions_api.dart';
import 'package:easywalk/util/global_colors.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(children: [
          Positioned(
            child: GoogleMap(
              zoomControlsEnabled: false,
              markers: controller.markers,
              onMapCreated: ((GoogleMapController mapController) {
                controller.googleMapController = mapController;
              }),
              polylines: Set<Polyline>.of(controller.polylines.values),
              initialCameraPosition: CameraPosition(
                target: controller.initialPosition.value, // 초기 지도 위치 설정
                zoom: 13.0,
              ),
            ),
          ),
          Stack(
            children: [
              Image.asset(
                "assets/images/container/bg_header_purple.png",
                width: 400.w,
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
                    Text(
                        "EASY WALK는 다양한 경로를 통해\n목적지까지 안전하게 도착할 수 있도록 서비스를 제공합니다.",
                        style: AppTextStyles.size10SemiBold.copyWith(
                          color: AppColors.white,
                        ))
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 170.h,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              width: 330.w,
              height: 130.h,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainPrimary),
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 246.w,
                        height: 28.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                "assets/images/icon/ic_search_20.svg"),
                            SizedBox(
                              width: 30.w,
                            ),
                            Expanded(
                              child: TextField(
                                controller:
                                    controller.startDestinationController.value,
                                style: AppTextStyles.size12Regular,
                                onSubmitted: ((value) async {
                                  var convertedLocation = await controller
                                      .convertAddressToCoordinates(value);
                                  controller.startLocation =
                                      convertedLocation ??
                                          Location(
                                              latitude: 0,
                                              longitude: 0,
                                              timestamp: DateTime.now());
                                }),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "출발지를 입력해주세요",
                                  hintStyle: AppTextStyles.size12Regular
                                      .copyWith(
                                          color: AppColors.hintText,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Container(
                        height: 1.h,
                        width: 230.w,
                        color: AppColors.mainPrimary,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      SizedBox(
                        width: 246.w,
                        height: 28.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                "assets/images/icon/ic_map_20.svg"),
                            SizedBox(
                              width: 30.w,
                            ),
                            Expanded(
                              child: TextField(
                                controller:
                                    controller.endDestinationController.value,
                                style: AppTextStyles.size12Regular,
                                onSubmitted: ((value) async {
                                  final convertedLocation = await controller
                                      .convertAddressToCoordinates(value);
                                  controller.endLocation = convertedLocation ??
                                      Location(
                                          latitude: 0,
                                          longitude: 0,
                                          timestamp: DateTime.now());
                                }),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "도착지를 입력해주세요",
                                  hintStyle: AppTextStyles.size12Regular
                                      .copyWith(
                                          color: AppColors.hintText,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      var polyline = await DirectionApi.getDirections(
                          controller.startLocation?.latitude ?? 0,
                          controller.startLocation?.latitude ?? 0,
                          controller.startLocation?.latitude ?? 0,
                          controller.startLocation?.latitude ?? 0,
                          TravelMode.walking);
                      controller.polylines[polyline.polylineId] = polyline;
                    },
                    child: SvgPicture.asset(
                      "assets/images/icon/ic_next_28.svg",
                      width: 28.w,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
