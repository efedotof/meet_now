import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';
import 'package:meet_now_app_server/model/chats/chat_game/chat_game.dart';
import 'package:meet_now_app_server/model/gifts/admin_gift_dto/admin_gift_dto.dart';
import 'package:meet_now_app_server/model/social/city/city.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/icebreaker_topec.dart';
import 'package:meet_now_app_server/model/social/interes/interest.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack.dart';

class ContentList extends StatelessWidget {
  final ContentState state;

  const ContentList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final items = _getContentItems(state);

    if (items.isEmpty && !state.isLoading) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ContentCubit>().refresh();
      },
      child: ListView.separated(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildListItem(context, items[index]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getEmptyIcon(), size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            _getEmptyText(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _getEmptySubtext(),
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, dynamic item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withAlpha(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showEditDialog(context, item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _getItemColor(item).withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getItemIcon(item),
                    color: _getItemColor(item),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getItemTitle(item),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getItemSubtitle(item),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildTrailing(context, item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, dynamic item) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) => _handleAction(context, action, item),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue[600], size: 20),
              const SizedBox(width: 10),
              const Text('Редактировать'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red[500], size: 20),
              const SizedBox(width: 10),
              const Text('Удалить'),
            ],
          ),
        ),
      ],
    );
  }

  // Остальные методы остаются такими же...
  IconData _getEmptyIcon() {
    switch (state.currentContentType) {
      case ContentType.cities:
        return Icons.location_city_outlined;
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
        return Icons.sports_esports_outlined;
      case ContentType.gifts:
        return Icons.card_giftcard_outlined;
    }
  }

  String _getEmptyText() {
    switch (state.currentContentType) {
      case ContentType.cities:
        return 'Городов пока нет';
      case ContentType.icebreakers:
        return 'Тем для разговора нет';
      case ContentType.interests:
        return 'Интересов не найдено';
      case ContentType.purposes:
        return 'Целей пока нет';
      case ContentType.stickerPacks:
        return 'Наборов стикеров нет';
      case ContentType.stickers:
        return 'Стикеров пока нет';
      case ContentType.games:
        return 'Игр не найдено';
      case ContentType.gifts:
        return 'Подарков пока нет';
    }
  }

  String _getEmptySubtext() {
    switch (state.currentContentType) {
      case ContentType.cities:
        return 'Нажмите кнопку "Добавить", чтобы создать первый город';
      case ContentType.icebreakers:
        return 'Создайте первую тему для начала разговора';
      case ContentType.interests:
        return 'Добавьте интерес, чтобы пользователи могли его выбирать';
      case ContentType.purposes:
        return 'Создайте цель знакомства для пользователей';
      case ContentType.stickerPacks:
        return 'Добавьте первый набор стикеров';
      case ContentType.stickers:
        return 'Создайте стикер, чтобы пользователи могли его отправлять';
      case ContentType.games:
        return 'Игры появятся здесь после создания пользователями';
      case ContentType.gifts:
        return 'Добавьте подарок, который можно будет дарить';
    }
  }

  List<dynamic> _getContentItems(ContentState state) {
    switch (state.currentContentType) {
      case ContentType.cities:
        return state.cities ?? [];
      case ContentType.icebreakers:
        return state.icebreakers ?? [];
      case ContentType.interests:
        return state.interests ?? [];
      case ContentType.purposes:
        return state.purposes ?? [];
      case ContentType.stickerPacks:
        return state.stickerPacks ?? [];
      case ContentType.stickers:
        return state.stickers ?? [];
      case ContentType.games:
        return state.games ?? [];
      case ContentType.gifts:
        return state.gifts ?? [];
    }
  }

  IconData _getItemIcon(dynamic item) {
    if (item is City) return Icons.location_city;
    if (item is IcebreakerTopec) return Icons.chat_bubble_outline;
    if (item is Interest) return Icons.favorite_border;
    if (item is Purpose) return Icons.flag_outlined;
    if (item is StickerPack) return Icons.emoji_emotions_outlined;
    if (item is Sticker) return Icons.emoji_emotions;
    if (item is ChatGame) return Icons.sports_esports;
    if (item is AdminGiftDto) return Icons.card_giftcard;
    return Icons.help_outline;
  }

  Color _getItemColor(dynamic item) {
    if (item is City) return const Color(0xFF6366F1);
    if (item is IcebreakerTopec) return const Color(0xFF10B981);
    if (item is Interest) return const Color(0xFFF59E0B);
    if (item is Purpose) return const Color(0xFFEF4444);
    if (item is StickerPack) return const Color(0xFF8B5CF6);
    if (item is Sticker) return const Color(0xFF06B6D4);
    if (item is ChatGame) return const Color(0xFF84CC16);
    if (item is AdminGiftDto) return const Color(0xFFEC4899);
    return Colors.grey;
  }

  String _getItemTitle(dynamic item) {
    if (item is City) return item.nameCity;
    if (item is IcebreakerTopec) return item.text;
    if (item is Interest) return item.title ?? 'Без названия';
    if (item is Purpose) return item.title ?? 'Без названия';
    if (item is StickerPack) return item.title;
    if (item is Sticker) return item.emoji;
    if (item is ChatGame) return item.gameType;
    if (item is AdminGiftDto) return item.name;
    return 'Неизвестный элемент';
  }

  String _getItemSubtitle(dynamic item) {
    if (item is City) return 'ID: ${item.id} • Город';
    if (item is IcebreakerTopec) return 'ID: ${item.id} • Тема для разговора';
    if (item is Interest) return 'ID: ${item.id} • Интерес';
    if (item is Purpose) return 'ID: ${item.id} • Цель';
    if (item is StickerPack) {
      return 'Набор стикеров • ${item.stickers.length} шт.';
    }
    if (item is Sticker) return 'Стикер • Набор: ${item.id}';
    if (item is ChatGame) return 'Игра • ${item.state}';
    if (item is AdminGiftDto) {
      return '${item.isActive ? '✓ Активен' : '✗ Неактивен'} • ${item.costPoints} баллов';
    }
    return 'Дополнительная информация';
  }

  void _handleAction(BuildContext context, String action, dynamic item) {
    switch (action) {
      case 'edit':
        _showEditDialog(context, item);
        break;
      case 'delete':
        _showDeleteDialog(context, item);
        break;
    }
  }

  void _showEditDialog(BuildContext context, dynamic item) {
    // Реализация диалога редактирования
  }

  void _showDeleteDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление'),
        content: Text(
          'Вы уверены, что хотите удалить этот ${_getItemType(item)}?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteItem(context, item);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  String _getItemType(dynamic item) {
    if (item is City) return 'город';
    if (item is IcebreakerTopec) return 'тему для разговора';
    if (item is Interest) return 'интерес';
    if (item is Purpose) return 'цель';
    if (item is StickerPack) return 'набор стикеров';
    if (item is Sticker) return 'стикер';
    if (item is ChatGame) return 'игру';
    if (item is AdminGiftDto) return 'подарок';
    return 'элемент';
  }

  void _deleteItem(BuildContext context, dynamic item) {
    final cubit = context.read<ContentCubit>();

    if (item is City) cubit.deleteCity(item.id);
    if (item is IcebreakerTopec) cubit.deleteTopic(item.id);
    if (item is Interest) cubit.deleteInterest(item.id);
    if (item is Purpose) cubit.deletePurpose(item.id);
    if (item is StickerPack) cubit.deleteStickerPack(item.id);
    if (item is Sticker) cubit.deleteSticker(item.id);
    if (item is AdminGiftDto) cubit.deleteGift(item.id);
  }
}
