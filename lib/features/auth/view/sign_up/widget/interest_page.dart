import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/model/social/interes/interest.dart';
import 'package:meet_now_app_server/storage/hive/repository/storage_hive_interface.dart';
import 'package:meet_now_app_server/storage/hive/repository/storage_hive_repository.dart';

class InterestPage extends StatefulWidget {
  final SignUpFormData formData;
  final double buttonWidth;

  const InterestPage({
    super.key,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 30;

  int _loadedItemsCount = 0;
  bool _isLoadingMore = false;
  bool _isLoadingInitial = true;
  bool _hasMore = true;

  List<Interest> _allInterests = [];
  List<Interest> _visibleInterests = [];

  late Future<ValueListenable<Box<Interest>>> _interestsFuture;

  @override
  void initState() {
    super.initState();
    _interestsFuture = _getListenableInterestBox();
    _scrollController.addListener(_onScroll);
  }

  Future<ValueListenable<Box<Interest>>> _getListenableInterestBox() async {
    final storage = context.read<StorageHiveInterface>();

    try {
      if (storage is StorageHiveRepository) {
        return await storage.getListenableInterestBox();
      }
      return storage.listenableInterestBox;
    } catch (_) {
      if (storage is StorageHiveRepository) {
        await storage.reopenInterestBox();
        return await storage.getListenableInterestBox();
      }
      rethrow;
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
        _allInterests.length,
      );

      setState(() {
        _loadedItemsCount = nextCount;
        _visibleInterests = _allInterests.take(_loadedItemsCount).toList();
        _hasMore = nextCount < _allInterests.length;
        _isLoadingMore = false;
      });
    });
  }

  void _initData(List<Interest> interests) {
    _allInterests = interests;
    _loadedItemsCount = _pageSize.clamp(0, interests.length);
    _visibleInterests = interests.take(_loadedItemsCount).toList();
    _hasMore = interests.length > _loadedItemsCount;
    _isLoadingInitial = false;
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
        child: FutureBuilder<ValueListenable<Box<Interest>>>(
          future: _interestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _InterestError(
                onRetry: () {
                  setState(() {
                    _isLoadingInitial = true;
                    _interestsFuture = _getListenableInterestBox();
                    _loadedItemsCount = 0;
                    _allInterests = [];
                    _visibleInterests = [];
                    _hasMore = true;
                  });
                },
              );
            }

            return ValueListenableBuilder<Box<Interest>>(
              valueListenable: snapshot.data!,
              builder: (context, box, _) {
                if (_isLoadingInitial) {
                  _initData(box.values.cast<Interest>().toList());
                }

                return Column(
                  children: [
                    Text(
                      S.of(context).specify_your_interests,
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
                                  _visibleInterests
                                      .map(
                                        (interest) => InterestChip(
                                          interest: interest,
                                          isDark: isDark,
                                          selected: widget.formData.interests
                                              .contains(interest.title),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value) {
                                                widget.formData.interests.add(
                                                  interest.title!,
                                                );
                                              } else {
                                                widget.formData.interests
                                                    .remove(interest.title);
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
                            if (!_hasMore && _visibleInterests.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  S.of(context).all_interests_loaded,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class InterestChip extends StatelessWidget {
  final Interest interest;
  final bool selected;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const InterestChip({
    super.key,
    required this.interest,
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
          interest.title ?? '',
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
      checkmarkColor: isDark ? Colors.black : Colors.white,
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
      visualDensity: VisualDensity.compact,
      onSelected: onChanged,
    );
  }
}

class _InterestError extends StatelessWidget {
  final VoidCallback onRetry;

  const _InterestError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).interest_load_error),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(S.of(context).retry)),
        ],
      ),
    );
  }
}
