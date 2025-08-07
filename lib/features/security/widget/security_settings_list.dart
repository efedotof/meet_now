import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';

import 'auto_lock_switch.dart';
import 'pin_section.dart';
import 'privacy_mode_switch.dart';

class SecuritySettingsList extends StatelessWidget {
  const SecuritySettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecurityCubit, SecurityState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PinSection(state: state),
            const SizedBox(height: 16),
            PrivacyModeSwitch(state: state),
            const SizedBox(height: 16),
            AutoLockSwitch(state: state),
          ],
        );
      },
    );
  }
}
