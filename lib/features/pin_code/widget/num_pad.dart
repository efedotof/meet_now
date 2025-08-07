import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/pin_code/cubit/pin_code_cubit.dart';
import "digit_button.dart";

class NumPad extends StatelessWidget {
  const NumPad({super.key});
  final List<List<String>> buttons = const [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '←'],
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinCodeCubit, PinCodeState>(
      builder: (context, state) {
        final cubit = context.read<PinCodeCubit>();
        final isProcessing = state.maybeWhen(
          failure: (_) => true,
          success: () => true,
          orElse: () => false,
        );

        return Column(
          children:
              buttons.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      row.map((digit) {
                        return DigitButton(
                          digit: digit,
                          onPressed:
                              isProcessing
                                  ? null
                                  : () {
                                    if (digit == '←') {
                                      cubit.backspace(
                                        state.maybeWhen(
                                          entering: (pin) => pin,
                                          orElse: () => '',
                                        ),
                                      );
                                    } else if (digit.isNotEmpty) {
                                      cubit.addDigit(
                                        context: context,
                                        digit: digit,
                                        currentPin: state.maybeWhen(
                                          entering: (pin) => pin,
                                          orElse: () => '',
                                        ),
                                      );
                                    }
                                  },
                        );
                      }).toList(),
                );
              }).toList(),
        );
      },
    );
  }
}
