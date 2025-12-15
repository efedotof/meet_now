import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';

class ContentSidebar extends StatelessWidget {
  const ContentSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: BlocBuilder<ContentCubit, ContentState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.dashboard, color: Color(0xFF6366F1), size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Управление контентом',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildSidebarItem(
                      context,
                      'Города',
                      Icons.location_city,
                      ContentType.cities,
                      state.currentContentType,
                      count: state.cities?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Темы для разговора',
                      Icons.chat_bubble_outline,
                      ContentType.icebreakers,
                      state.currentContentType,
                      count: state.icebreakers?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Интересы',
                      Icons.favorite_border,
                      ContentType.interests,
                      state.currentContentType,
                      count: state.interests?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Цели',
                      Icons.flag_outlined,
                      ContentType.purposes,
                      state.currentContentType,
                      count: state.purposes?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Наборы стикеров',
                      Icons.emoji_emotions_outlined,
                      ContentType.stickerPacks,
                      state.currentContentType,
                      count: state.stickerPacks?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Стикеры',
                      Icons.emoji_emotions,
                      ContentType.stickers,
                      state.currentContentType,
                      count: state.stickers?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Игры',
                      Icons.sports_esports,
                      ContentType.games,
                      state.currentContentType,
                      count: state.games?.length ?? 0,
                    ),
                    _buildSidebarItem(
                      context,
                      'Подарки',
                      Icons.card_giftcard,
                      ContentType.gifts,
                      state.currentContentType,
                      count: state.gifts?.length ?? 0,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    String title,
    IconData icon,
    ContentType type,
    ContentType currentType, {
    required int count,
  }) {
    final isSelected = type == currentType;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF6366F1).withAlpha(1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: const Color(0xFF6366F1).withAlpha(2))
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[800],
            fontSize: 14,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        onTap: () => context.read<ContentCubit>().changeContentType(type),
      ),
    );
  }
}
