import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';
import 'package:meet_now_admin_panel/features/content/widget/widget.dart';
import 'package:meet_now_app_server/model/chats/chat_game/chat_game.dart';
import 'package:meet_now_app_server/model/gifts/admin_gift_dto/admin_gift_dto.dart';
import 'package:meet_now_app_server/model/social/city/city.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/icebreaker_topec.dart';
import 'package:meet_now_app_server/model/social/interes/interest.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack.dart';

@RoutePage()
class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const ContentNavigationBar(),

          Expanded(
            child: BlocBuilder<ContentCubit, ContentState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ContentCubit>().refresh();
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildContentHeader(context, state),
                        const SizedBox(height: 16),

                        if (state.isLoading && _getCurrentList(state).isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else ...[
                          ContentFilters(state: state),
                          const SizedBox(height: 16),

                          if (state.error != null)
                            _buildErrorWidget(state.error!),

                          // Список контента
                          _buildContentList(context, state),

                          if (state.totalPages > 1)
                            _buildPagination(context, state),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList(BuildContext context, ContentState state) {
    final items = _getCurrentList(state);

    if (items.isEmpty && !state.isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getEmptyIcon(state), size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                _getEmptyText(state),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _getEmptySubtext(state),
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _buildListItem(context, items[index]),
        ),
        // Добавляем отступ в конце списка для лучшего скроллинга
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, dynamic item) {
    // Временно используем простой виджет, можно заменить на ContentListItem
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[600]),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red[500],
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text('Удалить'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, String action, dynamic item) {
    switch (action) {
      case 'edit':
        // Реализация редактирования
        break;
      case 'delete':
        // Реализация удаления
        break;
    }
  }

  Widget _buildContentHeader(BuildContext context, ContentState state) {
    final title = _getTitle(state.currentContentType);
    final subtitle = _getSubtitle(state.currentContentType);
    final count = _getItemCount(state);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$subtitle • $count элементов',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const Spacer(),
            _buildAddButton(context, state.currentContentType),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, ContentType type) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _showCreateDialog(context, type),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Добавить',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ошибка: $error',
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[700], size: 20),
            onPressed: () {
              context.read<ContentCubit>().refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context, ContentState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: state.currentPage > 1
                      ? () => context.read<ContentCubit>().changePage(
                          state.currentPage - 1,
                        )
                      : null,
                  color: state.currentPage > 1 ? Colors.blue : Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey[300]!),
                      right: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text(
                    '${state.currentPage} из ${state.totalPages}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: state.currentPage < state.totalPages
                      ? () => context.read<ContentCubit>().changePage(
                          state.currentPage + 1,
                        )
                      : null,
                  color: state.currentPage < state.totalPages
                      ? Colors.blue
                      : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getCurrentList(ContentState state) {
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

  int _getItemCount(ContentState state) {
    switch (state.currentContentType) {
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
        return 'Темы для разговора';
      case ContentType.interests:
        return 'Интересы';
      case ContentType.purposes:
        return 'Цели';
      case ContentType.stickerPacks:
        return 'Наборы стикеров';
      case ContentType.stickers:
        return 'Стикеры';
      case ContentType.games:
        return 'Игры';
      case ContentType.gifts:
        return 'Подарки';
    }
  }

  String _getSubtitle(ContentType type) {
    switch (type) {
      case ContentType.cities:
        return 'Управление городами пользователей';
      case ContentType.icebreakers:
        return 'Темы для начала разговора';
      case ContentType.interests:
        return 'Интересы пользователей';
      case ContentType.purposes:
        return 'Цели знакомств';
      case ContentType.stickerPacks:
        return 'Наборы стикеров для чата';
      case ContentType.stickers:
        return 'Отдельные стикеры';
      case ContentType.games:
        return 'Игры в чатах';
      case ContentType.gifts:
        return 'Подарки и их редкости';
    }
  }

  IconData _getEmptyIcon(ContentState state) {
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

  String _getEmptyText(ContentState state) {
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

  String _getEmptySubtext(ContentState state) {
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

  // Метод для показа диалога создания
  void _showCreateDialog(BuildContext context, ContentType type) {
    // TODO: Перенести контроллеры и логику создания из ContentHeader
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Создание ${_getTitle(type).toLowerCase()}'),
        content: const Text('Здесь будет форма создания'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}
