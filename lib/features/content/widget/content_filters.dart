import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';

class ContentFilters extends StatelessWidget {
  final ContentState state;

  const ContentFilters({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withAlpha(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Фильтры и поиск',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSearchField(context)),
                const SizedBox(width: 12),
                _buildAdditionalFilters(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      onChanged: (query) => context.read<ContentCubit>().search(query),
      decoration: InputDecoration(
        hintText: _getSearchHint(),
        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildAdditionalFilters(BuildContext context) {
    switch (state.currentContentType) {
      case ContentType.stickers:
        return _buildStickerPackFilter(context);
      case ContentType.games:
        return _buildGameTypeFilter(context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildStickerPackFilter(BuildContext context) {
    final packs = state.stickerPacks ?? [];

    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        initialValue: state.selectedPackId,
        decoration: InputDecoration(
          labelText: 'Набор стикеров',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('Все наборы', style: TextStyle(fontSize: 14)),
          ),
          ...packs.map(
            (pack) => DropdownMenuItem(
              value: pack.id,
              child: Text(
                pack.title,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        onChanged: (packId) {
          if (packId != null) {
            context.read<ContentCubit>().selectStickerPack(packId);
          }
        },
      ),
    );
  }

  Widget _buildGameTypeFilter(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        onChanged: (type) =>
            context.read<ContentCubit>().changeGameTypeFilter(type),
        decoration: InputDecoration(
          labelText: 'Тип игры',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  String _getSearchHint() {
    switch (state.currentContentType) {
      case ContentType.cities:
        return 'Поиск по названию города...';
      case ContentType.icebreakers:
        return 'Поиск по тексту темы...';
      case ContentType.interests:
        return 'Поиск по названию интереса...';
      case ContentType.purposes:
        return 'Поиск по названию цели...';
      case ContentType.stickerPacks:
        return 'Поиск по названию набора...';
      case ContentType.stickers:
        return 'Поиск по эмодзи...';
      case ContentType.games:
        return 'Поиск по типу игры...';
      case ContentType.gifts:
        return 'Поиск по названию подарка...';
    }
  }
}
