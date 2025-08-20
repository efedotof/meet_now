import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCurrentPinModal extends StatefulWidget {
  const EnterCurrentPinModal({super.key});

  @override
  State<EnterCurrentPinModal> createState() => _EnterCurrentPinModalState();
}

class _EnterCurrentPinModalState extends State<EnterCurrentPinModal> {
  late final TextEditingController _pinController;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
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
          const SizedBox(height: 24),
          PinCodeTextField(
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
            onChanged: (value) {
              if (value.length == 4) _validatePin();
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
            onPressed: _validatePin,
            child: Text(S.of(context).confirm),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _validatePin() {
    if (_pinController.text.length != 4) {
      if (mounted) setState(() => _errorText = S.of(context).enterFullPin);
      return;
    }

    final cubit = context.read<SecurityCubit>();
    if (cubit.verifyPin(_pinController.text)) {
      Navigator.pop(context, true);
    } else {
      if (mounted) {
        setState(() => _errorText = S.of(context).incorrectPin);
        _pinController.clear();
      }
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}