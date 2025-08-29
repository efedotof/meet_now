import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/server/model/purpose/purpose.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_interface.dart';

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
        _itemsToShow += 20; // подгружаем еще 20 элементов
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
              context.read<StorageHiveInterface>().listenablePurposeBox,
          builder: (context, box, child) {
            final allPurposes = box.values.cast<Purpose>().toList();
            final purposes = allPurposes.take(_itemsToShow).toList();

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              itemCount: (purposes.length / 3).ceil(),
              itemBuilder: (context, rowIndex) {
                final rowItems = purposes.skip(rowIndex * 3).take(3).toList();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        rowItems.map((purpose) {
                          final selected = widget.formData.interests.contains(
                            purpose.id,
                          );
                          return ChoiceChip(
                            label: Text(purpose.title ?? ''),
                            selected: selected,
                            onSelected:
                                (val) => setState(() {
                                  if (val) {
                                    widget.formData.interests.add(purpose.id);
                                  } else {
                                    widget.formData.interests.remove(
                                      purpose.id,
                                    );
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
