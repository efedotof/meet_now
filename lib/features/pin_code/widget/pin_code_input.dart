import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/pin_code/cubit/pin_code_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeInput extends StatelessWidget {
  const PinCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinCodeCubit, PinCodeState>(
      builder: (context, state) {
        String currentPin = state.maybeWhen(
          entering: (pin) => pin,
          orElse: () => '',
        );

        return PinCodeTextField(
          appContext: context,
          length: 4,
          obscureText: true,
          animationType: AnimationType.fade,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          keyboardType: TextInputType.none,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.circle,
            borderRadius: BorderRadius.circular(10),
            fieldHeight: 24,
            fieldWidth: 24,
            activeFillColor: Colors.transparent,
            inactiveFillColor: Colors.grey[200],
            activeColor: Theme.of(context).primaryColor,
            selectedColor: Colors.blueAccent,
            inactiveColor: Colors.grey,
          ),
          onChanged: (value) {},
          onCompleted: (value) {},
          beforeTextPaste: (text) => false,
          controller: TextEditingController(text: currentPin),
          readOnly: true,
          enablePinAutofill: false,
          errorAnimationController: state.maybeWhen(
            failure:
                () =>
                    StreamController<ErrorAnimationType>()
                      ..add(ErrorAnimationType.shake),
            orElse: () => null,
          ),
        );
      },
    );
  }
}
