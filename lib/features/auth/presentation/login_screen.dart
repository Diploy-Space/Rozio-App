import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

enum LoginVariant {
  standard, // "Log in or sign up."
  fromAddToBag, // "Log in to add to bag."
  loginAgain, // "Log in again."
}

enum LoginErrorState {
  none,
  invalidNumber, // "Enter a valid mobile number..."
  networkError, // "Couldn't send the code..."
}

class CountryItem {
  final String name;
  final String flag;
  final String dialCode;
  final int maxLength;

  const CountryItem({
    required this.name,
    required this.flag,
    required this.dialCode,
    this.maxLength = 10,
  });
}

const List<CountryItem> _kCountries = [
  CountryItem(name: 'India', flag: '🇮🇳', dialCode: '+91', maxLength: 10),
  CountryItem(name: 'Pakistan', flag: '🇵🇰', dialCode: '+92', maxLength: 10),
  CountryItem(name: 'United States', flag: '🇺🇸', dialCode: '+1', maxLength: 10),
  CountryItem(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44', maxLength: 10),
  CountryItem(name: 'United Arab Emirates', flag: '🇦🇪', dialCode: '+971', maxLength: 9),
  CountryItem(name: 'Saudi Arabia', flag: '🇸🇦', dialCode: '+966', maxLength: 9),
  CountryItem(name: 'Bangladesh', flag: '🇧🇩', dialCode: '+880', maxLength: 10),
  CountryItem(name: 'Canada', flag: '🇨🇦', dialCode: '+1', maxLength: 10),
];

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final LoginVariant variant;

  const LoginScreen({
    super.key,
    this.variant = LoginVariant.standard,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginVariant _currentVariant;
  LoginErrorState _errorState = LoginErrorState.none;
  final TextEditingController _phoneController = TextEditingController();
  CountryItem _selectedCountry = _kCountries[0]; // Default India +91
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _currentVariant = widget.variant;
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final text = _phoneController.text.trim();
    if (_selectedCountry.dialCode == '+91') {
      // Real-time Indian mobile prefix check (must start with 6, 7, 8 or 9)
      if (text.isNotEmpty && !['6', '7', '8', '9'].contains(text[0])) {
        setState(() {
          _errorState = LoginErrorState.invalidNumber;
          _isButtonEnabled = false;
        });
        return;
      }
    }

    if (_errorState == LoginErrorState.invalidNumber) {
      _errorState = LoginErrorState.none;
    }

    final isValid = text.length == _selectedCountry.maxLength;
    if (isValid != _isButtonEnabled || _errorState != LoginErrorState.none) {
      setState(() {
        _isButtonEnabled = isValid;
        if (!isValid) _errorState = LoginErrorState.none;
      });
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  'Select Country',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: AppColors.c111827,
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _kCountries.length,
                  separatorBuilder: (_, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _kCountries[index];
                    final isSelected = item.dialCode == _selectedCountry.dialCode;
                    return ListTile(
                      leading: Text(item.flag, style: TextStyle(fontSize: 24.sp)),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      trailing: Text(
                        item.dialCode,
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 15.sp,
                          color: AppColors.c1847C9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = item;
                          _phoneController.clear();
                          _errorState = LoginErrorState.none;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onGetOtp() {
    if (_errorState == LoginErrorState.networkError) {
      // Retry succeeds
      setState(() {
        _errorState = LoginErrorState.none;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'OTP sent successfully to ${_selectedCountry.dialCode} ${_phoneController.text}',
            style: TextStyle(fontFamily: 'Geist', fontSize: 13.sp),
          ),
          backgroundColor: AppColors.c1847C9,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP sent to ${_selectedCountry.dialCode} ${_phoneController.text}',
          style: TextStyle(fontFamily: 'Geist', fontSize: 13.sp),
        ),
        backgroundColor: AppColors.c1847C9,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getTitleText() {
    switch (_currentVariant) {
      case LoginVariant.fromAddToBag:
        return 'Log in to add to bag';
      case LoginVariant.loginAgain:
        return 'Log in again';
      case LoginVariant.standard:
        return 'Log in or sign up';
    }
  }

  String _getSubtitleText() {
    switch (_currentVariant) {
      case LoginVariant.fromAddToBag:
        return 'Your item stays saved. New to Rozio? Your account is ready in under a minute.';
      case LoginVariant.loginAgain:
        return 'For your security we log you out after 30 days. Your bag and wishlist are saved.';
      case LoginVariant.standard:
        return 'One account for Retail, Wholesale and Auction. We send a code to your number, no password needed.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _errorState != LoginErrorState.none;
    final bool isNetworkError = _errorState == LoginErrorState.networkError;
    final bool isValid = _phoneController.text.length == _selectedCountry.maxLength && !hasError;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.cFFFFFF,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.c011447,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // Top Section (38% of screen): Crystal Clear High-Res 3D Artwork
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LocationHeaderArtwork(
                    type: HeaderArtworkType.pinBox,
                    height: MediaQuery.of(context).size.height * 0.38,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Continuing as Guest'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                              child: Text(
                                'Not now',
                                style: TextStyle(
                                  fontFamily: 'Geist',
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section (62% of screen)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cFFFFFF,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title with blue dot
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: _getTitleText(),
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c111827,
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '.',
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c1847C9,
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  UIHelper.verticalSpace(6.h),

                                  // Subtitle
                                  Text(
                                    _getSubtitleText(),
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c6B7280,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(20.h),

                                  // Label
                                  Text(
                                    'Mobile number',
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c6B7280,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(6.h),

                                  // Mobile Number Input Box
                                  Container(
                                    height: 52.h,
                                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: hasError ? Colors.white : AppColors.cF3F4F6,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: hasError
                                            ? const Color(0xFFEF4444)
                                            : (_currentVariant == LoginVariant.loginAgain || isValid
                                                ? const Color(0xFF1847C9)
                                                : Colors.transparent),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Changeable Country Code Button
                                        GestureDetector(
                                          onTap: _showCountryPicker,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(_selectedCountry.flag, style: const TextStyle(fontSize: 18)),
                                              SizedBox(width: 6.w),
                                              Text(
                                                _selectedCountry.dialCode,
                                                style: TextStyle(
                                                  fontFamily: 'Geist',
                                                  color: AppColors.c111827,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                size: 18.sp,
                                                color: AppColors.c6B7280,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          width: 1,
                                          height: 20.h,
                                          color: const Color(0xFFD1D5DB),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: TextField(
                                            controller: _phoneController,
                                            keyboardType: TextInputType.phone,
                                            maxLength: _selectedCountry.maxLength,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            style: TextStyle(
                                              fontFamily: 'Geist',
                                              color: AppColors.c111827,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: '${_selectedCountry.maxLength}-digit number',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Geist',
                                                color: AppColors.c6B7280.withValues(alpha: 0.6),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              border: InputBorder.none,
                                              counterText: '',
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        // Checkmark circle if valid
                                        if (isValid || _currentVariant == LoginVariant.loginAgain)
                                          Container(
                                            width: 20.w,
                                            height: 20.w,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF10B981),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 14.sp,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Error message if any (Frames 1 & 2 in Image 3)
                                  if (hasError) ...[
                                    UIHelper.verticalSpace(8.h),
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
                                            _errorState == LoginErrorState.invalidNumber
                                                ? 'Enter a valid mobile number. Indian numbers start with 6, 7, 8 or 9.'
                                                : "Couldn't send the code. Check your internet connection and try again.",
                                            style: TextStyle(
                                              fontFamily: 'Geist',
                                              color: const Color(0xFFEF4444),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              height: 1.35,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],

                                  // Button is placed DIRECTLY UNDER the input/red error text!
                                  UIHelper.verticalSpace(16.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52.h,
                                    child: ElevatedButton(
                                      onPressed: (_isButtonEnabled || isNetworkError || _currentVariant == LoginVariant.loginAgain)
                                          ? _onGetOtp
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.c1847C9,
                                        disabledBackgroundColor: const Color(0xFFE5E7EB),
                                        foregroundColor: Colors.white,
                                        disabledForegroundColor: const Color(0xFF9CA3AF),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14.r),
                                        ),
                                      ),
                                      child: Text(
                                        isNetworkError ? 'Try again' : 'Get OTP',
                                        style: TextStyle(
                                          fontFamily: 'Geist',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Spacer pushes only the footer to the bottom!
                                  const Spacer(),
                                  UIHelper.verticalSpace(16.h),

                                  // Terms & Privacy footer
                                  Center(
                                    child: Text.rich(
                                      textAlign: TextAlign.center,
                                      TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Geist',
                                          color: AppColors.c6B7280,
                                          fontSize: 12.sp,
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(text: 'By continuing you agree to Rozio\'s '),
                                          TextSpan(
                                            text: 'Terms of Use',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.c111827,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {},
                                          ),
                                          const TextSpan(text: ' and\n'),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.c111827,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {},
                                          ),
                                          const TextSpan(text: '.'),
                                        ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
