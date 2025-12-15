import 'package:flutter/material.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading dashboard data...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
