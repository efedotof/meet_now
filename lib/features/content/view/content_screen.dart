import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_admin_panel/features/content/cubit/content_cubit.dart';
import 'package:meet_now_admin_panel/features/content/widget/widget.dart';

@RoutePage()
class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          const ContentSidebar(),
          Expanded(
            child: Column(
              children: [
                const ContentHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocBuilder<ContentCubit, ContentState>(
                      builder: (context, state) {
                        if (state.isLoading && _getCurrentList(state).isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          children: [
                            ContentFilters(state: state),
                            const SizedBox(height: 16),
                            Expanded(child: ContentList(state: state)),
                            if (state.totalPages > 1)
                              _buildPagination(context, state),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getCurrentList(ContentState state) {
    switch (state.currentContentType) {
      case ContentType.cities:
        return state.cities ?? [];
      case ContentType.icebreakers:
        return state.icebreakers ?? [];
      case ContentType.interests:
        return state.interests ?? [];
      case ContentType.purposes:
        return state.purposes ?? [];
      case ContentType.stickerPacks:
        return state.stickerPacks ?? [];
      case ContentType.stickers:
        return state.stickers ?? [];
      case ContentType.games:
        return state.games ?? [];
      case ContentType.gifts:
        return state.gifts ?? [];
    }
  }

  Widget _buildPagination(BuildContext context, ContentState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: state.currentPage > 1
                ? () => context.read<ContentCubit>().changePage(
                    state.currentPage - 1,
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              'Страница ${state.currentPage} из ${state.totalPages}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: state.currentPage < state.totalPages
                ? () => context.read<ContentCubit>().changePage(
                    state.currentPage + 1,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
