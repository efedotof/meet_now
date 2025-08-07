import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'set_pin_modal.dart';

class PinSection extends StatelessWidget {
  final SecurityState state;
  const PinSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).pinProtection,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(S.of(context).enablePin),
          value: state.pinEnabled,
          onChanged: (value) {
            context.read<SecurityCubit>().togglePin(value);
            if (value) {
              _showSetPinModal(context);
            }
          },
        ),
        if (state.pinEnabled) ...[
          const SizedBox(height: 8),
          ListTile(
            title: Text(S.of(context).changePin),
            leading: const Icon(Icons.lock_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSetPinModal(context),
          ),
        ],
      ],
    );
  }

  void _showSetPinModal(BuildContext context) {
    context.read<SecurityCubit>().setPinSetInProgress(true);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SetPinModal(),
    ).then((_) {
      if (context.mounted) {
        context.read<SecurityCubit>().setPinSetInProgress(false);
      }
    });
  }
}
