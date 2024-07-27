import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double radius = 24.0;

class FiveCornersClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double middleHeight = 68.0.w;

    final path = Path()
      ..moveTo(0, 0) // Top-left corner
      ..lineTo(size.width, 0) // Top-right corner
      ..lineTo(
          size.width,
          size.height -
              middleHeight -
              radius) // Draw line to bottom-right corner before the curve
      ..cubicTo(
          size.width,
          size.height - middleHeight,
          size.width - 6.w,
          size.height - middleHeight - 2.w,
          size.width - radius - 2.w,
          size.height - middleHeight + 4.w) // Bottom-right corner curve
      ..lineTo(
          size.width * 0.5 + radius,
          size.height -
              radius) // Draw line to right side of the middle bottom curve
      ..cubicTo(
          size.width * 0.5,
          size.height - radius / 1.6,
          size.width * 0.5,
          size.height - radius / 1.6,
          size.width * 0.5 - radius,
          size.height - radius) // Middle bottom curve
      ..lineTo(
          radius,
          size.height -
              middleHeight +
              2.w) // Draw line to bottom-left corner before the curve
      ..cubicTo(
          radius + 2.w,
          size.height - middleHeight + 2.w,
          0.w,
          size.height - middleHeight - 2.w,
          0,
          size.height - middleHeight - radius + 4.w)
      ..lineTo(0, 0) // Draw line to top-left corner
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
