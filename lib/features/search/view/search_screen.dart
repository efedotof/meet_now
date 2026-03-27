import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_mode/search_mode_cubit.dart';
import 'package:meet_now_app/features/search/widget/widget.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SearchModeCubit, SearchModeState>(
        builder: (context, state) {
          return state.when(
            isSearch: () => const AnonSearchScreen(),
            isCardSwiper: () => const CardSwiperScreen(),
          );
        },
      ),
    );
  }
}
