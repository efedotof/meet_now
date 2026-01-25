import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class PurposesSearchDialog extends StatefulWidget {
  final List<String> selectedPurposes;
  final Function(List<String>) onPurposesUpdated;

  const PurposesSearchDialog({
    super.key,
    required this.selectedPurposes,
    required this.onPurposesUpdated,
  });

  @override
  State<PurposesSearchDialog> createState() => _PurposesSearchDialogState();
}

class _PurposesSearchDialogState extends State<PurposesSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _tempSelectedPurposes = [];
  late List<Purpose> _allPurposes = [];
  List<Purpose> _filteredPurposes = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedPurposes.addAll(widget.selectedPurposes);
    _searchController.addListener(_filterPurposes);
  }

  void _filterPurposes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPurposes =
          _allPurposes.where((purpose) {
            final title = purpose.title?.toLowerCase() ?? '';
            return title.contains(query);
          }).toList();
    });
  }

  void _togglePurpose(String purpose) {
    setState(() {
      if (_tempSelectedPurposes.contains(purpose)) {
        _tempSelectedPurposes.remove(purpose);
      } else {
        _tempSelectedPurposes.add(purpose);
      }
    });
  }

  void _applySelection() {
    widget.onPurposesUpdated(_tempSelectedPurposes);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              S.of(context).select_goals,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).goal_search,
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<Box>(
                valueListenable:
                    context.read<StorageHiveInterface>().listenablePurposeBox,
                builder: (context, box, child) {
                  _allPurposes = box.values.cast<Purpose>().toList();
                  if (_filteredPurposes.isEmpty) {
                    _filteredPurposes = _allPurposes;
                  }

                  return ListView.builder(
                    itemCount: _filteredPurposes.length,
                    itemBuilder: (context, index) {
                      final purpose = _filteredPurposes[index];
                      final isSelected = _tempSelectedPurposes.contains(
                        purpose.title,
                      );

                      return CheckboxListTile(
                        title: Text(purpose.title ?? ''),
                        value: isSelected,
                        onChanged: (_) => _togglePurpose(purpose.title!),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(S.of(context).cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applySelection,
                    child: Text(S.of(context).apply),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
