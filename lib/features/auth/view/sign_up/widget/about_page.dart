import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/storage/hive/repository/storage_hive_interface.dart';

class AboutPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;

  const AboutPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: widget.formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.buttonWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).tellAboutYourself,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                Text(
                  S.of(context).gender,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text(S.of(context).male),
                      selected: widget.formData.gender == 'м',
                      onSelected: (selected) {
                        setState(() {
                          widget.formData.gender = selected ? 'м' : '';
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: Text(S.of(context).female),
                      selected: widget.formData.gender == 'ж',
                      onSelected: (selected) {
                        setState(() {
                          widget.formData.gender = selected ? 'ж' : '';
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                TextFormField(
                  initialValue: widget.formData.description,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: S.of(context).description,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? S.of(context).tellAboutYourselfValidation
                              : null,
                  onChanged: (value) => widget.formData.description = value,
                ),

                const SizedBox(height: 24),
                Text(S.of(context).datingGoals),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        S.of(context).friendship,
                        S.of(context).love,
                        S.of(context).communication,
                      ].map((e) {
                        final selected = widget.formData.purposes.contains(e);
                        return ChoiceChip(
                          label: Text(e),
                          selected: selected,
                          onSelected:
                              (val) => setState(() {
                                if (val) {
                                  widget.formData.purposes.add(e);
                                } else {
                                  widget.formData.purposes.remove(e);
                                }
                              }),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),
                Text(
                  S.of(context).interests,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Box>(
                  valueListenable:
                      context
                          .read<StorageHiveInterface>()
                          .listenableInterestBox,
                  builder: (context, box, child) {
                    final interests = box.values.cast<String>().toList();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          interests.map((interest) {
                            final selected = widget.formData.interests.contains(
                              interest,
                            );
                            return ChoiceChip(
                              label: Text(interest),
                              selected: selected,
                              onSelected:
                                  (val) => setState(() {
                                    if (val) {
                                      widget.formData.interests.add(interest);
                                    } else {
                                      widget.formData.interests.remove(
                                        interest,
                                      );
                                    }
                                  }),
                            );
                          }).toList(),
                    );
                  },
                ),

                // Wrap(
                //   spacing: 8,
                //   runSpacing: 8,
                //   children:
                //       [
                //         S.of(context).sports,
                //         S.of(context).games,
                //         S.of(context).books,
                //         S.of(context).music,
                //       ].map((e) {
                //         final selected = widget.formData.interests.contains(e);
                //         return ChoiceChip(
                //           label: Text(e),
                //           selected: selected,
                //           onSelected:
                //               (val) => setState(() {
                //                 if (val) {
                //                   widget.formData.interests.add(e);
                //                 } else {
                //                   widget.formData.interests.remove(e);
                //                 }
                //               }),
                //         );
                //       }).toList(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
