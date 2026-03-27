import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/card_swiper/card_swiper_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

class SearchFilterDrawer extends StatelessWidget {
  const SearchFilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).filters,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Text(S.of(context).age),
              const SizedBox(height: 10),
              BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      RangeSlider(
                        values: RangeValues(
                          (state.minAge ?? 18).toDouble(),
                          (state.maxAge ?? 60).toDouble(),
                        ),
                        min: 18,
                        max: 60,
                        divisions: 14,
                        labels: RangeLabels(
                          '${state.minAge ?? 18}',
                          '${state.maxAge ?? 60}',
                        ),
                        onChanged: (values) {
                          context.read<CardSwiperCubit>().updateAgeRange(
                            values.start.toInt(),
                            values.end.toInt(),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),

              Text(S.of(context).gender),
              const SizedBox(height: 10),
              BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  return RadioGroup<String>(
                    groupValue: state.gender,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<CardSwiperCubit>().updateGender(value);
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap:
                                () => context
                                    .read<CardSwiperCubit>()
                                    .updateGender('male'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Radio<String>(value: 'male'),
                                  const SizedBox(width: 8),
                                  Text(S.of(context).male),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap:
                                () => context
                                    .read<CardSwiperCubit>()
                                    .updateGender('female'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Radio<String>(value: 'female'),
                                  const SizedBox(width: 8),
                                  Text(S.of(context).female),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              Text(S.of(context).interests),
              const SizedBox(height: 10),
              BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  final availableInterests = [
                    'Спорт',
                    'Музыка',
                    'Кино',
                    'Книги',
                  ];
                  return Wrap(
                    spacing: 8,
                    children:
                        availableInterests.map((interest) {
                          final isSelected = state.interests.contains(interest);
                          return FilterChip(
                            label: Text(interest),
                            selected: isSelected,
                            onSelected: (_) {
                              context.read<CardSwiperCubit>().toggleInterest(
                                interest,
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),

              Text(S.of(context).datingGoals),
              const SizedBox(height: 10),
              BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  final availablePurposes = ['Дружба', 'Отношения', 'Общение'];
                  return Wrap(
                    spacing: 8,
                    children:
                        availablePurposes.map((purpose) {
                          final isSelected = state.purposes.contains(purpose);
                          return FilterChip(
                            label: Text(purpose),
                            selected: isSelected,
                            onSelected: (_) {
                              context.read<CardSwiperCubit>().togglePurpose(
                                purpose,
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),

              BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  return CheckboxListTile(
                    title: Text(S.of(context).onlyVerified),
                    value: state.verified ?? false,
                    onChanged: (value) {
                      context.read<CardSwiperCubit>().updateVerified(value);
                    },
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  context.read<CardSwiperCubit>().applyFilters();
                  Navigator.pop(context);
                },
                child: Text(S.of(context).apply),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
