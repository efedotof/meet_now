import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/pin_code/cubit/pin_code_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/features/security/widget/pin_display.dart';
import 'package:meet_now_app/features/security/widget/num_pad.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class PinCodeScreen extends StatelessWidget {
  const PinCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<PinCodeCubit, PinCodeState>(
            listener: (context, state) {
              state.whenOrNull(
                authRequired: () => context.replaceRoute(const AuthRoute()),
                mainHomeRequired:
                    () => context.replaceRoute(const MainHomeRoute()),
                locked:
                    (blockReason) => context.replaceRoute(
                      LockedRoute(blockReason: blockReason),
                    ),
              );
            },
            builder: (context, state) {
              final currentPin = state.maybeWhen(
                entering: (pin) => pin,
                orElse: () => '',
              );

              final isProcessing = state.maybeWhen(
                processing: () => true,
                failure: () => true,
                orElse: () => false,
              );

              final hasError = state.maybeWhen(
                failure: () => true,
                orElse: () => false,
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).enterPinCode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  PinDisplay(pin: currentPin, length: 4),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        S.of(context).incorrectPinCode,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  IgnorePointer(
                    ignoring: isProcessing,
                    child: NumPad(
                      onKeyPressed: (digit) {
                        context.read<PinCodeCubit>().addDigit(
                          digit: digit,
                          currentPin: currentPin,
                        );
                      },
                      onBackspacePressed: () {
                        context.read<PinCodeCubit>().backspace(currentPin);
                      },
                    ),
                  ),
                  if (isProcessing)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
