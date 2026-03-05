import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class PurposePage extends StatefulWidget {
  final SignUpFormData formData;
  final double buttonWidth;

  const PurposePage({
    super.key,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  State<PurposePage> createState() => _PurposePageState();
}

class _PurposePageState extends State<PurposePage> {
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 30;

  int _loadedItemsCount = 0;
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _hasMore = true;

  List<Purpose> _allPurposes = [];
  List<Purpose> _visiblePurposes = [];

  late Future<List<Purpose>> _purposesFuture;

  @override
  void initState() {
    super.initState();
    _purposesFuture = _loadPurposes();
    _scrollController.addListener(_onScroll);
  }

  Future<List<Purpose>> _loadPurposes() async {
    final purpRepo = context.read<PurpAndInteresInterface>();
    final storage = !kIsWeb ? context.read<StorageHiveInterface>() : null;

    try {
      if (kIsWeb) {
        return await purpRepo.getAllPurpose();
      } else {
        if (storage is StorageHiveRepository) {
          try {
            final box = await storage.getListenablePurposeBox();

            if (!mounted) return [];

            final boxData = box.value;
            final List<Purpose> purposes = [];

            for (var i = 0; i < boxData.length; i++) {
              final key = boxData.keyAt(i);
              final value = boxData.get(key);
              if (value is Purpose) {
                purposes.add(value);
              }
            }

            return purposes;
          } catch (e) {
            return await purpRepo.getAllPurpose();
          }
        }

        return await purpRepo.getAllPurpose();
      }
    } catch (e) {
      return await purpRepo.getAllPurpose();
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= 100 && !_isLoadingMore && _hasMore) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    Future.microtask(() {
      if (!mounted) return;

      final nextCount = (_loadedItemsCount + _pageSize).clamp(
        0,
        _allPurposes.length,
      );

      setState(() {
        _loadedItemsCount = nextCount;
        _visiblePurposes = _allPurposes.take(_loadedItemsCount).toList();
        _hasMore = nextCount < _allPurposes.length;
        _isLoadingMore = false;
      });
    });
  }

  void _initData(List<Purpose> purposes) {
    _allPurposes = purposes;
    _loadedItemsCount = _pageSize.clamp(0, purposes.length);
    _visiblePurposes = purposes.take(_loadedItemsCount).toList();
    _hasMore = purposes.length > _loadedItemsCount;
    _isInitialLoading = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.buttonWidth),
        child: FutureBuilder<List<Purpose>>(
          future: _purposesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _PurposeError(
                onRetry: () {
                  setState(() {
                    _isInitialLoading = true;
                    _purposesFuture = _loadPurposes();
                    _loadedItemsCount = 0;
                    _allPurposes = [];
                    _visiblePurposes = [];
                    _hasMore = true;
                  });
                },
              );
            }

            if (_isInitialLoading && snapshot.hasData) {
              _initData(snapshot.data!);
            }

            return Column(
              children: [
                Text(
                  S.of(context).specify_your_goals,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              _visiblePurposes
                                  .map(
                                    (purpose) => PurposeChip(
                                      purpose: purpose,
                                      isDark: isDark,
                                      selected: widget.formData.purposes
                                          .contains(purpose.title),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value) {
                                            widget.formData.purposes.add(
                                              purpose.title!,
                                            );
                                          } else {
                                            widget.formData.purposes.remove(
                                              purpose.title,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 16),
                        if (_hasMore || _isLoadingMore)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child:
                                _isLoadingMore
                                    ? const CircularProgressIndicator()
                                    : Text(
                                      S.of(context).loading,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PurposeChip extends StatelessWidget {
  final Purpose purpose;
  final bool selected;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const PurposeChip({
    super.key,
    required this.purpose,
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: SizedBox(
        width: 110,
        child: Text(
          purpose.title ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color:
                selected
                    ? (isDark ? Colors.black : Colors.white)
                    : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      selected: selected,
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
      checkmarkColor: isDark ? Colors.black : Colors.white,
      visualDensity: VisualDensity.compact,
      onSelected: onChanged,
    );
  }
}

class _PurposeError extends StatelessWidget {
  final VoidCallback onRetry;

  const _PurposeError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).purpose_load_error),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(S.of(context).retry)),
        ],
      ),
    );
  }
}
