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

    final Paint borderPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromPoints(
        Offset(left, top),
        Offset(left + areaSize, top + areaSize),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
