import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';

import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final menuTextColor = isDark ? Colors.black : Colors.white;
    final menuIconColor = isDark ? Colors.black : Colors.white;
    final menuBackgroundColor = isDark ? Colors.white70 : Colors.black87;

    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        final currentView = state.maybeWhen(
          loaded: (_, __, ___, ____, _____, ______, view) => view.name,
          orElse: () => 'Магазин',
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => context.maybePop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),

              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: PopupMenuButton<GiftView>(
                  onSelected: (GiftView value) {
                    context.read<GiftCubit>().changeView(value);
                  },
                  offset: const Offset(0, 45),

                  color: menuBackgroundColor,
                  surfaceTintColor: menuBackgroundColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    maxWidth: 300,
                  ),
                  padding: EdgeInsets.zero,

                  itemBuilder: (BuildContext context) {
                    return GiftView.values.map((view) {
                      return PopupMenuItem<GiftView>(
                        value: view,
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                view == GiftView.shop
                                    ? Icons.shopping_cart
                                    : Icons.inventory_2,
                                size: 20,
                                color: menuIconColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                view.name,
                                style: TextStyle(
                                  color: menuTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList();
                  },

                  splashRadius: 20,
                  tooltip: 'Выберите раздел',

                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            currentView,
                            style: TextStyle(
                              color: isDark ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: isDark ? Colors.black : Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Text(
                  "${context.read<UserModelAppInterface>().user!.gamePoints.toString()} points",
                  style: TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
