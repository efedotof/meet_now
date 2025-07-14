import 'package:flutter/material.dart';
import 'package:meet_now_app/features/auth/view/sign_up/widget/sign_up_form_data.dart';

class AvatarPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final SignUpFormData formData;

  const AvatarPage({super.key, required this.formKey, required this.formData});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ваше фото', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child:
                    widget.formData.avatar.isEmpty
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            widget.formData.avatar,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: widget.formData.avatar,
              decoration: const InputDecoration(
                labelText: 'Ссылка на аватар',
                prefixIcon: Icon(Icons.link),
              ),
              onChanged:
                  (value) => setState(() => widget.formData.avatar = value),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Добавьте ссылку';
                if (!Uri.parse(value).isAbsolute) return 'Некорректная ссылка';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
