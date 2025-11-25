import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

class AvatarPage extends StatelessWidget {
  final UploadsAvatarsState state;
  final UploadsAvatarsCubit cubit;
  final VoidCallback onPickAvatar;
  final bool avatarConfirmed;
  final ValueChanged<bool> onAvatarConfirmedChange;

  const AvatarPage({
    super.key,
    required this.state,
    required this.cubit,
    required this.onPickAvatar,
    required this.avatarConfirmed,
    required this.onAvatarConfirmedChange,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = state.maybeWhen(
      avatarLoading: () => true,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              state.when(
                initial:
                    () => const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 70),
                    ),
                avatarSelected:
                    (filePath) => Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: FileImage(File(filePath)),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: cubit.removeAvatar,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                avatarLoading:
                    () => const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 70),
                    ),
                avatarUploadSuccess:
                    (url) => Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(url),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () {
                              cubit.removeAvatar();
                              onAvatarConfirmedChange(false);
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                gallerySelected:
                    (paths) => const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 70),
                    ),
                imagesUploadSuccess:
                    (urls) => const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 70),
                    ),
                imagesLoading:
                    () => const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 70),
                    ),
                error:
                    (message) => const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.person, size: 70),
                    ),
              ),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
          const SizedBox(height: 20),
          state.when(
            initial:
                () => const Text(
                  "Добавьте аватар профиля",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            avatarSelected:
                (filePath) => const Text(
                  "Аватар выбран. Подтвердите загрузку.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            avatarLoading:
                () => const Text(
                  "Загрузка аватара...",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            avatarUploadSuccess:
                (url) => const Text(
                  "Аватар успешно загружен!",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            gallerySelected:
                (paths) => const Text(
                  "Добавьте аватар профиля",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            imagesUploadSuccess:
                (urls) => const Text(
                  "Добавьте аватар профиля",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            imagesLoading:
                () => const Text(
                  "Добавьте аватар профиля",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            error:
                (message) => Text(
                  "Ошибка: $message",
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
          ),
          const SizedBox(height: 20),
          if (!isLoading)
            state.when(
              initial:
                  () => ElevatedButton(
                    onPressed: onPickAvatar,
                    child: const Text("Выбрать аватар"),
                  ),
              avatarSelected:
                  (filePath) => Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => cubit.confirmAndUploadAvatar(),
                        child: const Text("Подтвердить и загрузить аватар"),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: cubit.removeAvatar,
                        child: const Text("Удалить аватар"),
                      ),
                    ],
                  ),
              avatarUploadSuccess:
                  (url) => Column(
                    children: [
                      ElevatedButton(
                        onPressed: onPickAvatar,
                        child: const Text("Изменить аватар"),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          cubit.removeAvatar();
                          onAvatarConfirmedChange(false);
                        },
                        child: const Text("Удалить аватар"),
                      ),
                    ],
                  ),
              gallerySelected:
                  (paths) => ElevatedButton(
                    onPressed: onPickAvatar,
                    child: const Text("Выбрать аватар"),
                  ),
              imagesUploadSuccess:
                  (urls) => ElevatedButton(
                    onPressed: onPickAvatar,
                    child: const Text("Выбрать аватар"),
                  ),
              imagesLoading:
                  () => ElevatedButton(
                    onPressed: onPickAvatar,
                    child: const Text("Выбрать аватар"),
                  ),
              error:
                  (message) => ElevatedButton(
                    onPressed: onPickAvatar,
                    child: const Text("Выбрать аватар"),
                  ),
              avatarLoading: () => const SizedBox(),
            ),
        ],
      ),
    );
  }
}
