import 'package:flutter/material.dart';

import 'package:easywalk/util/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  AppTextStyles._();
  static const _defaultTextColor = AppColors.mainText;
  static const _defaultFontFamily = 'Inter';
  static const _size17Height = 21.0 / 17.0;
  static const _size16Height = 19.0 / 16.0;
  static const _size12Height = 15.0 / 12.0;
  static const _size10Height = 12.0 / 10.0;
  // static const _size20Height = 28.0 / 20.0;
  // static const _size18Height = 26.0 / 18.0;
  // static const _size15Height = 23.0 / 15.0;
  // static const _size14Height = 22.0 / 14.0;
  // static const _size10Height = 16.0 / 10.0;

  static var size17Bold = TextStyle(
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    height: _size17Height,
  );
  static var size16Bold = TextStyle(
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: _size16Height,
  );
  static var size12Regular = TextStyle(
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: _size12Height,
  );
  static var size10SemiBold = TextStyle(
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    height: _size10Height,
  );
}
