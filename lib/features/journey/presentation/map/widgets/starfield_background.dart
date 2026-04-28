import 'dart:math' as math;

import 'package:flutter/material.dart';

class StarfieldBackground extends StatelessWidget {
  const StarfieldBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: const _StarfieldPainter(), child: child);
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF080A12), Color(0xFF111827), Color(0xFF070A10)],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    final random = math.Random(37);
    for (var i = 0; i < 180; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.55 + random.nextDouble() * 1.35;
      final opacity = 0.25 + random.nextDouble() * 0.55;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }

    final nebulaPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFFD4A857).withValues(alpha: 0.18),
              const Color(0xFF7C6FAB).withValues(alpha: 0.08),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.48, size.height * 0.44),
              radius: size.shortestSide * 0.55,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.48, size.height * 0.44),
      size.shortestSide * 0.55,
      nebulaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => false;
}
