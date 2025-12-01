import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/security/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).security),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: const SecuritySettingsList(),
    );
  }
}
