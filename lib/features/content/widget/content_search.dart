import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';

class ContentSearch extends StatelessWidget {
  const ContentSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          onChanged: (query) => context.read<ContentCubit>().search(query),
          decoration: InputDecoration(
            hintText: 'Search content...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[600]),
              onPressed: () => context.read<ContentCubit>().search(''),
            ),
          ),
        ),
      ),
    );
  }
}
