

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle style({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    double height = 1.3,
    TextDecoration decoration = TextDecoration.none,
    Color? decorationColor,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor ?? color,
      decorationThickness: decorationThickness,
    );
  }

  // Ready-made styles
  static TextStyle heading34({
    FontWeight fontWeight = FontWeight.w700, // Roboto-Bold
    Color color = Colors.black,
  }) =>
      style(fontSize: 34.sp, fontWeight: fontWeight, color: color);

  static TextStyle title24({
    FontWeight fontWeight = FontWeight.w600, // Roboto-Bold
    Color color = Colors.black,
  }) =>
      style(fontSize: 24.sp, fontWeight: fontWeight, color: color);

  static TextStyle title18({
    FontWeight fontWeight = FontWeight.w600, // Roboto-Medium
    Color color = Colors.black,
  }) =>
      style(fontSize: 18.sp, fontWeight: fontWeight, color: color);

  static TextStyle body16({
    FontWeight fontWeight = FontWeight.w400, // Roboto-Regular
    Color color = Colors.black,
  }) =>
      style(fontSize: 16.sp, fontWeight: fontWeight, color: color);

  static TextStyle body14({
    FontWeight fontWeight = FontWeight.w400, // Roboto-Regular
    Color color = Colors.black,
  }) =>
      style(fontSize: 14.sp, fontWeight: fontWeight, color: color);


  // Optional SemiBold shortcut
  static TextStyle body16SemiBold({
    Color color = Colors.black,
  }) =>
      style(fontSize: 16.sp, fontWeight: FontWeight.w500, color: color); // Roboto-SemiBold

  // New Dark Theme Styles (Manrope equivalents using Roboto)
  static TextStyle get manrope14grey => style(fontSize: 14.sp, color: const Color(0xFF9C9BA6));
  static TextStyle get manrope18White600 => style(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w600);
  static TextStyle get manrope14Pink500 => style(fontSize: 14.sp, color: const Color(0xFFFF57B9), fontWeight: FontWeight.w500);
  static TextStyle get manrope16White600 => style(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w600);
  static TextStyle get manrope12grey => style(fontSize: 12.sp, color: const Color(0xFF9C9BA6));

  // Refined Styles for Home UI
  static TextStyle get headerSubtitle => style(fontSize: 14.sp, color: Colors.white70, fontWeight: FontWeight.w400);
  static TextStyle get pointsText => style(fontSize: 14.sp, color: const Color(0xFF00C814), fontWeight: FontWeight.w700);
  static TextStyle get calendarSelectedDay => style(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w700);
  static TextStyle get calendarUnselectedDay => style(fontSize: 14.sp, color: Colors.white38, fontWeight: FontWeight.w400);
}
