import 'dart:math';
import 'package:flutter/material.dart';

class KochSnowflake {
  final double size;
  final Offset position;
  final int iterations;
  final double rotation;

  KochSnowflake({
    required this.size,
    required this.position,
    this.iterations = 3,
    this.rotation = 0,
  });

  Path buildPath() {
    final path = Path();
    final double radius = size / 2;
    final Offset center = position;

    final List<Offset> trianglePoints = [];
    for (int i = 0; i < 3; i++) {
      double angle = 2 * pi * i / 3 + rotation;
      trianglePoints.add(
        Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        ),
      );
    }

    for (int i = 0; i < 3; i++) {
      final start = trianglePoints[i];
      final end = trianglePoints[(i + 1) % 3];
      _kochCurve(path, start, end, iterations);
    }

    path.close();
    return path;
  }

  void _kochCurve(Path path, Offset p1, Offset p2, int iter) {
    if (iter == 0) {
      path.lineTo(p2.dx, p2.dy);
    } else {
      final delta = p2 - p1;
      final length = delta.distance / 3;

      final a = p1;
      final b = p1 + delta / 3;

      final angle = atan2(delta.dy, delta.dx);
      final c =
          b +
          Offset(length * cos(angle - pi / 3), length * sin(angle - pi / 3));

      final d = p1 + (delta * 2) / 3;
      final e = p2;

      path.moveTo(a.dx, a.dy);

      _kochCurve(path, a, b, iter - 1);
      _kochCurve(path, b, c, iter - 1);
      _kochCurve(path, c, d, iter - 1);
      _kochCurve(path, d, e, iter - 1);
    }
  }
}
