import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class BottomBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onRegister;
  final double buttonWidth;

  const BottomBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onRegister,
    required this.buttonWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              orElse: () => ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                child: ElevatedButton(
                  onPressed: currentPage == totalPages - 1 ? onRegister : onNext,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    currentPage == totalPages - 1
                        ? S.of(context).register
                        : S.of(context).next,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}