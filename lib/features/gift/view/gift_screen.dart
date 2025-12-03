// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
// import 'package:meet_now_app/features/gift/widget/widget.dart';
// import 'package:skeletons_forked/skeletons_forked.dart';

// @RoutePage()
// class GiftScreen extends StatelessWidget {
//   const GiftScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) =>
//               GiftCubit(giftInterface: context.read())..loadInitialData(),
//       child: SkeletonTheme(
//         shimmerGradient: const LinearGradient(
//           colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
//           stops: [0.1, 0.5, 0.9],
//         ),
//         darkShimmerGradient: const LinearGradient(
//           colors: [
//             Color(0xFF222222),
//             Color(0xFF242424),
//             Color(0xFF2B2B2B),
//             Color(0xFF242424),
//             Color(0xFF222222),
//           ],
//           stops: [0.0, 0.2, 0.5, 0.8, 1],
//           begin: Alignment(-2.4, -0.2),
//           end: Alignment(2.4, 0.2),
//           tileMode: TileMode.clamp,
//         ),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Магазин подарков'),
//             scrolledUnderElevation: 0,
//             surfaceTintColor: Colors.transparent,
//           ),
//     body: BlocConsumer<GiftCubit, GiftState>(
//       listener: (context, state) {
//         state.maybeWhen(
//           error: (message) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(message)));
//           },
//           orElse: () {},
//         );
//       },
//       builder: (context, state) {
//         return state.when(
//           initial: () => const GiftSkeleton(),
//           loading: () => const GiftSkeleton(),
//           loaded:
//               (
//                 gifts,
//                 inventory,
//                 isDailyAvailable,
//                 streak,
//                 stats,
//                 lastClaimed,
//               ) => GiftContent(
//                 gifts: gifts,
//                 inventory: inventory,
//                 isDailyAvailable: isDailyAvailable,
//                 streak: streak,
//                 stats: stats,
//                 lastClaimedGift: lastClaimed,
//               ),
//           error: (message) => ErrorsWidget(message: message),
//         );
//       },
//     ),
//   ),
// ),
//     );
//   }
// }

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/features/gift/widget/inventory_grid.dart';
import 'package:meet_now_app/features/gift/widget/widget.dart';

@RoutePage()
class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create:
            (context) =>
                GiftCubit(giftInterface: context.read())..loadInitialData(),
        child: SafeArea(
          child: Column(
            children: [
              const AppBarWidget(),
              Expanded(
                child: BlocBuilder<GiftCubit, GiftState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (
                        gifts,
                        inventory,
                        isDailyGiftAvailable,
                        currentStreak,
                        giftStats,
                        lastClaimedGift,
                        currentView,
                      ) {
                        if (currentView == GiftView.shop) {
                          return GiftShopGrid(
                            gifts: gifts,
                            onGiftTap: (gift) {},
                          );
                        } else {
                          return InventoryGrid(
                            inventory: inventory,
                            onGiftTap: (inventoryItem) {},
                          );
                        }
                      },
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error:
                          (message) => Center(child: Text('Ошибка: $message')),
                      orElse:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
