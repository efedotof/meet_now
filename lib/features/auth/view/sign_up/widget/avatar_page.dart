import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';
import 'package:meet_now_app/generated/l10n.dart';

class AvatarPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;
  final double buttonWidth;

  const AvatarPage({
    super.key,
    required this.formKey,
    required this.formData,
    required this.buttonWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: buttonWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).yourPhoto,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  bool isLoading = false;
                  state.maybeMap(
                    avatarLoading: (_) {
                      isLoading = true;
                    },
                    orElse: () {
                      isLoading = false;
                    },
                  );

                  return Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap:
                              isLoading
                                  ? null
                                  : () => context
                                      .read<SignUpCubit>()
                                      .pickAndUploadAvatar(formData),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child:
                                formData.avatar.isEmpty
                                    ? const Icon(Icons.add_a_photo, size: 50)
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        "$uploadGetAddress${formData.avatar}",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                      ),
                                    ),
                          ),
                        ),
                        if (isLoading) const CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
