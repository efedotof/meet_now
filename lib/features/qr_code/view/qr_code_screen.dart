import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/qr_code/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:universal_platform/universal_platform.dart';

@RoutePage()
class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  late MobileScannerController cameraController;
  bool _isScanning = false;
  bool _isTorchOn = false;
  bool _hasTorch = false;
  String? _scannedData;
  StreamSubscription<BarcodeCapture>? _barcodeSubscription;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      torchEnabled: false,
      detectionSpeed: DetectionSpeed.normal,
    );

    cameraController.addListener(_handleControllerChange);

    _startScanner();
  }

  void _handleControllerChange() {
    final state = cameraController.value;

    setState(() {
      _hasTorch = state.torchState != TorchState.unavailable;

      if (state.torchState == TorchState.on) {
        _isTorchOn = true;
      } else if (state.torchState == TorchState.off) {
        _isTorchOn = false;
      }
    });
  }

  Future<void> _startScanner() async {
    try {
      await cameraController.start();
      _barcodeSubscription = cameraController.barcodes.listen(_handleBarcode);
      setState(() => _isScanning = true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).cameraStartError}: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _isScanning = false);
    }
  }

  void _toggleTorch() {
    cameraController.toggleTorch();
  }

  void _handleBarcode(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && _scannedData != barcode.rawValue) {
        setState(() => _scannedData = barcode.rawValue);
        debugPrint('${S.of(context).scanned}: ${barcode.rawValue}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${S.of(context).scanned}: ${barcode.rawValue}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    cameraController.removeListener(_handleControllerChange);
    _barcodeSubscription?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  bool get _isMobilePlatform {
    return UniversalPlatform.isAndroid || UniversalPlatform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).qrScanning),
        actions: [
          if (_hasTorch)
            IconButton(
              icon: Icon(
                _isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
              onPressed: _isScanning ? _toggleTorch : null,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isMobilePlatform) {
      return Center(
        child: Text(
          S.of(context).qrNotAvailable,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Stack(
      children: [
        MobileScanner(controller: cameraController),
        CustomPaint(painter: QrScannerOverlay(ratio: 0.7), child: Container()),
      ],
    );
  }
}
