// users_filters.dart
import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/users/widget/user_ui_models.dart';

class UsersFilters extends StatelessWidget {
  final UsersFilter filter;
  final UserSort sort;

  const UsersFilters({super.key, required this.filter, required this.sort});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButton<UsersFilter>(
                value: filter,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(Icons.filter_list, color: Colors.grey[600]),
                items: const [
                  DropdownMenuItem(
                    value: UsersFilter.all,
                    child: Text('All Users'),
                  ),
                  DropdownMenuItem(
                    value: UsersFilter.active,
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: UsersFilter.inactive,
                    child: Text('Inactive'),
                  ),
                  DropdownMenuItem(
                    value: UsersFilter.premium,
                    child: Text('Premium'),
                  ),
                  DropdownMenuItem(
                    value: UsersFilter.blocked,
                    child: Text('Blocked'),
                  ),
                ],
                onChanged: (filter) {
                  if (filter != null) {
                    // context.read<UsersCubit>().changeFilter(filter);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButton<UserSort>(
                value: sort,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(Icons.sort, color: Colors.grey[600]),
                items: const [
                  DropdownMenuItem(
                    value: UserSort.newest,
                    child: Text('Newest First'),
                  ),
                  DropdownMenuItem(
                    value: UserSort.oldest,
                    child: Text('Oldest First'),
                  ),
                  DropdownMenuItem(
                    value: UserSort.mostActive,
                    child: Text('Most Active'),
                  ),
                  DropdownMenuItem(
                    value: UserSort.leastActive,
                    child: Text('Least Active'),
                  ),
                  DropdownMenuItem(
                    value: UserSort.nameAZ,
                    child: Text('Name A-Z'),
                  ),
                  DropdownMenuItem(
                    value: UserSort.nameZA,
                    child: Text('Name Z-A'),
                  ),
                ],
                onChanged: (sort) {
                  if (sort != null) {
                    // context.read<UsersCubit>().changeSort(sort);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
