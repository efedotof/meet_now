import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';
import 'sign_up_form_data.dart';

class AvatarPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;

  const AvatarPage({super.key, required this.formKey, required this.formData});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ваше фото', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () {
                  context.read<SignUpCubit>().pickAndUploadAvatar(formData);
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
            ),
            const SizedBox(height: 24),
            // TextFormField(
            //   initialValue: formData.avatar,
            //   decoration: const InputDecoration(
            //     labelText: 'Ссылка на аватар',
            //     prefixIcon: Icon(Icons.link),
            //   ),
            //   onChanged: (value) => formData.avatar = value,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) return 'Добавьте ссылку';
            //     if (!Uri.parse(value).isAbsolute) return 'Некорректная ссылка';
            //     return null;
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
