import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rozio_app/constants/app_assets/assets_image.dart';
import 'package:rozio_app/constants/app_colors.dart';

enum HeaderArtworkType {
  radar, // Frame A03: Concentric glowing radar rings with white badge & pin
  pinBox, // Frames A06-A09: 3D glowing location pin on parcel/box with neon lines
}

class LocationHeaderArtwork extends StatefulWidget {
  final HeaderArtworkType type;
  final double height;

  const LocationHeaderArtwork({
    super.key,
    required this.type,
    required this.height,
  });

  @override
  State<LocationHeaderArtwork> createState() => _LocationHeaderArtworkState();
}

class _LocationHeaderArtworkState extends State<LocationHeaderArtwork>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Crystal clear high-res background texture
          Image.asset(
            AssetsImages.splashBg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Deep blue gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.c011447.withValues(alpha: 0.2),
                  AppColors.c011447.withValues(alpha: 0.6),
                  AppColors.c011447.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),

          // 3. High-res vector artwork
          Center(
            child: widget.type == HeaderArtworkType.radar
                ? _buildRadar()
                : _buildPinBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildRadar() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final val = _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glowing concentric radar rings
            CustomPaint(
              size: Size(260.w, 180.h),
              painter: _RadarPainter(val),
            ),

            // Center White Circle with Drop Shadow & Pin (Frame A03)
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1847C9).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.location_on_rounded,
                  color: AppColors.c1847C9,
                  size: 32.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPinBox() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final val = _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // High-res Glowing neon blue ground contour lines
            CustomPaint(
              size: Size(300.w, 140.h),
              painter: _NeonGroundPainter(val),
            ),

            // Luminous ambient blue light aura
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00B0FF).withValues(alpha: 0.5),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
            ),

            // 3D Isometric Pin + Package
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: CustomPaint(
                size: Size(110.w, 110.h),
                painter: _IsometricPinBoxPainter(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Radar Painter ────────────────────────────────────────────────────────────

class _RadarPainter extends CustomPainter {
  final double animation;
  _RadarPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Static concentric rings
    final rings = [45.0, 75.0, 105.0, 135.0];
    for (int i = 0; i < rings.length; i++) {
      linePaint.color = const Color(0xFF38BDF8).withValues(alpha: 0.12 + (i * 0.05));
      canvas.drawCircle(center, rings[i], linePaint);
    }

    // Animated expanding pulse wave
    final pulseRadius = 30.0 + (120.0 * animation);
    final pulseOpacity = (1.0 - animation).clamp(0.0, 1.0) * 0.45;
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = const Color(0xFF00E5FF).withValues(alpha: pulseOpacity);
    canvas.drawCircle(center, pulseRadius, pulsePaint);

    // Subtle curved antenna lines
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 155),
      -math.pi * 0.75,
      math.pi * 0.5,
      false,
      wavePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 155),
      math.pi * 0.25,
      math.pi * 0.5,
      false,
      wavePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}

// ─── Neon Ground Wave Painter (Frames A06 - A09) ──────────────────────────────

class _NeonGroundPainter extends CustomPainter {
  final double anim;
  _NeonGroundPainter(this.anim);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.78);

    final contourPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Concentric perspective terrain ovals
    final ovals = [
      Rect.fromCenter(center: center, width: 90, height: 28),
      Rect.fromCenter(center: center, width: 150, height: 46),
      Rect.fromCenter(center: center, width: 220, height: 68),
      Rect.fromCenter(center: center, width: 290, height: 90),
    ];

    for (int i = 0; i < ovals.length; i++) {
      contourPaint.color = const Color(0xFF00B0FF).withValues(alpha: 0.18 + (i * 0.08));
      canvas.drawOval(ovals[i], contourPaint);
    }

    // Glowing electric terrain lines flowing out
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.6);

    final path1 = Path();
    path1.moveTo(10, size.height * 0.62);
    path1.quadraticBezierTo(size.width * 0.25, size.height * 0.82, center.dx - 15, center.dy + 8);
    canvas.drawPath(path1, linePaint);

    final path2 = Path();
    path2.moveTo(size.width - 10, size.height * 0.65);
    path2.quadraticBezierTo(size.width * 0.72, size.height * 0.84, center.dx + 15, center.dy + 8);
    canvas.drawPath(path2, linePaint);
  }

  @override
  bool shouldRepaint(covariant _NeonGroundPainter oldDelegate) => true;
}

// ─── Crisp Vector 3D Isometric Pin & Parcel/Box Painter ────────────────────────

class _IsometricPinBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.65;

    // 1. Box dimensions in isometric projection
    final bw = 42.0; // half-width
    final bh = 22.0; // half-depth
    final bHeight = 28.0; // vertical height

    // Box Top Face
    final topPath = Path()
      ..moveTo(cx, cy - bh)
      ..lineTo(cx + bw, cy)
      ..lineTo(cx, cy + bh)
      ..lineTo(cx - bw, cy)
      ..close();

    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
      ).createShader(Rect.fromLTWH(cx - bw, cy - bh, bw * 2, bh * 2));
    canvas.drawPath(topPath, topPaint);

    // Box Left Face
    final leftPath = Path()
      ..moveTo(cx - bw, cy)
      ..lineTo(cx, cy + bh)
      ..lineTo(cx, cy + bh + bHeight)
      ..lineTo(cx - bw, cy + bHeight)
      ..close();

    final leftPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0D47A1), Color(0xFF0A2472)],
      ).createShader(Rect.fromLTWH(cx - bw, cy, bw, bh + bHeight));
    canvas.drawPath(leftPath, leftPaint);

    // Box Right Face
    final rightPath = Path()
      ..moveTo(cx, cy + bh)
      ..lineTo(cx + bw, cy)
      ..lineTo(cx + bw, cy + bHeight)
      ..lineTo(cx, cy + bh + bHeight)
      ..close();

    final rightPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
      ).createShader(Rect.fromLTWH(cx, cy, bw, bh + bHeight));
    canvas.drawPath(rightPath, rightPaint);

    // Box Neon Edges
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFF80D8FF).withValues(alpha: 0.8);
    canvas.drawPath(topPath, edgePaint);
    canvas.drawPath(leftPath, edgePaint);
    canvas.drawPath(rightPath, edgePaint);

    // Glowing cyan tape cross on top of box
    final tapePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.9);
    canvas.drawLine(Offset(cx - bw * 0.5, cy - bh * 0.5), Offset(cx + bw * 0.5, cy + bh * 0.5), tapePaint);
    canvas.drawLine(Offset(cx - bw * 0.5, cy + bh * 0.5), Offset(cx + bw * 0.5, cy - bh * 0.5), tapePaint);

    // 2. 3D Glowing Location Pin Standing on Top of Box
    final pinTip = Offset(cx, cy - 2);
    final pinHead = Offset(cx, cy - 38);
    final pinRadius = 15.0;

    // Pin Shadow on Box Top
    canvas.drawOval(
      Rect.fromCenter(center: pinTip, width: 14, height: 6),
      Paint()..color = Colors.black.withValues(alpha: 0.4),
    );

    // Pin Body Path
    final pinPath = Path();
    pinPath.moveTo(pinTip.dx, pinTip.dy);
    pinPath.quadraticBezierTo(
      cx - pinRadius * 1.3,
      pinHead.dy + pinRadius * 0.6,
      cx - pinRadius,
      pinHead.dy,
    );
    pinPath.arcToPoint(
      Offset(cx + pinRadius, pinHead.dy),
      radius: Radius.circular(pinRadius),
      clockwise: true,
    );
    pinPath.quadraticBezierTo(
      cx + pinRadius * 1.3,
      pinHead.dy + pinRadius * 0.6,
      pinTip.dx,
      pinTip.dy,
    );
    pinPath.close();

    // Glossy 3D Blue Pin Gradient
    final pinPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF80E5FF),
          Color(0xFF0091EA),
          Color(0xFF0D47A1),
        ],
      ).createShader(Rect.fromLTWH(cx - pinRadius * 1.5, pinHead.dy - pinRadius, pinRadius * 3, 45));

    // Outer Pin Glow
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8),
    );

    canvas.drawPath(pinPath, pinPaint);

    // Pin Inner Hole / Dot
    final holePaint = Paint()
      ..color = const Color(0xFF0A2472)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pinHead, 5.5, holePaint);

    final holeRim = Paint()
      ..color = const Color(0xFF80E5FF).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(pinHead, 5.5, holeRim);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
