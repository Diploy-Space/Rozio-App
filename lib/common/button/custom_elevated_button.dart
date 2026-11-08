

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:jacob_app/util/app_colors/app_colors.dart';
// import 'package:jacob_app/util/text_style/app_text_style.dart';

// // class CustomElevatedButton extends StatelessWidget {
// //   final VoidCallback onPressed;
// //   final String? text;
// //   final Widget? child;
// //   final Color? backgroundColor;
// //   final Color textColor;
// //   final double borderRadius;
// //   final TextStyle? textStyle;
// //   final double height;
// //   final double width;
// //   final bool isExistIcon;
// //   final String? iconPath;
// //   final bool ? isBorder;
// //
// //   const CustomElevatedButton({
// //     super.key,
// //     required this.onPressed,
// //     this.text,
// //     this.child,
// //     this.textColor = Colors.white,
// //     this.borderRadius = 8,
// //     this.height = 50,
// //     this.width = double.infinity,
// //     this.isExistIcon = false,
// //     this.iconPath,
// //     this.backgroundColor,
// //     this.textStyle,
// //     this.isBorder = false
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: width,
// //       height: height.h,
// //       child: ElevatedButton(
// //         onPressed: onPressed,
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: backgroundColor ?? AppColors.btnColor,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(borderRadius.r),
// //           ),
// //           elevation: 0,
// //         ),
// //         child: child ??
// //             (isExistIcon && iconPath != null
// //                 ? Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Image.asset(
// //                   iconPath!,
// //                   height: 20.h,
// //                   width: 20.w,
// //                 ),
// //                 SizedBox(width: 8.w),
// //                 Text(
// //                   text ?? '',
// //                   style: AppTextStyle.body14(color: textColor),
// //                 ),
// //               ],
// //             )
// //                 : Text(
// //               text ?? '',
// //               style: textStyle ??
// //                   AppTextStyle.body16(
// //                       color: textColor, fontWeight: FontWeight.w600),
// //             )),
// //       ),
// //     );
// //   }
// // }

// class CustomElevatedButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final String? text;
//   final Widget? child;

//   final Color? backgroundColor;
//   final Color textColor;
//   final Color borderColor;

//   final double borderRadius;
//   final TextStyle? textStyle;
//   final double height;
//   final double width;

//   final bool isExistIcon;
//   final String? iconPath;
//   final bool isBorder;

//   const CustomElevatedButton({
//     super.key,
//     required this.onPressed,
//     this.text,
//     this.child,
//     this.backgroundColor,
//     this.textColor = Colors.white,
//     this.borderColor = Colors.black,
//     this.borderRadius = 8,
//     this.height = 50,
//     this.width = double.infinity,
//     this.isExistIcon = false,
//     this.iconPath,
//     this.textStyle,
//     this.isBorder = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width == double.infinity ? width : width.w,
//       height: height.h,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           elevation: 0,

//           /// 👉 Background
//           backgroundColor: isBorder
//               ? Colors.transparent
//               : (backgroundColor ?? AppColors.allPrimaryColor),

//           /// 👉 Border
//           side: isBorder
//               ? BorderSide(color: borderColor, width: 1.w)
//               : BorderSide.none,

//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius.r),
//           ),
//         ),
//         child: child ??
//             (isExistIcon && iconPath != null
//                 ? Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   iconPath!,
//                   height: 20.h,
//                   width: 20.w,
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   text ?? '',
//                   style: AppTextStyle.body14(
//                     color: isBorder ? borderColor : textColor,
//                   ),
//                 ),
//               ],
//             )
//                 : Text(
//               text ?? '',
//               style: textStyle ??
//                   AppTextStyle.body16(
//                     color: isBorder ? borderColor : textColor,
//                     fontWeight: FontWeight.w600,
//                   ).copyWith(fontSize: 14.sp),
//             )),
//       ),
//     );
//   }
// }
