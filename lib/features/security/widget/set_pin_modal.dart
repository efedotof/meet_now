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
  late final TextEditingController _pinController;
  late final TextEditingController _confirmPinController;
  String _errorText = '';
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _confirmPinController = TextEditingController();
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
          const SizedBox(height: 24),
          _isConfirming ? _buildConfirmPinField() : _buildNewPinField(),
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

  Widget _buildNewPinField() {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      controller: _pinController,
      obscureText: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Colors.grey,
        selectedColor: Theme.of(context).colorScheme.secondary,
      ),
      onChanged: (value) {},
    );
  }

  Widget _buildConfirmPinField() {
    return PinCodeTextField(
      appContext: context,
      key: ValueKey('confirm_pin_field'),
      length: 4,
      controller: _confirmPinController,
      obscureText: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Colors.grey,
        selectedColor: Theme.of(context).colorScheme.secondary,
      ),
      onChanged: (value) {
        if (value.length == 4) _validatePins();
      },
    );
  }

  void _validatePins() {
    if (!_isConfirming) {
      if (_pinController.text.length != 4) {
        setState(() => _errorText = S.of(context).enterFullPin);
        return;
      }
      setState(() {
        _isConfirming = true;
        _errorText = '';
        _confirmPinController.clear();
      });
      return;
    }

    if (_confirmPinController.text.length != 4) {
      setState(() => _errorText = S.of(context).enterFullPin);
      return;
    }

    if (_pinController.text == _confirmPinController.text) {
      final cubit = context.read<SecurityCubit>();
      cubit.setPinCode(pincode: _pinController.text);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).pinSetSuccess)));
    } else {
      setState(() {
        _errorText = S.of(context).pinMismatch;
        _pinController.clear();
        _isConfirming = false;
      });
      Future.delayed(Duration.zero, () {
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
