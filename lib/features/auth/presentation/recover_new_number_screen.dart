import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/location/presentation/location_screen.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class RecoverNewNumberScreen extends StatefulWidget {
  static const String routeName = '/recover-new-number';

  const RecoverNewNumberScreen({super.key});

  @override
  State<RecoverNewNumberScreen> createState() => _RecoverNewNumberScreenState();
}

class _CountryItem {
  final String name;
  final String dialCode;
  final String flag;
  final int maxLength;

  const _CountryItem({
    required this.name,
    required this.dialCode,
    required this.flag,
    required this.maxLength,
  });
}

const List<_CountryItem> _kCountries = [
  _CountryItem(name: 'India', dialCode: '+91', flag: '🇮🇳', maxLength: 10),
  _CountryItem(name: 'Pakistan', dialCode: '+92', flag: '🇵🇰', maxLength: 10),
  _CountryItem(name: 'United States', dialCode: '+1', flag: '🇺🇸', maxLength: 10),
  _CountryItem(name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧', maxLength: 10),
  _CountryItem(name: 'United Arab Emirates', dialCode: '+971', flag: '🇦🇪', maxLength: 9),
  _CountryItem(name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦', maxLength: 9),
  _CountryItem(name: 'Canada', dialCode: '+1', flag: '🇨🇦', maxLength: 10),
];

class _RecoverNewNumberScreenState extends State<RecoverNewNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  _CountryItem _selectedCountry = _kCountries.first;

  bool get _isValidNumber {
    final text = _phoneController.text.trim();
    if (_selectedCountry.dialCode == '+91') {
      return text.length == 10 && ['6', '7', '8', '9'].contains(text[0]);
    }
    return text.length == _selectedCountry.maxLength;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UIHelper.verticalSpace(14.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              UIHelper.verticalSpace(14.h),
              Text(
                'Select Country',
                style: TextStyle(
                  fontFamily: 'Geist',
                  color: AppColors.c111827,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(10.h),
              Expanded(
                child: ListView.separated(
                  itemCount: _kCountries.length,
                  separatorBuilder: (ctx, i) => Divider(
                    height: 1,
                    color: AppColors.cF3F4F6,
                  ),
                  itemBuilder: (ctx, index) {
                    final item = _kCountries[index];
                    final isSelected = item.dialCode == _selectedCountry.dialCode;
                    return ListTile(
                      leading: Text(item.flag, style: const TextStyle(fontSize: 22)),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        item.dialCode,
                        style: TextStyle(
                          fontFamily: 'Geist',
                          color: AppColors.c6B7280,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = item;
                          _phoneController.clear();
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
    if (!_isValidNumber) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account recovery complete! Linked to ${_selectedCountry.dialCode} ${_phoneController.text}',
          style: TextStyle(fontFamily: 'Geist', fontSize: 13.sp),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        context.go(LocationScreen.routeName);
      }
    });
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
                                'Add your new number.',
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
                                'Identity confirmed. Your orders, bag and wallet move to this number.',
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
                                'Mobile number',
                                style: TextStyle(
                                  fontFamily: 'Geist',
                                  color: const Color(0xFF374151),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              UIHelper.verticalSpace(6.h),

                              // Mobile Number Input Box (Matching Frame A08 & A19)
                              Container(
                                height: 52.h,
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: AppColors.cF3F4F6,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: _isValidNumber
                                        ? const Color(0xFF1847C9)
                                        : Colors.transparent,
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
                                          Text(_selectedCountry.flag,
                                              style: const TextStyle(fontSize: 18)),
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
                                        focusNode: _phoneFocus,
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
                                          hintText: '10-digit number',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Geist',
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          counterText: '',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              UIHelper.verticalSpace(16.h),

                              // Primary Get OTP Button (directly below input)
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: _isValidNumber ? _onGetOtp : null,
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
                                    'Get OTP',
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

                              // Bottom Terms & Privacy Disclaimer
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c6B7280,
                                        fontSize: 11.5.sp,
                                        height: 1.4,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'By continuing you agree to Rozio’s ',
                                        ),
                                        TextSpan(
                                          text: 'Terms of Use',
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c111827,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: ' and\n'),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c111827,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
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
