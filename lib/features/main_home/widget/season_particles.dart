import 'dart:math';
import 'package:flutter/material.dart';

import 'koch_snowflake.dart';

/// ------------------------------------------------------------
/// Base particle
/// ------------------------------------------------------------
abstract class SeasonParticle {
  Offset position;
  double size;
  double speed;
  double rotation;
  double rotationSpeed;
  double opacity;
  double oscillation;
  double oscillationSpeed;
  Color color;

  SeasonParticle({
    required this.position,
    required this.size,
    required this.speed,
    required this.color,
    this.rotation = 0,
    this.rotationSpeed = 0,
    this.opacity = 1.0,
    this.oscillation = 0,
    this.oscillationSpeed = 0,
  });

  void update(double deltaTime, double screenHeight, double screenWidth);

  void draw(Canvas canvas, Paint paint);
}

/// ------------------------------------------------------------
/// Koch Snowflake Particle ❄
/// ------------------------------------------------------------
class KochSnowflakeParticle extends SeasonParticle {
  late KochSnowflake snowflake;
  static final Random _random = Random();

  KochSnowflakeParticle({
    required super.position,
    required super.size,
    required super.speed,
    required super.color,
    super.rotation,
    super.rotationSpeed,
    super.opacity,
    super.oscillation,
    super.oscillationSpeed,
  }) {
    snowflake = KochSnowflake(
      size: size,
      position: position,
      iterations: 2 + _random.nextInt(2),
      rotation: rotation,
    );
  }

  @override
  void update(double deltaTime, double screenHeight, double screenWidth) {
    position = Offset(
      position.dx + sin(oscillation) * 0.5,
      position.dy + speed * deltaTime * 60,
    );

    rotation += rotationSpeed * deltaTime;
    oscillation += oscillationSpeed * deltaTime;

    if (position.dy > screenHeight + size) {
      position = Offset(_random.nextDouble() * screenWidth, -size * 2);
      oscillation = _random.nextDouble() * 2 * pi;
    }

    if (position.dx > screenWidth + size) {
      position = Offset(-size, position.dy);
    } else if (position.dx < -size) {
      position = Offset(screenWidth + size, position.dy);
    }

    snowflake = KochSnowflake(
      size: size,
      position: position,
      iterations: snowflake.iterations,
      rotation: rotation,
    );
  }

  @override
  void draw(Canvas canvas, Paint paint) {
    final path = snowflake.buildPath();

    final fillPaint =
        Paint()
          ..color = color.withValues(alpha: opacity * 0.3)
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = color.withValues(alpha: opacity * 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;

    final glowPaint =
        Paint()
          ..color = color.withValues(alpha: opacity * 0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
    canvas.drawPath(path, glowPaint);
  }
}

class FlowerPetalParticle extends SeasonParticle {
  final int petalCount;
  static final Random _random = Random();

  FlowerPetalParticle({
    required super.position,
    required super.size,
    required super.speed,
    required super.color,
    super.rotation,
    super.rotationSpeed,
    super.opacity,
    super.oscillation,
    super.oscillationSpeed,
    this.petalCount = 5,
  });

  @override
  void update(double deltaTime, double screenHeight, double screenWidth) {
    oscillation += oscillationSpeed * deltaTime;
    rotation += rotationSpeed * deltaTime;

    position = Offset(
      position.dx + sin(oscillation) * 1.6,
      position.dy + speed * deltaTime * 35,
    );

    if (position.dy > screenHeight + size) {
      position = Offset(_random.nextDouble() * screenWidth, -size * 2);
      oscillation = _random.nextDouble() * 2 * pi;
    }
  }

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);

    for (int i = 0; i < petalCount; i++) {
      final angle = 2 * pi * i / petalCount;
      canvas.save();
      canvas.rotate(angle);

      final rect = Rect.fromCenter(
        center: Offset(size * .6, 0),
        width: size * 1.2,
        height: size * .7,
      );

      final petalPaint =
          Paint()
            ..shader = RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: opacity * .3),
              ],
            ).createShader(rect);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(size)),
        petalPaint,
      );

      canvas.restore();
    }

    final centerPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.yellow.withValues(alpha: opacity),
              Colors.orange.withValues(alpha: opacity * .3),
            ],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: size * .6),
          );

    canvas.drawCircle(Offset.zero, size * .35, centerPaint);

    canvas.restore();
  }
}

class SunParticle extends SeasonParticle {
  final double glowIntensity;
  static final Random _random = Random();

  SunParticle({
    required super.position,
    required super.size,
    required super.speed,
    required super.color,
    super.rotation,
    super.rotationSpeed,
    super.opacity,
    super.oscillation,
    super.oscillationSpeed,
    this.glowIntensity = 0.8,
  });

  @override
  void update(double deltaTime, double screenHeight, double screenWidth) {
    oscillation += oscillationSpeed * deltaTime;
    rotation += rotationSpeed * deltaTime;

    position = Offset(
      position.dx + sin(oscillation) * .8,
      position.dy + speed * deltaTime * 25,
    );

    opacity = .7 + sin(oscillation) * .3;

    if (position.dy > screenHeight + size) {
      position = Offset(_random.nextDouble() * screenWidth, -size * 2);
    }
  }

  @override
  void draw(Canvas canvas, Paint paint) {
    final glowPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: opacity * glowIntensity),
              color.withValues(alpha: opacity * .2),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: position, radius: size * 3));

    canvas.drawCircle(position, size * 3, glowPaint);

    final corePaint =
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.white, color.withValues(alpha: opacity)],
          ).createShader(Rect.fromCircle(center: position, radius: size));

    canvas.drawCircle(position, size, corePaint);

    for (int i = 0; i < 10; i++) {
      final a = rotation + pi * 2 * i / 10;
      final p1 = position + Offset(cos(a), sin(a)) * size;
      final p2 = position + Offset(cos(a), sin(a)) * size * 1.8;

      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = color.withValues(alpha: opacity * .6)
          ..strokeWidth = size * .12
          ..strokeCap = StrokeCap.round,
      );
    }
  }
}

class LeafParticle extends SeasonParticle {
  final Path leafPath;
  static final Random _random = Random();

  LeafParticle({
    required super.position,
    required super.size,
    required super.speed,
    required super.color,
    super.rotation,
    super.rotationSpeed,
    super.opacity,
    super.oscillation,
    super.oscillationSpeed,
  }) : leafPath = _createLeafPath();

  @override
  void update(double deltaTime, double screenHeight, double screenWidth) {
    position = Offset(
      position.dx + sin(oscillation) * 1,
      position.dy + speed * deltaTime * 50,
    );

    rotation += rotationSpeed * deltaTime;
    oscillation += oscillationSpeed * deltaTime;

    if (position.dy > screenHeight + size) {
      position = Offset(_random.nextDouble() * screenWidth, -size * 2);
      oscillation = _random.nextDouble() * 2 * pi;
      rotation = _random.nextDouble() * 2 * pi;
    }
  }

  @override
  void draw(Canvas canvas, Paint paint) {
    final matrix =
        Matrix4.identity()
          ..translateByDouble(position.dx, position.dy, 0, 1)
          ..rotateZ(rotation)
          ..scaleByDouble(size / 50, size / 50, 1, 1);

    final transformedPath = leafPath.transform(matrix.storage);

    final leafPaint =
        Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

    final veinPaint =
        Paint()
          ..color = color.withValues(alpha: opacity * 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    canvas.drawPath(transformedPath, leafPaint);
    canvas.drawPath(transformedPath, veinPaint);
  }

  static Path _createLeafPath() {
    final path = Path();
    path.moveTo(25, 0);
    path.cubicTo(35, 5, 40, 15, 45, 25);
    path.cubicTo(50, 35, 45, 45, 35, 50);
    path.cubicTo(25, 55, 15, 50, 10, 40);
    path.cubicTo(5, 30, 10, 15, 25, 0);
    path.close();
    return path;
  }
}
