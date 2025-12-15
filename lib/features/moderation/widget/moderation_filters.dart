import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/moderation/cubit/moderation_cubit.dart';

class ModerationFilters extends StatelessWidget {
  const ModerationFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModerationCubit, ModerationState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterButton(
                context,
                'Pendung',
                ModerationFilter.PENDING,
                state.filter,
              ),
              const SizedBox(width: 8),
              _buildFilterButton(
                context,
                'Received',
                ModerationFilter.RECEIVED,
                state.filter,
              ),
              const SizedBox(width: 8),
              _buildFilterButton(
                context,
                'Resolved',
                ModerationFilter.RESOLVED,
                state.filter,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    String label,
    ModerationFilter filter,
    ModerationFilter selectedFilter,
  ) {
    final isSelected = filter == selectedFilter;
    return ElevatedButton(
      onPressed: () => context.read<ModerationCubit>().changeFilter(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[600] : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.grey[700],
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
