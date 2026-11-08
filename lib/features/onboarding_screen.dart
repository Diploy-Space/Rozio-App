import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_assets/assets_image.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/constants/text_fonts_style.dart';
import 'package:rozio_app/features/chose_language/presentation/chose_language_screen.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> splash = [
    {
      'imagePath': AssetsImages.splashScreenImage1,
      'title': 'Online shopping',
      'description':
          'Browse thousands of products from your favorite categories and shop anytime, anywhere with just a few taps.',
    },
    {
      'imagePath': AssetsImages.splashScreenImage2,
      'title': 'Wholesaler',
      'description':
          'Buy in bulk directly from trusted wholesalers and get the best prices for your business or your home.',
    },
    {
      'imagePath': AssetsImages.splashScreenImage3,
      'title': '30 minutes delivery',
      'description':
          'Order now and get your products at your doorstep within 30 minutes, fast and fresh.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToChoseLanguage() {
    context.go(ChoseLanguageScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.c011447,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          color: AppColors.c011447,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(),
              ),
              child: Column(
                children: [
                  UIHelper.verticalSpace(8.h),
                  _buildHeader(),
                  Expanded(
                    child: NotificationListener<OverscrollNotification>(
                      onNotification: (notification) {
                        if (_currentIndex == splash.length - 1 &&
                            notification.overscroll > 0) {
                          _goToChoseLanguage();
                        }
                        return false;
                      },
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: splash.length,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemBuilder: (context, index) {
                          final isLast = index == splash.length - 1;
                          return GestureDetector(
                            onTap: isLast ? _goToChoseLanguage : null,
                            behavior: HitTestBehavior.opaque,
                            child: _buildSplashPage(splash[index]),
                          );
                        },
                      ),
                    ),
                  ),
                  _buildPageIndicator(),
                  UIHelper.verticalSpace(24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (_currentIndex > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            width: 52.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.c0A0B0E,
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.cFFFFFF,
              size: 20.sp,
            ),
          ),
        ),
        GestureDetector(
          onTap: _goToChoseLanguage,
          child: Container(
            width: 65.w,
            height: 34.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.c0A0B0E,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Text(
              'Skip',
              style: TextFontStyle.textStylec28cGeist600cFFFFFF.copyWith(
                color: AppColors.cFFFFFF,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSplashPage(Map<String, dynamic> item) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Image.asset(
              item['imagePath'],
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Text(
          item['title'],
          textAlign: TextAlign.center,
          style: TextFontStyle.textStylec28cGeist600cFFFFFF.copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        UIHelper.verticalSpace(12.h),
        Text(
          item['description'],
          textAlign: TextAlign.center,
          style: TextFontStyle.textStylec28cGeist600cFFFFFF.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.cD5D5D5,
            height: 1.4,
          ),
        ),
        UIHelper.verticalSpace(28.h),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(splash.length, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 24.w : 8.w,
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(8.r),
          ),
        );
      }),
    );
  }
}
