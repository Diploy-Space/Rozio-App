import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/auth/presentation/login_screen.dart';
import 'package:rozio_app/features/location/presentation/location_screen.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class PincodeScreen extends StatefulWidget {
  static const String routeName = '/pincode';

  const PincodeScreen({super.key});

  @override
  State<PincodeScreen> createState() => _PincodeScreenState();
}

class _PincodeScreenState extends State<PincodeScreen> {
  final TextEditingController _controller = TextEditingController(text: '400053');
  bool _isNotDelivered = false;
  String _areaName = 'Andheri West, Mumbai';
  String _stateName = 'Maharashtra';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _checkPincode(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text.trim();
    if (text.length == 6) {
      _checkPincode(text);
    } else {
      setState(() {
        _isNotDelivered = false;
      });
    }
  }

  Future<void> _checkPincode(String pincode) async {
    setState(() => _isLoading = true);

    // If pincode starts with '7' (e.g. 799001 from Figma Frame A07) -> Undeliverable
    if (pincode == '799001' || pincode.startsWith('7')) {
      setState(() {
        _isNotDelivered = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final locations = await locationFromAddress('$pincode, India');
      if (locations.isNotEmpty) {
        final placemarks = await placemarkFromCoordinates(
          locations.first.latitude,
          locations.first.longitude,
        );
        if (placemarks.isNotEmpty && mounted) {
          final p = placemarks.first;
          setState(() {
            _areaName = '${p.subLocality?.isNotEmpty == true ? p.subLocality : p.locality ?? 'Area'}, ${p.locality ?? 'City'}';
            _stateName = p.administrativeArea ?? 'India';
            _isNotDelivered = false;
          });
        }
      } else {
        setState(() => _isNotDelivered = true);
      }
    } catch (_) {
      if (pincode == '400053') {
        setState(() {
          _areaName = 'Andheri West, Mumbai';
          _stateName = 'Maharashtra';
          _isNotDelivered = false;
        });
      } else {
        setState(() {
          _isNotDelivered = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onProceed() {
    context.go(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
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
            // Top Section (38% of screen)
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
                            onTap: () => context.go(LoginScreen.routeName),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                              child: Text(
                                'Skip',
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

            // Bottom Section (62% of screen) - Buttons pinned to bottom!
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
                                  // Title
                                  Text(
                                    'Enter your pincode',
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c111827,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(6.h),

                                  // Subtitle
                                  Text(
                                    'Six digits, as on your address. You can add the full address at checkout.',
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c6B7280,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(18.h),

                                  // Pincode Input Container
                                  Container(
                                    height: 52.h,
                                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: _isNotDelivered
                                            ? const Color(0xFFEF4444)
                                            : (_controller.text.length == 6
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFE5E7EB)),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: AppColors.c6B7280,
                                          size: 22.sp,
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: TextField(
                                            controller: _controller,
                                            keyboardType: TextInputType.number,
                                            maxLength: 6,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            style: TextStyle(
                                              fontFamily: 'Geist',
                                              color: AppColors.c111827,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              counterText: '',
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        if (_isLoading)
                                          SizedBox(
                                            width: 18.w,
                                            height: 18.w,
                                            child: const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.c1847C9,
                                            ),
                                          )
                                        else if (_controller.text.length == 6 && !_isNotDelivered)
                                          Container(
                                            width: 22.w,
                                            height: 22.w,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF10B981),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 15.sp,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  UIHelper.verticalSpace(14.h),

                                  // Section 1: When Deliverable (Frame 33709)
                                  if (!_isNotDelivered && _controller.text.length == 6) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _areaName,
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c111827,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _stateName,
                                          style: TextStyle(
                                            fontFamily: 'Geist',
                                            color: AppColors.c6B7280,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    UIHelper.verticalSpace(10.h),
                                    Row(
                                      children: [
                                        _buildPillTag(
                                          icon: Icons.local_shipping_outlined,
                                          label: 'Delivery in 2 days',
                                        ),
                                        SizedBox(width: 8.w),
                                        _buildPillTag(
                                          icon: Icons.payments_outlined,
                                          label: 'Cash on delivery',
                                        ),
                                      ],
                                    ),
                                  ],

                                  // Section 2: When NOT Deliverable (Frame 33710)
                                  if (_isNotDelivered) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12.r),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: const Color(0xFFFCA5A5).withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.h),
                                            child: Icon(
                                              Icons.info_outline_rounded,
                                              color: const Color(0xFFDC2626),
                                              size: 18.sp,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "We don't deliver to ${_controller.text} yet",
                                                  style: TextStyle(
                                                    fontFamily: 'Geist',
                                                    color: const Color(0xFF991B1B),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  "You can still browse and save items. We'll tell you when delivery starts in your area.",
                                                  style: TextStyle(
                                                    fontFamily: 'Geist',
                                                    color: const Color(0xFFB91C1C).withValues(alpha: 0.9),
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  // Spacer pushes buttons all the way to the bottom!
                                  const Spacer(),
                                  UIHelper.verticalSpace(16.h),

                                  // Action Button ("Continue" or "Browse anyway")
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52.h,
                                    child: ElevatedButton(
                                      onPressed: _onProceed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.c1847C9,
                                        foregroundColor: AppColors.cFFFFFF,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14.r),
                                        ),
                                      ),
                                      child: Text(
                                        _isNotDelivered ? 'Browse anyway' : 'Continue',
                                        style: TextStyle(
                                          fontFamily: 'Geist',
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  UIHelper.verticalSpace(12.h),

                                  // Use current location instead Button
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: () => context.go(LocationScreen.routeName),
                                      icon: Icon(
                                        Icons.my_location_rounded,
                                        size: 16.sp,
                                        color: AppColors.c1847C9,
                                      ),
                                      label: Text(
                                        'Use current location instead',
                                        style: TextStyle(
                                          fontFamily: 'Geist',
                                          color: AppColors.c1847C9,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
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

  Widget _buildPillTag({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF86EFAC).withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: const Color(0xFF16A34A)),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Geist',
              color: const Color(0xFF15803D),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
