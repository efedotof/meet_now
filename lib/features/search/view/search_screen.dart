import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OutlinedButton(
              onPressed:
                  () => context.read<SearchCubit>().startRandomSearch(
                    context: context,
                  ),
              child: Text("Search"),
            ),
          ],
        ),
      ),
    );
  }
}
