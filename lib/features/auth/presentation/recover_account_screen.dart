import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/auth/presentation/recover_email_code_screen.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class RecoverAccountScreen extends StatefulWidget {
  static const String routeName = '/recover-account';

  const RecoverAccountScreen({super.key});

  @override
  State<RecoverAccountScreen> createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'rahul@gmail.com');
  final FocusNode _emailFocus = FocusNode();

  bool get _isValidEmail {
    final text = _emailController.text.trim();
    return text.isNotEmpty && text.contains('@') && text.contains('.');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _onSendCode() {
    if (!_isValidEmail) return;
    context.push(
      RecoverEmailCodeScreen.routeName,
      extra: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Top 38% Artwork with Back Button
            SizedBox(
              height: 0.38.sh,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: LocationHeaderArtwork(
                      type: HeaderArtworkType.pinBox,
                      height: 0.38.sh,
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8.h,
                    left: 16.w,
                    child: GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.pop();
                        }
                      },
                      child: Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom 62% White Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.r),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 16.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 44.h,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                'Recover your account.',
                                style: TextStyle(
                                  fontFamily: 'Geist',
                                  color: AppColors.c111827,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              UIHelper.verticalSpace(6.h),

                              // Subtitle
                              Text(
                                "Lost or changed your number? Enter the email on your Rozio account. We'll send a code to confirm it's you.",
                                style: TextStyle(
                                  fontFamily: 'Geist',
                                  color: const Color(0xFF4B5563),
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                              ),
                              UIHelper.verticalSpace(22.h),

                              // Input Label
                              Text(
                                'Email on your account',
                                style: TextStyle(
                                  fontFamily: 'Geist',
                                  color: const Color(0xFF374151),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              UIHelper.verticalSpace(6.h),

                              // Email Input Box
                              Container(
                                height: 52.h,
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: _emailFocus.hasFocus
                                        ? AppColors.c1847C9
                                        : const Color(0xFFD1D5DB),
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    color: AppColors.c111827,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email address',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Geist',
                                      color: const Color(0xFF9CA3AF),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),

                              UIHelper.verticalSpace(16.h),

                              // Primary Send Code Button
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: _isValidEmail ? _onSendCode : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.c1847C9,
                                    disabledBackgroundColor:
                                        const Color(0xFFD2D6DC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Send code',
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),
                              UIHelper.verticalSpace(20.h),

                              // Bottom Fallback Support Note
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.c6B7280,
                                        size: 15.sp,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: const Color(0xFF4B5563),
                                            fontSize: 12.sp,
                                            height: 1.35,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'No email on your account? ',
                                            ),
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline:
                                                  TextBaseline.alphabetic,
                                              child: GestureDetector(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Opening Rozio Support Desk...',
                                                        style: TextStyle(
                                                          fontFamily: 'Geist',
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          AppColors.c1847C9,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Contact support',
                                                  style: TextStyle(
                                                    fontFamily: 'Geist',
                                                    color: AppColors.c1847C9,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  " with an order ID and we'll verify you.",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              UIHelper.verticalSpace(8.h),

                              // Home bar indicator
                              Center(
                                child: Container(
                                  width: 134.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF111827),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
