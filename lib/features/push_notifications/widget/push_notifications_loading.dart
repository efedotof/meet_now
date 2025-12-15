import 'package:flutter/material.dart';

class PushNotificationsLoading extends StatelessWidget {
  const PushNotificationsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading notifications data...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
