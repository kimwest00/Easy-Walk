import 'package:easywalk/util/global_colors.dart';
import 'package:easywalk/util/global_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ResultListTile extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String icon;
  final String transport;
  final String time;
  final bool isBest;
  const ResultListTile(
      {super.key,
      required this.backgroundColor,
      required this.icon,
      required this.transport,
      required this.time,
      required this.textColor,
      this.isBest = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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

  factory ResultListTile.mainTileSubway({required String time}) {
    return ResultListTile(
        backgroundColor: AppColors.mainPrimary,
        icon: "subway_30",
        transport: "지하철",
        isBest: true,
        time: time,
        textColor: AppColors.white);
  }
  factory ResultListTile.mainTileBus({required String time}) {
    return ResultListTile(
        backgroundColor: AppColors.mainPrimary,
        icon: "bus_30",
        transport: "버스",
        isBest: true,
        time: time,
        textColor: AppColors.white);
  }
  factory ResultListTile.primaryTileBus({required String time}) {
    return ResultListTile(
        backgroundColor: AppColors.white,
        icon: "bus_30",
        transport: "버스",
        time: time,
        textColor: AppColors.mainPrimary);
  }
  factory ResultListTile.primaryTileSubway({required String time}) {
    return ResultListTile(
        backgroundColor: AppColors.white,
        icon: "subway_30",
        transport: "지하철",
        time: time,
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

List<String> titleList = ['전체', '버스', '지하철', '도보'];

class DirectionBottomSheet extends StatelessWidget {
  final RxInt selectType;
  const DirectionBottomSheet({super.key, required this.selectType});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child: Column(
      children: [
        Row(
          children: List.generate(
              titleList.length,
              (index) => TypeChip(
                    text: titleList[index],
                    isSelect: index == selectType ? true : false,
                  )),
        ),
        SizedBox(
          height: 13.h,
        ),
        ListView.separated(
            itemBuilder: ((context, index) {}),
            separatorBuilder: ((context, index) {
              return SizedBox(
                height: 10.h,
              );
            }),
            itemCount: itemCount)
      ],
    )));
  }
}
