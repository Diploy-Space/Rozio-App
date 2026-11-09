import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/location/presentation/location_found_screen.dart';
import 'package:rozio_app/features/location/presentation/pincode_screen.dart';
import 'package:rozio_app/features/location/presentation/widgets/location_header_artwork.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class LocationScreen extends StatefulWidget {
  static const String routeName = '/location';

  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = false;

  void _onUseCurrentLocation() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => _LocationPermissionDialog(
        onAllow: () {
          Navigator.pop(context);
          _fetchRealLocation();
        },
        onDeny: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _fetchRealLocation() async {
    setState(() => _isLoading = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showSnackBar('Please enable location services on your phone.');
        }
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) _showSettingsDialog();
        setState(() => _isLoading = false);
        return;
      }

      Position? pos;
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 12),
          ),
        );
      }

      if (mounted) {
        context.go(LocationFoundScreen.routeName, extra: pos);
      }
    } catch (_) {
      if (mounted) {
        context.go(LocationFoundScreen.routeName);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(fontFamily: 'Geist', fontSize: 13.sp)),
        backgroundColor: AppColors.c111827,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Location Permission Required',
          style: TextStyle(fontFamily: 'Geist', fontWeight: FontWeight.w700, fontSize: 17.sp),
        ),
        content: Text(
          'Please enable location permission in App Settings to detect your delivery address.',
          style: TextStyle(fontFamily: 'Geist', fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text('Open Settings', style: TextStyle(color: AppColors.c1847C9)),
          ),
        ],
      ),
    );
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
            // Top Section (38% of screen): High-Res Radar Artwork
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LocationHeaderArtwork(
                    type: HeaderArtworkType.radar,
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
                            onTap: () => context.go(LocationFoundScreen.routeName),
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

            // Bottom Section (62% of screen): Full-height white card
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
                    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Where should we deliver?',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            color: AppColors.c111827,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        UIHelper.verticalSpace(8.h),
                        Text(
                          'We use your pincode to show delivery dates, cash on delivery and stores near you.',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            color: AppColors.c6B7280,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                          ),
                        ),
                        const Spacer(),

                        // Use my current location Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onUseCurrentLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.c1847C9,
                              foregroundColor: AppColors.cFFFFFF,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.my_location_rounded,
                                        size: 19.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Use my current location',
                                        style: TextStyle(
                                          fontFamily: 'Geist',
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        UIHelper.verticalSpace(12.h),

                        // Enter pincode manually Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: OutlinedButton(
                            onPressed: () => context.go(PincodeScreen.routeName),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.c1847C9,
                              side: const BorderSide(
                                color: AppColors.c1847C9,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'Enter pincode manually',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                color: AppColors.c1847C9,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        UIHelper.verticalSpace(16.h),

                        // Footer Note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 13.sp,
                              color: AppColors.c6B7280,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Used only for delivery. Never shared with sellers.',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                color: AppColors.c6B7280,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
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

// ─── Frame A04: Permission Dialog ───────────────────────────────────────────────

class _LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDeny;

  const _LocationPermissionDialog({
    required this.onAllow,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
              child: Column(
                children: [
                  Text(
                    'Allow "Rozio" to use\nyour location?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Geist',
                      color: Colors.black,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Rozio uses your location to show delivery dates and cash on delivery for your address.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Geist',
                      color: const Color(0xFF3C3C43),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 90.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(double.infinity, 90.h),
                          painter: _DialogMapPainter(),
                        ),
                        Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF007AFF).withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF007AFF),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.35)),
            _dialogOption('Allow Once', const Color(0xFF007AFF), onAllow),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.35)),
            _dialogOption('Allow While Using App', const Color(0xFF007AFF), onAllow),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.35)),
            _dialogOption("Don't Allow", const Color(0xFF007AFF), onDeny),
          ],
        ),
      ),
    );
  }

  Widget _dialogOption(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Geist',
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _DialogMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.6);
    canvas.drawPath(path, roadPaint);

    final roadPaint2 = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
