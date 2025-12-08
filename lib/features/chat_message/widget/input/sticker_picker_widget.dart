import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/model/social/sticker_pack/sticker_pack.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';
// TODO: Временно отключен функционал подарков
// import 'package:meet_now_app_server/model/social/user_inventory/user_inventory.dart';

class StickerPickerWidget extends StatefulWidget {
  final Function(Sticker) onStickerSelected;
  // TODO: Временно отключены параметры для подарков
  // final String recipientId;
  // final String chatId;
  // final String tempChatId;
  // final Function(bool)? onGiftSent;

  const StickerPickerWidget({
    super.key,
    required this.onStickerSelected,
    // TODO: Временно отключены параметры для подарков
    // required this.recipientId,
    // required this.chatId,
    // required this.tempChatId,
    // this.onGiftSent,
  });

  @override
  State<StickerPickerWidget> createState() => _StickerPickerWidgetState();
}

class _StickerPickerWidgetState extends State<StickerPickerWidget> {
  List<StickerPack> _stickerPacks = [];
  final Map<String, List<Sticker>> _stickersByPack = {};
  // TODO: Временно отключен функционал подарков
  // List<UserInventory> _userGifts = [];
  bool _isLoading = true;
  // TODO: Временно отключен функционал подарков
  // bool _isLoadingGifts = false;
  String? _error;
  final Map<String, String> _presignedUrlCache = {};
  // TODO: Временно изменена логика выбора пака (нет подарков)
  int _selectedPackIndex =
      0; // Теперь показываем первый пак стикеров по умолчанию
  final ScrollController _horizontalScrollController = ScrollController();
  // TODO: Временно отключен функционал подарков
  // bool _isSendingGift = false;

  @override
  void initState() {
    super.initState();
    _loadStickerPacks();
    // TODO: Временно отключен функционал подарков
    // _loadUserGifts();
  }

  Future<void> _loadStickerPacks() async {
    try {
      final cubit = context.read<StickerCubit>();
      final packs = await cubit.getAllStickerPacks();
      if (packs.isNotEmpty) {
        await _loadStickersForPack(packs.first.id);
      }

      setState(() {
        _stickerPacks = packs;
        _isLoading = false;
        _selectedPackIndex = 0; // Показываем первый пак стикеров
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // TODO: Временно отключен функционал подарков
  /*
  Future<void> _loadUserGifts() async {
    setState(() {
      _isLoadingGifts = true;
    });

    try {
      final cubit = context.read<StickerCubit>();
      final gifts = await cubit.getUserGifts();

      setState(() {
        _userGifts = gifts;
        _isLoadingGifts = false;
      });
    } catch (e) {
      debugPrint('Error loading user gifts: $e');
      setState(() {
        _isLoadingGifts = false;
      });
    }
  }

  Future<void> _sendGift(UserInventory inventory) async {
    if (_isSendingGift) return;

    setState(() {
      _isSendingGift = true;
    });

    try {
      final cubit = context.read<StickerCubit>();
      await cubit.sendGiftToChat(
        inventory: inventory,
        recipientId: widget.recipientId,
        chatId: widget.chatId,
        tempChatId: widget.tempChatId,
        message: '🎁 Подарок!',
        isAnonymous: false,
      );

      // Обновляем инвентарь после отправки
      await _loadUserGifts();

      // Скрываем панель стикеров
      context.read<StickerCubit>().hideStickers();

      // Уведомляем родительский виджет об успешной отправке
      widget.onGiftSent?.call(true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Подарок отправлен!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка отправки подарка: $e'),
          backgroundColor: Colors.red,
        ),
      );
      widget.onGiftSent?.call(false);
    } finally {
      setState(() {
        _isSendingGift = false;
      });
    }
  }
  */

  Future<void> _loadStickersForPack(String packId) async {
    if (_stickersByPack.containsKey(packId)) return;

    try {
      final cubit = context.read<StickerCubit>();
      final stickers = await cubit.getStickersByPack(packId);

      setState(() {
        _stickersByPack[packId] = stickers;
      });
    } catch (e) {
      debugPrint('Error loading stickers for pack $packId: $e');
    }
  }

  Future<String> _getPresignedUrl(String fileUrl) async {
    try {
      if (_presignedUrlCache.containsKey(fileUrl)) {
        return _presignedUrlCache[fileUrl]!;
      }

      final url = await context.read<UploadImageInterface>().getPresignedUrl(
        fileUrl,
      );
      _presignedUrlCache[fileUrl] = url;

      return url;
    } catch (e) {
      debugPrint('Error getting presigned URL: $e');
      throw Exception('Failed to get presigned URL: $e');
    }
  }

  List<Sticker> _getCurrentStickers() {
    // TODO: Временно отключен функционал подарков
    /*
    if (_selectedPackIndex == -1) {
      return _userGifts.map((inventory) {
        return Sticker(
          id: inventory.id,
          emoji: '🎁',
          imageUrl: inventory.gift.animationUrl ?? inventory.gift.imageUrl,
        );
      }).toList();
    } else 
    */
    if (_selectedPackIndex < _stickerPacks.length) {
      final packId = _stickerPacks[_selectedPackIndex].id;
      return _stickersByPack[packId] ?? [];
    }
    return [];
  }

  String _getCurrentPackName() {
    // TODO: Временно отключен функционал подарков
    /*
    if (_selectedPackIndex == -1) {
      return 'Подарки (${_userGifts.length})';
    } else 
    */
    if (_selectedPackIndex < _stickerPacks.length) {
      return _stickerPacks[_selectedPackIndex].title;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<StickerCubit, StickerState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: isDark ? Colors.black87 : Colors.white70,
            borderRadius: BorderRadius.circular(14),
          ),
          child: state.maybeWhen(
            visible:
                () => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                _getCurrentPackName(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              // TODO: Временно отключен функционал подарков
                              /*
                              if (_isSendingGift)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              */
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  // TODO: Временно отключена проверка на отправку подарка
                                  // if (!_isSendingGift) {
                                  context.read<StickerCubit>().hideStickers();
                                  // }
                                },
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child:
                              // TODO: Временно убрана загрузка подарков
                              // _isLoading || _isLoadingGifts
                              _isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : _error != null
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${S.of(context).sticker_loading_error} $_error",
                                          style: TextStyle(
                                            color:
                                                isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: _loadStickerPacks,
                                          child: Text(S.of(context).repeat),
                                        ),
                                      ],
                                    ),
                                  )
                                  : _getCurrentStickers().isEmpty
                                  ? Center(
                                    child: Text(
                                      // TODO: Временно изменен текст (нет подарков)
                                      // _selectedPackIndex == -1
                                      //     ? 'У вас пока нет подарков'
                                      //     :
                                      S.of(context).stickers_not_found,
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  )
                                  : GridView.builder(
                                    padding: const EdgeInsets.all(8),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          childAspectRatio: 1,
                                        ),
                                    itemCount: _getCurrentStickers().length,
                                    itemBuilder: (context, index) {
                                      final sticker =
                                          _getCurrentStickers()[index];
                                      // TODO: Временно отключен функционал подарков
                                      // final isGift = _selectedPackIndex == -1;

                                      return GestureDetector(
                                        onTap: () {
                                          // TODO: Временно отключен функционал подарков
                                          /*
                                          if (isGift) {
                                            final inventory = _userGifts[index];
                                            _sendGift(inventory);
                                          } else {
                                          */
                                          widget.onStickerSelected(sticker);
                                          context
                                              .read<StickerCubit>()
                                              .hideStickers();
                                          // }
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Stack(
                                            children: [
                                              FutureBuilder<String>(
                                                future: _getPresignedUrl(
                                                  sticker.imageUrl,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  } else if (snapshot.hasData) {
                                                    return Image.network(
                                                      snapshot.data!,
                                                      fit: BoxFit.contain,
                                                      loadingBuilder: (
                                                        context,
                                                        child,
                                                        loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null)
                                                          return child;
                                                        return Center(
                                                          child: CircularProgressIndicator(
                                                            value:
                                                                loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes!
                                                                    : null,
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                },
                                              ),
                                              // TODO: Временно отключен функционал подарков
                                              /*
                                              if (isGift)
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '×${_userGifts[index].quantity}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (isGift)
                                                const Positioned(
                                                  top: 4,
                                                  left: 4,
                                                  child: Icon(
                                                    Icons.card_giftcard,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              */
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SingleChildScrollView(
                            controller: _horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 8,
                              children: [
                                // TODO: Временно удалена вкладка подарков
                                /*
                                // Иконка подарка
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPackIndex = -1;
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          _selectedPackIndex == -1
                                              ? (isDark
                                                  ? Colors.blue[800]
                                                  : Colors.blue[100])
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.card_giftcard,
                                          color:
                                              _selectedPackIndex == -1
                                                  ? Colors.white
                                                  : (isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Подарки',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                _selectedPackIndex == -1
                                                    ? Colors.white
                                                    : (isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                */
                                // Список паков стикеров
                                ..._stickerPacks.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final pack = entry.value;
                                  final hasStickers = _stickersByPack
                                      .containsKey(pack.id);

                                  return GestureDetector(
                                    onTap: () {
                                      if (!hasStickers) {
                                        _loadStickersForPack(pack.id);
                                      }
                                      setState(() {
                                        _selectedPackIndex = index;
                                      });
                                    },
                                    child: Container(
                                      width: 80,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            _selectedPackIndex == index
                                                ? (isDark
                                                    ? Colors.blue[800]
                                                    : Colors.blue[100])
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (hasStickers &&
                                              _stickersByPack[pack.id]!
                                                  .isNotEmpty)
                                            SizedBox(
                                              height: 24,
                                              child: FutureBuilder<String>(
                                                future: _getPresignedUrl(
                                                  _stickersByPack[pack.id]!
                                                      .first
                                                      .imageUrl,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Image.network(
                                                      snapshot.data!,
                                                      fit: BoxFit.contain,
                                                    );
                                                  }
                                                  return Icon(
                                                    Icons.emoji_emotions,
                                                    color:
                                                        _selectedPackIndex ==
                                                                index
                                                            ? Colors.white
                                                            : (isDark
                                                                ? Colors.white
                                                                : Colors.black),
                                                    size: 24,
                                                  );
                                                },
                                              ),
                                            )
                                          else
                                            Icon(
                                              Icons.emoji_emotions,
                                              color:
                                                  _selectedPackIndex == index
                                                      ? Colors.white
                                                      : (isDark
                                                          ? Colors.white
                                                          : Colors.black),
                                              size: 24,
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            pack.title,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  _selectedPackIndex == index
                                                      ? Colors.white
                                                      : (isDark
                                                          ? Colors.white
                                                          : Colors.black),
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            orElse: () => const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
