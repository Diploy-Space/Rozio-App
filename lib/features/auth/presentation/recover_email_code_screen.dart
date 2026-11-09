import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/auth/presentation/recover_new_number_screen.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class RecoverEmailCodeScreen extends StatefulWidget {
  static const String routeName = '/recover-email-code';

  final String email;

  const RecoverEmailCodeScreen({
    super.key,
    this.email = 'rahul@gmail.com',
  });

  @override
  State<RecoverEmailCodeScreen> createState() => _RecoverEmailCodeScreenState();
}

class _RecoverEmailCodeScreenState extends State<RecoverEmailCodeScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _focusedIndex = 0;
  int _countdown = 26;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _focusedIndex = i;
          });
        }
      });
    }

    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _countdown = 26;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredCode => _otpControllers.map((c) => c.text).join();
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

  void _onVerify() {
    if (!_isComplete) return;
    context.push(RecoverNewNumberScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final timerText = '0:${_countdown.toString().padLeft(2, '0')}';

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
                                'Check your email.',
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
                                    'Sent to ${widget.email} ',
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
                                        context.pop();
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

                              // 6-digit OTP Input Boxes (Frame A18: 1st box highlighted with blue border)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  final isFocused = _focusedIndex == index;
                                  final hasValue =
                                      _otpControllers[index].text.isNotEmpty;

                                  Color borderColor;
                                  Color bgColor;

                                  if (isFocused) {
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
                                        width: isFocused ? 1.5 : 1.0,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: _otpControllers[index],
                                      focusNode: _focusNodes[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c111827,
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

                              UIHelper.verticalSpace(14.h),

                              // Action Row: "Didn't get the code? Resend in 0:26"
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
                                  if (_countdown > 0)
                                    Text(
                                      'Resend in $timerText',
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c6B7280,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: _startTimer,
                                      child: Text(
                                        'Resend code',
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

                              const Spacer(),
                              UIHelper.verticalSpace(16.h),

                              // Bottom Pinned Button: "Verify and continue"
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: _isComplete ? _onVerify : null,
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
