import 'package:flutter/material.dart';

class LoadingAvatar extends StatelessWidget {
  const LoadingAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(radius: 70, child: CircularProgressIndicator());
  }
}
