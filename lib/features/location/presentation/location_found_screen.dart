import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:rozio_app/constants/app_colors.dart';
import 'package:rozio_app/features/location/presentation/pincode_screen.dart';
import 'package:rozio_app/helpers/ui_helpers.dart';

class LocationFoundScreen extends StatefulWidget {
  static const String routeName = '/location-found';

  const LocationFoundScreen({super.key, this.position});

  final Position? position;

  @override
  State<LocationFoundScreen> createState() => _LocationFoundScreenState();
}

class _LocationFoundScreenState extends State<LocationFoundScreen> {
  late final MapController _mapController;
  LatLng _currentLatLng = const LatLng(19.1363, 72.8277); // Default Andheri West
  String _locality = 'Andheri West';
  String _addressDetails = 'Flat 12B, Sea View Apartments,\nLink Road, Mumbai 400053';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _resolveLocation();
  }

  Future<void> _resolveLocation() async {
    Position? pos = widget.position;
    if (pos == null) {
      try {
        final perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.whileInUse ||
            perm == LocationPermission.always) {
          pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 8),
            ),
          );
        }
      } catch (_) {}
    }

    if (pos != null && mounted) {
      final target = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _currentLatLng = target;
        _isLoading = true;
      });

      _mapController.move(target, 16.5);

      try {
        final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty && mounted) {
          final p = placemarks.first;
          setState(() {
            _locality = p.subLocality?.isNotEmpty == true
                ? p.subLocality!
                : (p.locality ?? 'Current Location');
            final parts = [p.name, p.thoroughfare, p.subAdministrativeArea, p.postalCode]
                .where((e) => e != null && e.isNotEmpty)
                .toList();
            if (parts.isNotEmpty) {
              _addressDetails = parts.join(', ');
            }
          });
        }
      } catch (_) {
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _recenter() {
    _mapController.move(_currentLatLng, 16.5);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.cFFFFFF,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFE5EAF0),
        body: Stack(
          children: [
            // OpenStreetMap Layer
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLatLng,
                  initialZoom: 16.5,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onPositionChanged: (camera, hasGesture) {
                    if (hasGesture) {
                      setState(() {
                        _currentLatLng = camera.center;
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.rozio.app',
                    maxZoom: 19,
                  ),
                ],
              ),
            ),

            // Fixed Pin in Map Center with Tooltip (Frame A05 exact design)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 120.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Black Tooltip
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: AppColors.c111827,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Your order will be delivered here',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Downward Pointer triangle
                        CustomPaint(
                          size: Size(12.w, 6.h),
                          painter: _PointerTrianglePainter(),
                        ),
                        UIHelper.verticalSpace(2.h),

                        // Delivery Target Pin (Black with blue core and light blue radius)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Light blue circle radius
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF007AFF).withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Black Pin
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Icon(
                                Icons.location_on_rounded,
                                size: 40.sp,
                                color: AppColors.c111827,
                              ),
                            ),
                            // Blue dot inside pin base
                            Positioned(
                              bottom: 15.h,
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF007AFF),
                                  shape: BoxShape.circle,
                                ),
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

            // Floating GPS Recenter Button (above bottom sheet)
            Positioned(
              right: 16.w,
              bottom: 250.h,
              child: GestureDetector(
                onTap: _recenter,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: AppColors.c1847C9,
                    size: 22.sp,
                  ),
                ),
              ),
            ),

            // Top Bar
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button (Rounded white box with shadow)
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.c111827,
                          size: 18.sp,
                        ),
                      ),
                    ),

                    // Skip Button (White pill with shadow)
                    GestureDetector(
                      onTap: () {
                        context.go(PincodeScreen.routeName);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            color: AppColors.c111827,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Delivery Card (Frame 33691 Exact Design)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label
                        Text(
                          'CONFIRM DELIVERY LOCATION',
                          style: TextStyle(
                            fontFamily: 'Geist',
                            color: AppColors.c6B7280,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        UIHelper.verticalSpace(14.h),

                        // Address Row with soft blue circular pin container
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Circular blue badge for pin icon (as in design)
                            Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFF6FF),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.c1847C9,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _locality,
                                    style: TextStyle(
                                      fontFamily: 'Geist',
                                      color: AppColors.c111827,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  if (_isLoading)
                                    Text(
                                      'Detecting address...',
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c6B7280,
                                        fontSize: 13.sp,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  else
                                    Text(
                                      _addressDetails,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Geist',
                                        color: AppColors.c6B7280,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.35,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // "Change" inside grey pill button (as in design)
                            GestureDetector(
                              onTap: () => context.go(PincodeScreen.routeName),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                    fontFamily: 'Geist',
                                    color: AppColors.c1847C9,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(14.h),

                        // Badges Row
                        Wrap(
                          spacing: 10.w,
                          runSpacing: 6.h,
                          children: [
                            _buildDeliveryBadge(
                              icon: Icons.local_shipping_outlined,
                              text: 'Delivery by Thu, Oct 29',
                            ),
                            _buildDeliveryBadge(
                              icon: Icons.payments_outlined,
                              text: 'Cash on delivery',
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(18.h),

                        // Confirm Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go(PincodeScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.c1847C9,
                              foregroundColor: AppColors.cFFFFFF,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'Confirm and continue',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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

  Widget _buildDeliveryBadge({required IconData icon, required String text}) {
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
            text,
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

class _PointerTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.c111827
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
