import 'package:flutter/material.dart';

class ContentLoading extends StatelessWidget {
  const ContentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading content...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
