import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';

class ContentNavigationBar extends StatelessWidget {
  const ContentNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return _buildDesktopNavigation(context, state);
            } else if (constraints.maxWidth > 600) {
              return _buildTabletNavigation(context, state);
            } else {
              return _buildMobileNavigation(context, state);
            }
          },
        );
      },
    );
  }

  Widget _buildDesktopNavigation(BuildContext context, ContentState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.dashboard, color: Color(0xFF6366F1), size: 24),
          const SizedBox(width: 5),
          const Text(
            'Контентом',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          _buildHorizontalNavigationChips(context, state),
        ],
      ),
    );
  }

  Widget _buildHorizontalNavigationChips(
    BuildContext context,
    ContentState state,
  ) {
    return Container(
      height: 40,
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: ContentType.values.map((type) {
            final isSelected = state.currentContentType == type;
            final count = _getCount(state, type);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildNavigationChip(
                context,
                type,
                isSelected,
                count,
                showIcon: true,
                showText: true,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabletNavigation(BuildContext context, ContentState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: ContentType.values.map((type) {
            final isSelected = state.currentContentType == type;
            final count = _getCount(state, type);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildNavigationChip(
                context,
                type,
                isSelected,
                count,
                showIcon: true,
                showText: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileNavigation(BuildContext context, ContentState state) {
    final currentType = state.currentContentType;
    final count = _getCount(state, currentType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(_getIcon(currentType), color: const Color(0xFF6366F1), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(currentType),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$count элементов',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildMobileNavigationButton(context, state),
        ],
      ),
    );
  }

  Widget _buildMobileNavigationButton(
    BuildContext context,
    ContentState state,
  ) {
    return PopupMenuButton<ContentType>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (type) =>
          context.read<ContentCubit>().changeContentType(type),
      itemBuilder: (context) => ContentType.values.map((type) {
        return PopupMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(_getIcon(type), color: const Color(0xFF6366F1), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_getTitle(type), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getCount(state, type).toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationChip(
    BuildContext context,
    ContentType type,
    bool isSelected,
    int count, {
    required bool showIcon,
    required bool showText,
  }) {
    return GestureDetector(
      onTap: () => context.read<ContentCubit>().changeContentType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withAlpha(10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getIcon(type),
                color: isSelected ? const Color(0xFF6366F1) : Colors.grey[600],
                size: 16,
              ),
              if (showText) const SizedBox(width: 6),
            ],
            if (showText) ...[
              Text(
                _getTitle(type),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.grey[700],
                ),
              ),
              const SizedBox(width: 6),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6366F1) : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCount(ContentState state, ContentType type) {
    switch (type) {
      case ContentType.cities:
        return state.cities?.length ?? 0;
      case ContentType.icebreakers:
        return state.icebreakers?.length ?? 0;
      case ContentType.interests:
        return state.interests?.length ?? 0;
      case ContentType.purposes:
        return state.purposes?.length ?? 0;
      case ContentType.stickerPacks:
        return state.stickerPacks?.length ?? 0;
      case ContentType.stickers:
        return state.stickers?.length ?? 0;
      case ContentType.games:
        return state.games?.length ?? 0;
      case ContentType.gifts:
        return state.gifts?.length ?? 0;
    }
  }

  String _getTitle(ContentType type) {
    switch (type) {
      case ContentType.cities:
        return 'Города';
      case ContentType.icebreakers:
        return 'Темы';
      case ContentType.interests:
        return 'Интересы';
      case ContentType.purposes:
        return 'Цели';
      case ContentType.stickerPacks:
        return 'Наборы';
      case ContentType.stickers:
        return 'Стикеры';
      case ContentType.games:
        return 'Игры';
      case ContentType.gifts:
        return 'Подарки';
    }
  }

  IconData _getIcon(ContentType type) {
    switch (type) {
      case ContentType.cities:
        return Icons.location_city;
      case ContentType.icebreakers:
        return Icons.chat_bubble_outline;
      case ContentType.interests:
        return Icons.favorite_border;
      case ContentType.purposes:
        return Icons.flag_outlined;
      case ContentType.stickerPacks:
        return Icons.emoji_emotions_outlined;
      case ContentType.stickers:
        return Icons.emoji_emotions;
      case ContentType.games:
        return Icons.sports_esports;
      case ContentType.gifts:
        return Icons.card_giftcard;
    }
  }
}
