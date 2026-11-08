
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:jacob_app/util/app_colors/app_colors.dart';
// import 'package:jacob_app/util/text_style/app_text_style.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String hintText;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final FocusNode? focusNode;
//   final Function(String)? onChanged;
//   final Function(String)? onFieldSubmitted;
//   final String? Function(String?)? validator;
//   final TextEditingController? controller;
//   final IconData? prefixIcon;
//   final Widget? prefixWidget;
//   final bool obscureText;
//   final VoidCallback? onToggleVisibility;
//   final bool isPasswordFiled;
//   final Color? fillColor;
//   final Color? hintColor;
//   final Color? iconColor;
//   final Color? borderColor;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final IconData? suffixIcon;
//   final int? maxLines;
//   final Color? textColor;

//   const CustomTextFormField({
//     super.key,
//     required this.hintText,
//     this.keyboardType,
//     this.textInputAction,
//     this.focusNode,
//     this.onChanged,
//     this.onFieldSubmitted,
//     this.validator,
//     this.controller,
//     this.prefixIcon,
//     this.prefixWidget,
//     this.obscureText = false,
//     this.onToggleVisibility,
//     this.isPasswordFiled = false,
//     this.fillColor,
//     this.hintColor,
//     this.iconColor,
//     this.borderColor,
//     this.readOnly = false,
//     this.onTap,
//     this.suffixIcon,
//     this.maxLines = 1,
//     this.textColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       focusNode: focusNode,
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       onChanged: onChanged,
//       onFieldSubmitted: onFieldSubmitted,
//       validator: validator,
//       readOnly: readOnly,
//       onTap: onTap,
//       maxLines: maxLines,
//       cursorColor: iconColor ?? AppColors.allPrimaryColor,
//       style: AppTextStyle.body14(color: textColor ?? AppColors.c000000),
//       obscureText: isPasswordFiled ? obscureText : false,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: fillColor ?? AppColors.white,
//         hintText: hintText,
//         // ignore: deprecated_member_use
//         hintStyle: AppTextStyle.body14(color: hintColor ?? AppColors.c000000.withOpacity(0.5)),

//         // prefix icon logic
//         prefixIcon: prefixWidget ?? (prefixIcon != null
//             ? Icon(prefixIcon, size: 20.sp, color: iconColor ?? AppColors.c000000)
//             : null),

//         // suffix icon logic
//         suffixIcon: isPasswordFiled
//             ? IconButton(
//           onPressed: onToggleVisibility,
//           icon: Icon(
//             obscureText ? Icons.visibility_off : Icons.visibility,
//             size: 20.sp,
//             color: iconColor ?? AppColors.c000000,
//           ),
//         )
//             : (suffixIcon != null ? Icon(suffixIcon, size: 20.sp, color: iconColor ?? AppColors.c000000) : null),

//         // outline borders
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide(color: borderColor ?? AppColors.c000000, width: 0.5.w),
//         ),

//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide(color: borderColor ?? AppColors.allPrimaryColor, width: 1.w),
//         ),

//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide(color: Colors.red, width: 1.w),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.r),
//           borderSide: BorderSide(color: Colors.red, width: 1.5.w),
//         ),
//       ),
//     );
//   }
// }
