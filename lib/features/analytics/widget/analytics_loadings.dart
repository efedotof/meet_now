import 'package:flutter/material.dart';

class AnalyticsLoadings extends StatelessWidget {
  const AnalyticsLoadings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading analytics data...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
