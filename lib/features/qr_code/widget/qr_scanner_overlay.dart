import 'package:flutter/material.dart';

class QrScannerOverlay extends CustomPainter {
  final double ratio;

  QrScannerOverlay({required this.ratio});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double areaSize = width * ratio;
    final double left = (width - areaSize) / 2;
    final double top = (height - areaSize) / 2;

    final Paint paint =
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, width, top), paint);
    canvas.drawRect(Rect.fromLTRB(0, top + areaSize, width, height), paint);
    canvas.drawRect(Rect.fromLTRB(0, top, left, top + areaSize), paint);
    canvas.drawRect(
      Rect.fromLTRB(left + areaSize, top, width, top + areaSize),
      paint,
    );
    final Paint cornerPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    const double cornerLength = 25.0;
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + areaSize - cornerLength, top),
      Offset(left + areaSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + areaSize, top),
      Offset(left + areaSize, top + cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + areaSize - cornerLength),
      Offset(left, top + areaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + areaSize),
      Offset(left + cornerLength, top + areaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + areaSize, top + areaSize - cornerLength),
      Offset(left + areaSize, top + areaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + areaSize - cornerLength, top + areaSize),
      Offset(left + areaSize, top + areaSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
