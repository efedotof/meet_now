import 'package:flutter/material.dart';
import 'package:meet_now_app/server/model/user/user.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat(
              icon: Icons.people,
              count: user.friends?.length ?? 0,
              label: "Друзья",
            ),
            _Stat(
              icon: Icons.favorite,
              count: user.purposes.length,
              label: "Цели",
            ),
            _Stat(
              icon: Icons.star,
              count: user.interests.length,
              label: "Интересы",
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.count, required this.label});
  final IconData icon;
  final int count;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
