import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class AutoLockSwitch extends StatelessWidget {
  final SecurityState state;
  const AutoLockSwitch({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(S.of(context).autoLock),
      subtitle: Text(S.of(context).autoLockDescription),
      value: state.autoLock,
      onChanged: (value) => context.read<SecurityCubit>().toggleAutoLock(value),
    );
  }
}
