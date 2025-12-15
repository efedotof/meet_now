import 'package:flutter/material.dart';

class ModerationLoading extends StatelessWidget {
  const ModerationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading moderation data...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
