import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/server/model/interes/interest.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_interface.dart';

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
  int _itemsToShow = 20; 

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      setState(() {
        _itemsToShow += 20; 
      });
    }
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
            final allInterests = box.values.cast<Interest>().toList();
            final interests = allInterests.take(_itemsToShow).toList();

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              itemCount: (interests.length / 3).ceil(),
              itemBuilder: (context, rowIndex) {
                final rowItems = interests.skip(rowIndex * 3).take(3).toList();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: rowItems.map((interest) {
                      final selected =
                          widget.formData.interests.contains(interest.id);
                      return ChoiceChip(
                        label: Text(interest.title ?? ''),
                        selected: selected,
                        onSelected: (val) => setState(() {
                          if (val) {
                            widget.formData.interests.add(interest.id);
                          } else {
                            widget.formData.interests.remove(interest.id);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
