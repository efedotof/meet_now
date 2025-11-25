import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app_server/storage/token/token_interface.dart';

import 'errors_widget.dart';
import 'gift_content.dart';
import 'loading_widget.dart';

class GiftView extends StatelessWidget {
  const GiftView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(context.read<TokenInterface>().getToken());
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин подарков')),
      body: BlocConsumer<GiftCubit, GiftState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            loaded:
                (
                  gifts,
                  inventory,
                  isDailyAvailable,
                  streak,
                  stats,
                  lastClaimed,
                ) => GiftContent(
                  gifts: gifts,
                  inventory: inventory,
                  isDailyAvailable: isDailyAvailable,
                  streak: streak,
                  stats: stats,
                  lastClaimedGift: lastClaimed,
                ),
            error: (message) => ErrorsWidget(message: message),
          );
        },
      ),
    );
  }
}
