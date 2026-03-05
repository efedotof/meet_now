import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'num_pad.dart';
import 'pin_display.dart';

class EnterCurrentPinModal extends StatefulWidget {
  const EnterCurrentPinModal({super.key});

  @override
  State<EnterCurrentPinModal> createState() => _EnterCurrentPinModalState();
}

class _EnterCurrentPinModalState extends State<EnterCurrentPinModal> {
  String _enteredPin = '';
  String _errorText = '';

  void _handleKeyPressed(String value) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += value;
        _errorText = '';
      });
      if (_enteredPin.length == 4) {
        _validatePin();
      }
    }
  }

  void _handleBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorText = '';
      });
    }
  }

  void _validatePin() {
    final cubit = context.read<SecurityCubit>();
    if (cubit.verifyPin(_enteredPin)) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _errorText = S.of(context).incorrectPin;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).enterCurrentPin,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          PinDisplay(pin: _enteredPin, length: 4),
          if (_errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorText,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 32),
          NumPad(
            onKeyPressed: _handleKeyPressed,
            onBackspacePressed: _handleBackspace,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
