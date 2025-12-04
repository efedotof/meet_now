import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/qr_code/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  Barcode? _barcode;
  MobileScannerController controller = MobileScannerController();

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _handleBarcode),
          Center(child: CustomPaint(painter: QrScannerOverlay(ratio: 0.75))),
          Positioned(
            bottom: 3,
            left: 10,
            right: 10,
            child: Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isDark ? Colors.black87 : Colors.white70,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_barcode == null)
                      Text(
                        S.of(context).qrScanInstruction,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      )
                    else
                      Text(
                        _barcode!.displayValue ?? S.of(context).qrNoValue,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const AppBarWidget(),
        ],
      ),
    );
  }
}
