import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class PrivacyModeSwitch extends StatelessWidget {
  final SecurityState state;
  const PrivacyModeSwitch({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(S.of(context).privacyMode),
      subtitle: Text(S.of(context).privacyModeDescription),
      value: state.privacyMode,
      onChanged:
          (value) => context.read<SecurityCubit>().togglePrivacyMode(value),
    );
  }
}
