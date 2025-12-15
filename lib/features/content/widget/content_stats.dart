import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';

class ContentTypeStats extends StatelessWidget {
  const ContentTypeStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        return Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildStatItem(
                  'Города',
                  state.cities?.length.toString() ?? '0',
                  Icons.location_city,
                  const Color(0xFF6366F1),
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Темы',
                  state.icebreakers?.length.toString() ?? '0',
                  Icons.chat_bubble_outline,
                  const Color(0xFF10B981),
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Интересы',
                  state.interests?.length.toString() ?? '0',
                  Icons.favorite_border,
                  const Color(0xFFF59E0B),
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Цели',
                  state.purposes?.length.toString() ?? '0',
                  Icons.flag_outlined,
                  const Color(0xFFEF4444),
                ),
                const VerticalDivider(),
                _buildStatItem(
                  'Стикеры',
                  state.stickers?.length.toString() ?? '0',
                  Icons.emoji_emotions,
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
