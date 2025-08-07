import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SetPinModal extends StatefulWidget {
  const SetPinModal({super.key});

  @override
  State<SetPinModal> createState() => _SetPinModalState();
}

class _SetPinModalState extends State<SetPinModal> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  String _errorText = '';
  bool _isConfirming = false;

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
          const SizedBox(height: 24),
          PinCodeTextField(
            appContext: context,
            length: 4,
            controller: _isConfirming ? _confirmPinController : _pinController,
            obscureText: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Colors.grey,
              selectedColor: Theme.of(context).colorScheme.secondary,
            ),
            onChanged: (value) {
              if (value.length == 4) {
                if (!_isConfirming) {
                  setState(() => _isConfirming = true);
                } else {
                  _validatePins();
                }
              }
            },
          ),
          if (_errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorText,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isConfirming ? _validatePins : null,
            child: Text(S.of(context).confirm),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _validatePins() {
    if (_pinController.text == _confirmPinController.text) {
      Navigator.pop(context);
      context.read<SecurityCubit>().setPinCode(pincode: _pinController.text);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).pinSetSuccess)));
    } else {
      setState(() {
        _errorText = S.of(context).pinMismatch;
        _isConfirming = false;
        _pinController.clear();
        _confirmPinController.clear();
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}
