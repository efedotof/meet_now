import 'package:flutter/material.dart';

class SystemLoading extends StatelessWidget {
  const SystemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading system data...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
