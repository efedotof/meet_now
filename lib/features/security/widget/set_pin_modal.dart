import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'num_pad.dart';
import 'pin_display.dart';

class SetPinModal extends StatefulWidget {
  const SetPinModal({super.key});

  @override
  State<SetPinModal> createState() => _SetPinModalState();
}

class _SetPinModalState extends State<SetPinModal> {
  String _newPin = '';
  String _confirmPin = '';
  String _errorText = '';
  bool _isConfirming = false;

  void _handleKeyPressed(String value) {
    setState(() {
      _errorText = '';
    });

    if (!_isConfirming) {
      if (_newPin.length < 4) {
        setState(() => _newPin += value);
      }
    } else {
      if (_confirmPin.length < 4) {
        setState(() => _confirmPin += value);
        if (_confirmPin.length == 4) {
          _validatePins();
        }
      }
    }
  }

  void _handleBackspace() {
    setState(() => _errorText = '');
    if (!_isConfirming) {
      if (_newPin.isNotEmpty) {
        setState(() => _newPin = _newPin.substring(0, _newPin.length - 1));
      }
    } else {
      if (_confirmPin.isNotEmpty) {
        setState(
          () => _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1),
        );
      }
    }
  }

  void _validatePins() {
    if (!_isConfirming) {
      if (_newPin.length == 4) {
        setState(() => _isConfirming = true);
      } else {
        setState(() => _errorText = S.of(context).enterFullPin);
      }
      return;
    }

    if (_newPin == _confirmPin) {
      final cubit = context.read<SecurityCubit>();
      cubit.setPinCode(pincode: _newPin);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).pinSetSuccess)));
    } else {
      setState(() {
        _errorText = S.of(context).pinMismatch;
        _newPin = '';
        _confirmPin = '';
        _isConfirming = false;
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
            _isConfirming ? S.of(context).confirmPin : S.of(context).setNewPin,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          PinDisplay(pin: _isConfirming ? _confirmPin : _newPin, length: 4),
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
          ElevatedButton(
            onPressed: _validatePins,
            child: Text(
              _isConfirming ? S.of(context).confirm : S.of(context).continues,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
