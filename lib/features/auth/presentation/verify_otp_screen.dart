import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/auth/presentation/login_screen.dart';
import 'package:rozio_app/features/auth/presentation/recover_account_screen.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class VerifyOtpScreen extends StatefulWidget {
  static const String routeName = '/verify-otp';

  final String phoneNumber;
  final bool initialLocked;

  const VerifyOtpScreen({
    super.key,
    this.phoneNumber = '+91 98765 43210',
    this.initialLocked = true, // Defaults to Frame A16 locked state as requested in Figma
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late bool _isLocked;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _isLocked = widget.initialLocked;

    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _focusedIndex = i;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredCode =>
      _otpControllers.map((c) => c.text).join();

  bool get _isComplete => _enteredCode.length == 6;

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    setState(() {});
  }

  void _resetLockAndRequestCode() {
    setState(() {
      _isLocked = false;
      for (var c in _otpControllers) {
        c.clear();
      }
    });
    _focusNodes[0].requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'New code sent via SMS to ${widget.phoneNumber}',
          style: TextStyle(fontFamily: 'Geist', fontSize: 13.sp),
        ),
        backgroundColor: AppColors.c1847C9,
        behavior: SnackBarBehavior.floating,
      ),
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
            // Top 38% Artwork with Back Button and Status Bar
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

                  // Top App Bar Controls
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8.h,
                    left: 16.w,
                    right: 16.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(LoginScreen.routeName);
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

                        // Interactive Test Switcher (lets user toggle locked state on tap!)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLocked = !_isLocked;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: _isLocked
                                  ? const Color(0xFFEF4444).withValues(alpha: 0.25)
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: _isLocked
                                  ? const Color(0xFFEF4444)
                                  : Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isLocked
                                      ? Icons.lock_outline_rounded
                                      : Icons.lock_open_rounded,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _isLocked ? 'State: Locked' : 'State: Normal',
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                                'Enter the code.',
                                style: TextStyle(
                                  fontFamily: 'Geist',
                                  color: AppColors.c111827,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              UIHelper.verticalSpace(6.h),

                              // Subtitle with Change link
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Sent by SMS to ${widget.phoneNumber} ',
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c6B7280,
                                      fontSize: 13.5.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.35,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (context.canPop()) {
                                        context.pop();
                                      } else {
                                        context.go(LoginScreen.routeName);
                                      }
                                    },
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c1847C9,
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              UIHelper.verticalSpace(22.h),

                              // 6-digit OTP Input Boxes
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  final isFocused = _focusedIndex == index &&
                                      !_isLocked;
                                  final hasValue =
                                      _otpControllers[index].text.isNotEmpty;

                                  Color borderColor;
                                  Color bgColor;

                                  if (_isLocked) {
                                    borderColor = const Color(0xFFEF4444);
                                    bgColor = Colors.white;
                                  } else if (isFocused) {
                                    borderColor = AppColors.c1847C9;
                                    bgColor = Colors.white;
                                  } else if (hasValue) {
                                    borderColor = const Color(0xFFD1D5DB);
                                    bgColor = Colors.white;
                                  } else {
                                    borderColor = const Color(0xFFE5E7EB);
                                    bgColor = const Color(0xFFF9FAFB);
                                  }

                                  return Container(
                                    width: 44.w,
                                    height: 52.h,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: borderColor,
                                        width: (_isLocked || isFocused) ? 1.5 : 1.0,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: _otpControllers[index],
                                      focusNode: _focusNodes[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      enabled: !_isLocked,
                                      maxLength: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: _isLocked
                                            ? const Color(0xFFEF4444)
                                            : AppColors.c111827,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) =>
                                          _onDigitChanged(index, val),
                                    ),
                                  );
                                }),
                              ),

                              // Locked / Error Alert Row (Frame A16)
                              if (_isLocked) ...[
                                UIHelper.verticalSpace(10.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: const Color(0xFFEF4444),
                                        size: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        'Too many attempts. Get a new code to try again.',
                                        style: TextStyle(
                                          fontFamily: 'Geist',
                                          color: const Color(0xFFEF4444),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              UIHelper.verticalSpace(14.h),

                              // Action Row: "Didn't get the code? Get a new code"
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Didn't get the code?",
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c6B7280,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _resetLockAndRequestCode,
                                    child: Text(
                                      'Get a new code',
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c1847C9,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              UIHelper.verticalSpace(16.h),

                              // WhatsApp Code Option Box
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Sending OTP to ${widget.phoneNumber} on WhatsApp...',
                                        style: TextStyle(
                                            fontFamily: 'Geist', fontSize: 13.sp),
                                      ),
                                      backgroundColor: const Color(0xFF25D366),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 13.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // WhatsApp/Chat Icon
                                      Container(
                                        width: 22.w,
                                        height: 22.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF25D366),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.chat_bubble_rounded,
                                          color: Colors.white,
                                          size: 12.sp,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          'Get the code on WhatsApp',
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c111827,
                                            fontSize: 13.5.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: const Color(0xFF9CA3AF),
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              UIHelper.verticalSpace(16.h),

                              // Can't access this number? (Navigates to Frame A17 Recover Account)
                              GestureDetector(
                                onTap: () {
                                  context.push(RecoverAccountScreen.routeName);
                                },
                                child: Text(
                                  "Can't access this number?",
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    color: AppColors.c1847C9,
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const Spacer(),
                              UIHelper.verticalSpace(16.h),

                              // Bottom Pinned Button: "Verify and continue"
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: (!_isLocked && _isComplete)
                                      ? () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'OTP Verified successfully!',
                                                style: TextStyle(
                                                  fontFamily: 'Geist',
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                              backgroundColor: const Color(0xFF10B981),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      : null,
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
                                    'Verify and continue',
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
