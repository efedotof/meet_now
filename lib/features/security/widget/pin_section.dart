import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'enter_current_pin_modal.dart';
import 'set_pin_modal.dart';

class PinSection extends StatelessWidget {
  final SecurityState state;
  const PinSection({super.key, required this.state});

  void _showPinSetupFlow(BuildContext context) async {
    final cubit = context.read<SecurityCubit>();
    bool? result = false;

    if (cubit.hasPinCode()) {
      result = await _showEnterCurrentPinModal(context);
      if (result != true) return;
    }

    if (context.mounted) {
      final newPinResult = await _showSetNewPinModal(context);
      if (newPinResult == true) {
        cubit.togglePin(true);
      } else if (!cubit.hasPinCode()) {
        cubit.togglePin(false);
      }
    }
  }

  Future<bool?> _showEnterCurrentPinModal(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => EnterCurrentPinModal(key: UniqueKey()),
    );
  }

  Future<bool?> _showSetNewPinModal(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SetPinModal(key: UniqueKey()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(S.of(context).enablePin),
          value: state.pinEnabled,
          onChanged: (value) {
            if (value) {
              _showPinSetupFlow(context);
            } else {
              context.read<SecurityCubit>().togglePin(false);
            }
          },
        ),
        if (state.pinEnabled) ...[
          const SizedBox(height: 8),
          ListTile(
            title: Text(S.of(context).changePin),
            leading: const Icon(Icons.lock_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPinSetupFlow(context),
          ),
        ],
      ],
    );
  }
}
