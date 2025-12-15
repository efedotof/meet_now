import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/users/cubit/users_cubit.dart';

class UsersSearch extends StatelessWidget {
  final String searchQuery;

  const UsersSearch({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          onChanged: (query) => context.read<UsersCubit>().search(query),
          decoration: InputDecoration(
            hintText: 'Search users by username, email or name...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: () => context.read<UsersCubit>().search(''),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
