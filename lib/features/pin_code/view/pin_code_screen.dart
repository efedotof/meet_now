import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/pin_code/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class PinCodeScreen extends StatelessWidget {
  const PinCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                S.of(context).enterPinCode,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              PinCodeInput(),
              const SizedBox(height: 30),
              NumPad(),
            ],
          ),
        ),
      ),
    );
  }
}
