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

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) => _buildListItem(context, items[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getEmptyIcon(), size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _getEmptyText(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptySubtext(),
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getEmptyIcon() {
    switch (state.currentContentType) {
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

  String _getEmptyText() {
    switch (state.currentContentType) {
      case ContentType.cities:
        return 'Нет городов';
      case ContentType.icebreakers:
        return 'Нет тем для разговора';
      case ContentType.interests:
        return 'Нет интересов';
      case ContentType.purposes:
        return 'Нет целей';
      case ContentType.stickerPacks:
        return 'Нет наборов стикеров';
      case ContentType.stickers:
        return 'Нет стикеров';
      case ContentType.games:
        return 'Нет игр';
      case ContentType.gifts:
        return 'Нет подарков';
    }
  }

  String _getEmptySubtext() {
    switch (state.currentContentType) {
      case ContentType.cities:
        return 'Добавьте первый город для отображения в списке';
      case ContentType.icebreakers:
        return 'Создайте первую тему для начала разговора';
      case ContentType.interests:
        return 'Добавьте первый интерес пользователей';
      case ContentType.purposes:
        return 'Создайте первую цель знакомств';
      case ContentType.stickerPacks:
        return 'Добавьте первый набор стикеров';
      case ContentType.stickers:
        return 'Создайте первый стикер';
      case ContentType.games:
        return 'Игры появятся здесь после создания';
      case ContentType.gifts:
        return 'Добавьте первый подарок';
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

  Widget _buildListItem(BuildContext context, dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black.withAlpha(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildLeading(item),
        title: _buildTitle(item),
        subtitle: _buildSubtitle(item),
        trailing: _buildTrailing(context, item),
        onTap: () => _showEditDialog(context, item),
      ),
    );
  }

  Widget _buildLeading(dynamic item) {
    final icon = _getItemIcon(item);
    final color = _getItemColor(item);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withAlpha(1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildTitle(dynamic item) {
    return Text(
      _getItemTitle(item),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        _getItemSubtitle(item),
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, dynamic item) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[500]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (action) => _handleAction(context, action, item),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              const Text('Редактировать'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red[400], size: 20),
              const SizedBox(width: 8),
              const Text('Удалить'),
            ],
          ),
        ),
      ],
    );
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
    if (item is City) return 'Город • ID: ${item.id}';
    if (item is IcebreakerTopec) return 'Тема для разговора • ID: ${item.id}';
    if (item is Interest) return 'Интерес • ID: ${item.id}';
    if (item is Purpose) return 'Цель • ID: ${item.id}';
    if (item is StickerPack) {
      return 'Набор стикеров • ${item.stickers.length} стикеров';
    }
    if (item is Sticker) return 'Стикер • Набор: ${item.id}';
    if (item is ChatGame) return 'Игра • ${item.state}';
    if (item is AdminGiftDto) {
      return 'Подарок • ${item.isActive ? 'Активен' : 'Неактивен'}';
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактирование ${_getItemType(item)}'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 400),
          child: _buildEditForm(item),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление'),
        content: Text(
          'Вы уверены, что хотите удалить этот ${_getItemType(item)}?',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

  Widget _buildEditForm(dynamic item) {
    return Text('Форма редактирования для ${item.runtimeType}');
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
