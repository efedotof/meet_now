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

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return Text(
        S.of(context).qrScanInstruction,
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? S.of(context).qrNoValue,
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

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
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).qrScanner)),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _handleBarcode),
          Center(child: CustomPaint(painter: QrScannerOverlay(ratio: 0.75))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_barcodePreview(_barcode)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
