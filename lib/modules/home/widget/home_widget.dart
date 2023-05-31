import 'package:easywalk/model/Trasnport.dart';
import 'package:easywalk/util/global_colors.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../provider/api/directions_api.dart';

class ResultListTile extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String icon;
  final String transport;
  final int time;
  final bool isBest;
  final PathInform? path;
  const ResultListTile(
      {super.key,
      required this.backgroundColor,
      required this.icon,
      required this.transport,
      required this.time,
      required this.textColor,
      this.isBest = false,
      this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 8),
            color: AppColors.shadowPrimary,
            blurRadius: 4.r,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/images/icon/ic_${icon}.svg"),
          SizedBox(
            width: 27.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isBest
                  ? Text(
                      "최적의 경로",
                      style: AppTextStyles.size16Bold.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.white),
                    )
                  : const SizedBox.shrink(),
              Text(
                "$transport $time분",
                style: AppTextStyles.size16Bold.copyWith(
                    fontWeight: FontWeight.w300,
                    color: isBest ? AppColors.white : textColor),
              ),
            ],
          )
        ],
      ),
    );
  }

  factory ResultListTile.mainTileSubway({required PathInform path}) {
    return ResultListTile(
        backgroundColor: AppColors.mainPrimary,
        icon: "subway_33",
        transport: "지하철",
        isBest: true,
        time: path.totalTime,
        textColor: AppColors.white);
  }
  // factory ResultListTile.mainTileBus({required String time}) {
  //   return ResultListTile(
  //       backgroundColor: AppColors.mainPrimary,
  //       icon: "bus_30",
  //       transport: "버스",
  //       isBest: true,
  //       time: time,
  //       textColor: AppColors.white);
  // }
  factory ResultListTile.primaryTileBus({required PathInform path}) {
    return ResultListTile(
        backgroundColor: AppColors.white,
        icon: "bus_33",
        transport: "버스",
        time: path.totalTime,
        textColor: AppColors.mainPrimary);
  }
  factory ResultListTile.primaryTileSubway({required PathInform path}) {
    return ResultListTile(
        backgroundColor: AppColors.white,
        icon: "subway_33",
        transport: "지하철",
        time: path.totalTime,
        textColor: AppColors.mainPrimary);
  }
  factory ResultListTile.busandSubway({required PathInform path}) {
    return ResultListTile(
        backgroundColor: AppColors.white,
        icon: "subway_33",
        transport: "버스 + 지하철",
        time: path.totalTime,
        textColor: AppColors.mainPrimary);
  }
}

class TypeChip extends StatelessWidget {
  final String text;
  final bool isSelect;
  const TypeChip({super.key, required this.text, this.isSelect = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 9.h),
      decoration: BoxDecoration(
          color: isSelect ? AppColors.mainPrimary : AppColors.white,
          borderRadius: BorderRadius.circular(15.r)),
      child: Text(
        text,
        style: AppTextStyles.size10SemiBold.copyWith(
          fontWeight: FontWeight.w400,
          color: isSelect ? AppColors.white : AppColors.mainPrimary,
        ),
      ),
    );
  }
}

List<String> titleList = ['전체', '지하철', '버스', '도보'];

class DirectionBottomSheet extends StatelessWidget {
  final RxInt selectType;
  final RxList<PathInform>? pathInform;
  final Location startLocation;
  final Location endLocation;
  final double? duration;
  const DirectionBottomSheet(
      {Key? key,
      required this.selectType,
      required this.pathInform,
      required this.startLocation,
      required this.endLocation,
      this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rx<bool> isWalk = false.obs;
    Rx<int> time = 0.obs;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 23.h, horizontal: 35.w),
        color: AppColors.white,
        height: 330.h,
        child: Builder(
          builder: ((context) {
            return Obx(
              () => Column(
                children: [
                  Row(
                    children: List.generate(
                        titleList.length,
                        (index) => GestureDetector(
                              onTap: () async {
                                selectType.value = index;
                                if (index != 3) {
                                  pathInform!.value =
                                      await DirectionApi.getPublicDirection(
                                              startLocation,
                                              endLocation,
                                              index) ??
                                          [];
                                  isWalk.value = false;
                                } else {
                                  pathInform!.clear();
                                  time.value =
                                      await DirectionApi.calculateWalkingRoute(
                                              startLocation, endLocation) ??
                                          0;
                                  isWalk.value = true;
                                }
                              },
                              child: TypeChip(
                                text: titleList[index],
                                isSelect:
                                    index == selectType.value ? true : false,
                              ),
                            )),
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  !isWalk.value
                      ? SingleChildScrollView(
                          child: SizedBox(
                              height: 229.h,
                              child:
                                  // selectType.value!=3?
                                  ListView.separated(
                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: ((context, index) {
                                        if (pathInform![index].pathType == 1) {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.bottomSheet(RoadResultCard(
                                                transportDetails:
                                                    pathInform![index],
                                              ));
                                            },
                                            child: ResultListTile
                                                .primaryTileSubway(
                                                    path: pathInform![index]),
                                          );
                                        } else if (pathInform![index]
                                                .pathType ==
                                            2) {
                                          return GestureDetector(
                                              onTap: () {
                                                Get.bottomSheet(RoadResultCard(
                                                  transportDetails:
                                                      pathInform![index],
                                                ));
                                              },
                                              child:
                                                  ResultListTile.primaryTileBus(
                                                      path:
                                                          pathInform![index]));
                                        } else {
                                          return GestureDetector(
                                              onTap: () {
                                                Get.bottomSheet(RoadResultCard(
                                                  transportDetails:
                                                      pathInform![index],
                                                ));
                                              },
                                              child:
                                                  ResultListTile.busandSubway(
                                                      path:
                                                          pathInform![index]));
                                        }
                                      }),
                                      separatorBuilder: ((context, index) {
                                        return SizedBox(
                                          height: 10.h,
                                        );
                                      }),
                                      itemCount: pathInform!.length)
                              // :ResultListTile(backgroundColor: AppColors.mainPrimary,icon: "people_30",time: ,),
                              ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: ResultListTile(
                              backgroundColor: AppColors.mainPrimary,
                              icon: "people_30",
                              transport: "도보",
                              time: time.value,
                              textColor: Colors.white))
                ],
              ),
            );
          }),
        ));
  }
}

class RoadResultCard extends StatelessWidget {
  final PathInform transportDetails;
  const RoadResultCard({super.key, required this.transportDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 314.h,
      width: 232.w,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 17.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x977FFACF),
            Color(0x977FFACF),
            Color(0xff7F59EA),
            Color(0xff5B2FCA)
          ],
        ),
      ),
      child: Column(children: [
        Row(
          children: [
            Text(
              "${transportDetails.totalTime}분",
              style: AppTextStyles.size16Bold
                  .copyWith(color: AppColors.white, fontSize: 15.sp),
            ),
            SizedBox(
              width: 9.w,
            ),
            Container(
              width: 238.w,
              height: 21.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Color(0xFFFFFFCC)),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: transportDetails.detail!.length,
                itemBuilder: ((context, index) {
                  var detail = transportDetails.detail![index];
                  return Container(
                    width: (238.w / transportDetails.totalTime) *
                        detail.sectionTime,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: detail.trafficType == 1
                            ? Color(0xff0066FF)
                            : detail.trafficType == 2
                                ? AppColors.mainPrimary
                                : Color(0xFFFFFFCC)),
                    child: Text(
                      "${detail.sectionTime}분",
                      style: AppTextStyles.size12Regular.copyWith(
                          color: detail.trafficType != 3
                              ? AppColors.white
                              : AppColors.mainText,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                separatorBuilder: (context, index) {
                  return Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                  );
                },
              ),
            )
          ],
        ),
        Container(
          height: 190.h,
          child: Column(
            children: List.generate(
                transportDetails.detail!.length,
                (index) => TrafficResultBus(
                      detail: transportDetails.detail![index],
                    )),
          ),
        )
      ]),
    );
  }
}

class TrafficResultBus extends StatelessWidget {
  final TransportDetail detail;
  const TrafficResultBus({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SvgPicture.asset("assets/images/icon/ic_bus_33.svg"),
            Expanded(
              child: Container(
                color: Colors.white,
                width: 2.w,
              ),
            )
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${detail.busNo} 버스 ${detail.startName} 승차"),
              Text("${detail.endName} 하차"),
            ],
          ),
        ],
      ),
    );
  }
}
