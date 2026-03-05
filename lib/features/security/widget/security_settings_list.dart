import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/security/cubit/security_cubit.dart';
import 'pin_section.dart';

class SecuritySettingsList extends StatelessWidget {
  const SecuritySettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return BlocBuilder<SecurityCubit, SecurityState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          children: [
            PinSection(state: state, isMobile: isMobile),
            const SizedBox(height: 16),
            // PrivacyModeSwitch(state: state),
            // const SizedBox(height: 16),
            // AutoLockSwitch(state: state),
          ],
        );
      },
    );
  }
}
