import 'package:flutter/material.dart';

class UsersLoading extends StatelessWidget {
  const UsersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading users...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
