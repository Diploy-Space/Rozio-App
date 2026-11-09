import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_assets/assets_image.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/location/presentation/location_screen.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class ChoseLanguageScreen extends StatefulWidget {
  static const String routeName = '/chose-language';

  const ChoseLanguageScreen({super.key});

  @override
  State<ChoseLanguageScreen> createState() => _ChoseLanguageScreenState();
}

class _ChoseLanguageScreenState extends State<ChoseLanguageScreen> {
  final List<Map<String, dynamic>> _languages = [
    {'nativeName': 'English', 'englishName': 'English'},
    {'nativeName': 'हिन्दी', 'englishName': 'Hindi'},
    {'nativeName': 'मराठी', 'englishName': 'Marathi'},
    {'nativeName': 'বাংলা', 'englishName': 'Bengali'},
    {'nativeName': 'தமிழ்', 'englishName': 'Tamil'},
    {'nativeName': 'తెలుగు', 'englishName': 'Telugu'},
    {'nativeName': 'ગુજરાતી', 'englishName': 'Gujarati'},
    {'nativeName': 'ಕನ್ನಡ', 'englishName': 'Kannada'},
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selected = _languages[_selectedIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.cFFFFFF,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.c011447,
        body: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: AppColors.c011447),
            Image.asset(
              AssetsImages.splashBg,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cFFFFFF,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          UIHelper.kDefaulutPadding(),
                          28.h,
                          UIHelper.kDefaulutPadding(),
                          16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              'Product names, prices and updates show in this language.',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                color: AppColors.c6B7280,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                            UIHelper.verticalSpace(22.h),
                            Expanded(child: _buildLanguageGrid()),
                            UIHelper.verticalSpace(12.h),
                            _buildContinueButton(selected['englishName']),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Choose your language',
            style: TextStyle(
              fontFamily: 'Geist',
              color: AppColors.c111827,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(
              fontFamily: 'Geist',
              color: AppColors.c1847C9,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: _languages.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = _languages[index];
        final isSelected = index == _selectedIndex;

        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cFFFFFF : AppColors.cF3F4F6,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? AppColors.c1847C9 : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['nativeName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Geist',
                        color: AppColors.c111827,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    UIHelper.verticalSpace(4.h),
                    Text(
                      item['englishName'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Geist',
                        color: AppColors.c6B7280,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: const BoxDecoration(
                        color: AppColors.c1847C9,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 14.sp,
                        color: AppColors.cFFFFFF,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(String languageName) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () {
          context.go(LocationScreen.routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.c1847C9,
          foregroundColor: AppColors.cFFFFFF,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          'Continue in $languageName',
          style: TextStyle(
            fontFamily: 'Geist',
            color: AppColors.cFFFFFF,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
