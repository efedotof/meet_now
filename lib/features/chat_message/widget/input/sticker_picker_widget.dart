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
                                'Стикеры',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  context.read<StickerCubit>().hideStickers();
                                },
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child:
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
                                          'Ошибка загрузки стикеров: $_error',
                                          style: TextStyle(
                                            color:
                                                isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: _loadStickers,
                                          child: const Text('Повторить'),
                                        ),
                                      ],
                                    ),
                                  )
                                  : _stickers.isEmpty
                                  ? Center(
                                    child: Text(
                                      'Стикеры не найдены',
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
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Center(
                                                        child: Icon(
                                                          Icons.error_outline,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
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
