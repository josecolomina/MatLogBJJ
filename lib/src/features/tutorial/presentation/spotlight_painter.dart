import 'package:flutter/material.dart';

class SpotlightPainter extends CustomPainter {
  final Rect? spotlight;
  final double spotlightRadius;

  SpotlightPainter({
    this.spotlight,
    this.spotlightRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.85)
      ..style = PaintingStyle.fill;

    // Create the full screen path
    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (spotlight != null) {
      // Create the spotlight path with rounded corners
      final spotlightPath = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            spotlight!,
            Radius.circular(spotlightRadius),
          ),
        );

      // Combine paths using difference to create a hole
      final combinedPath = Path.combine(
        PathOperation.difference,
        fullScreenPath,
        spotlightPath,
      );

      canvas.drawPath(combinedPath, paint);

      // Draw a subtle border around the spotlight
      final borderPaint = Paint()
        ..color = const Color(0xFF1565C0).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          spotlight!,
          Radius.circular(spotlightRadius),
        ),
        borderPaint,
      );
    } else {
      // No spotlight, just draw the overlay
      canvas.drawPath(fullScreenPath, paint);
    }
  }

  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) {
    return oldDelegate.spotlight != spotlight ||
        oldDelegate.spotlightRadius != spotlightRadius;
  }
}
