import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app_server/model/interes/interest.dart';
import 'package:meet_now_app_server/storage/hive/repository/storage_hive_interface.dart';

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
  int _currentPage = 0;
  List<Interest> _allInterests = [];
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

      if (startIndex >= _allInterests.length) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
        return;
      }

      setState(() {
        _currentPage = nextPage;
        _isLoading = false;
        _hasMore = (_currentPage + 1) * _pageSize < _allInterests.length;
      });
    });
  }

  List<Interest> get _visibleInterests {
    final endIndex = (_currentPage + 1) * _pageSize;
    return _allInterests.take(endIndex).toList();
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
              context.read<StorageHiveInterface>().listenableInterestBox,
          builder: (context, box, child) {
            _allInterests = box.values.cast<Interest>().toList();
            _hasMore = _allInterests.length > _pageSize;

            final interests = _visibleInterests;

            return Column(
              children: [

                Text("Укажите свои Интересы:"),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...interests.map((interest) {
                          final selected = widget.formData.interests.contains(
                            interest.title,
                          );
                          return ChoiceChip(
                            label: Text(interest.title ?? ''),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  widget.formData.interests.add(
                                    interest.title!,
                                  );
                                } else {
                                  widget.formData.interests.remove(
                                    interest.title,
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
