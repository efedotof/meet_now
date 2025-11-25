import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose.dart';

import 'package:meet_now_app_server/storage/hive/repository/storage_hive_interface.dart';

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
  int _currentPage = 0;
  List<Purpose> _allPurposes = [];
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      final nextPage = _currentPage + 1;
      final startIndex = nextPage * _pageSize;

      if (startIndex >= _allPurposes.length) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
        return;
      }

      setState(() {
        _currentPage = nextPage;
        _isLoading = false;
        _hasMore = (_currentPage + 1) * _pageSize < _allPurposes.length;
      });
    });
  }

  List<Purpose> get _visiblePurposes {
    final endIndex = (_currentPage + 1) * _pageSize;
    return _allPurposes.take(endIndex).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.buttonWidth),
        child: ValueListenableBuilder<Box>(
          valueListenable:
              context.read<StorageHiveInterface>().listenablePurposeBox,
          builder: (context, box, child) {
            _allPurposes = box.values.cast<Purpose>().toList();
            _hasMore = _allPurposes.length > _pageSize;

            final purposes = _visiblePurposes;

            return Column(
              children: [
                Text("Укажите свои Цели:"),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...purposes.map((purpose) {
                          final selected = widget.formData.purposes.contains(
                            purpose.title,
                          );
                          return ChoiceChip(
                            label: Text(purpose.title ?? ''),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  widget.formData.purposes.add(purpose.title!);
                                } else {
                                  widget.formData.purposes.remove(
                                    purpose.title,
                                  );
                                }
                              });
                            },
                          );
                        }),

                        if (_isLoading)
                          const SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
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
