import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

import 'enter_current_pin_modal.dart';
import 'set_pin_modal.dart';

class PinSection extends StatelessWidget {
  final SecurityState state;
  final bool isMobile;
  const PinSection({super.key, required this.state, required this.isMobile});

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
      } else if (!cubit.hasPinCode()) {
        cubit.togglePin(false);
      }
    }
  }

  Future<bool?> _showEnterCurrentPinModal(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: EnterCurrentPinModal(key: UniqueKey()),
        );
      },
    );
  }

  Future<bool?> _showSetNewPinModal(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SetPinModal(key: UniqueKey()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(
            S.of(context).enablePin,
            style: TextStyle(fontSize: isMobile ? null : 18),
          ),
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
            title: Text(
              S.of(context).changePin,
              style: TextStyle(fontSize: isMobile ? null : 16),
            ),
            leading: Icon(Icons.lock_outline, size: isMobile ? 24 : 28),
            trailing: Icon(Icons.chevron_right, size: isMobile ? 24 : 28),
            onTap: () => _showPinSetupFlow(context),
          ),
        ],
      ],
    );
  }
}
