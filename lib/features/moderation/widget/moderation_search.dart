import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';

class ModerationSearch extends StatelessWidget {
  const ModerationSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          onChanged: (query) => context.read<ModerationCubit>().search(query),
          decoration: InputDecoration(
            hintText: 'Search reports by reason or reporter...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[600]),
              onPressed: () => context.read<ModerationCubit>().search(''),
            ),
          ),
        ),
      ),
    );
  }
}
