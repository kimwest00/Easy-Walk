import 'package:easywalk/util/global_colors.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RoadMapContainer extends StatelessWidget {
  final Rx<TextEditingController> startDestinationController;
  final Rx<TextEditingController> endDestinationController;
  const RoadMapContainer(
      {super.key,
      required this.startDestinationController,
      required this.endDestinationController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainPrimary),
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.white),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/images/icon/ic_search_20.svg"),
                  SizedBox(
                    width: 70.w,
                  ),
                  TextField(
                    controller: startDestinationController.value,
                    style: AppTextStyles.size12Regular,
                    decoration: InputDecoration(
                      border: null,
                      hintText: "출발지를 입력해주세요",
                      hintStyle: AppTextStyles.size12Regular.copyWith(
                          color: AppColors.hintText,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Divider(
                thickness: 1.h,
                color: AppColors.mainborder,
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                children: [
                  SvgPicture.asset("assets/images/icon/ic_map_20.svg"),
                  SizedBox(
                    width: 70.w,
                  ),
                  TextField(
                    controller: endDestinationController.value,
                    decoration: InputDecoration(
                      hintText: "도착지를 입력해주세요",
                      hintStyle: AppTextStyles.size12Regular.copyWith(
                          color: AppColors.hintText,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            width: 30.w,
          ),
          SvgPicture.asset("assets/images/icon/ic_next_20.svg")
        ],
      ),
    );
  }
}
