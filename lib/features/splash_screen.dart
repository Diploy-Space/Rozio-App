import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rozio_app/constants/app_assets/assets_image.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Get.offAllNamed(OnboardingScreen.routeName);
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.c011447,
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: AppColors.c011447),
              Image.asset(
                AssetsImages.splashBg,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 5),
                    _buildBrand(),
                    const Spacer(flex: 5),
                    _buildProgressBar(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 92.w,
          height: 92.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Text(
            'R',
            style: TextStyle(
              fontFamily: 'Geist',
              color: AppColors.c011447,
              fontSize: 52.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Rozio',
          style: TextStyle(
            fontFamily: 'Geist',
            color: AppColors.cFFFFFF,
            fontSize: 34.sp,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return SizedBox(
          width: 68.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: LinearProgressIndicator(
              value: _progressController.value,
              minHeight: 3.h,
              backgroundColor: AppColors.cFFFFFF.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.cFFFFFF,
              ),
            ),
          ),
        );
      },
    );
  }
}
