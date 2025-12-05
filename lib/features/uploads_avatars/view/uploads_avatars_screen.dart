import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/widget/widget.dart';

@RoutePage()
class UploadsAvatarsScreen extends StatefulWidget {
  const UploadsAvatarsScreen({super.key});

  @override
  State<UploadsAvatarsScreen> createState() => _UploadsAvatarsScreenState();
}

class _UploadsAvatarsScreenState extends State<UploadsAvatarsScreen> {
  @override
  Widget build(BuildContext context) {
    return const UploadsAvatarsView();
  }
}
