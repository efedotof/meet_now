import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat_message/cubit/sticker/sticker_cubit.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

class StickerPickerWidget extends StatefulWidget {
  final Function(Sticker) onStickerSelected;

  const StickerPickerWidget({super.key, required this.onStickerSelected});

  @override
  State<StickerPickerWidget> createState() => _StickerPickerWidgetState();
}

class _StickerPickerWidgetState extends State<StickerPickerWidget> {
  List<Sticker> _stickers = [];
  bool _isLoading = true;
  String? _error;
  final Map<String, String> _presignedUrlCache = {};

  @override
  void initState() {
    super.initState();
    _loadStickers();
  }

  Future<void> _loadStickers() async {
    try {
      final cubit = context.read<StickerCubit>();
      final stickers = await cubit.getAllStickers();
      setState(() {
        _stickers = stickers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StickerCubit, StickerState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: state.maybeWhen(visible: () => 200, orElse: () => 0),
          curve: Curves.easeInOut,
          child: state.maybeWhen(
            visible:
                () => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'Стикеры',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                context.read<StickerCubit>().hideStickers();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : _error != null
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Ошибка загрузки стикеров: $_error'),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: _loadStickers,
                                        child: const Text('Повторить'),
                                      ),
                                    ],
                                  ),
                                )
                                : _stickers.isEmpty
                                ? const Center(
                                  child: Text('Стикеры не найдены'),
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
                                  itemCount: _stickers.length,
                                  itemBuilder: (context, index) {
                                    final sticker = _stickers[index];
                                    return GestureDetector(
                                      onTap: () {
                                        widget.onStickerSelected(sticker);
                                        context
                                            .read<StickerCubit>()
                                            .hideStickers();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color:
                                              Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: FutureBuilder<String>(
                                            future: _getPresignedUrl(
                                              sticker.imageUrl,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.error,
                                                  ),
                                                );
                                              } else if (snapshot.hasData) {
                                                return Image.network(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
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
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Center(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color:
                                                            Theme.of(
                                                              context,
                                                            ).colorScheme.error,
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
            orElse: () => const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
