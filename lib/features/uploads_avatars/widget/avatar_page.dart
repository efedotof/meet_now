import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';

class AvatarPage extends StatefulWidget {
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
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  String? _presignedUrl;
  bool _isLoading = false;

  void _loadPresignedUrl(String url) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final presignedUrl = await widget.cubit.getPresignedUrl(url);

      if (mounted) {
        setState(() {
          _presignedUrl = presignedUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Ошибка получения presigned URL: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void didUpdateWidget(AvatarPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.state.whenOrNull(
      avatarUploadSuccess: (url) {
        if (_presignedUrl == null || !_presignedUrl!.contains(url)) {
          _loadPresignedUrl(url);
        }
      },
      initial: () {
        if (_presignedUrl != null) {
          setState(() {
            _presignedUrl = null;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.maybeWhen(
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
              widget.state.when(
                initial: () => _buildDefaultAvatar(),
                avatarSelected: (uri, bytes) => _buildSelectedAvatar(bytes),
                avatarLoading: () => _buildLoadingAvatar(),
                avatarUploadSuccess: (url) => _buildUploadedAvatar(url),
                gallerySelected: (paths) => _buildDefaultAvatar(),
                imagesUploadSuccess: (urls) => _buildDefaultAvatar(),
                imagesLoading: () => _buildDefaultAvatar(),
                error: (message) => _buildDefaultAvatar(),
              ),
              if (isLoading || _isLoading) const CircularProgressIndicator(),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusText(),
          const SizedBox(height: 20),
          if (!isLoading && !_isLoading) _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.person, size: 70, color: Colors.white),
    );
  }

  Widget _buildSelectedAvatar(Uint8List bytes) {
    return Stack(
      children: [
        CircleAvatar(radius: 70, backgroundImage: MemoryImage(bytes)),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: widget.cubit.removeAvatar,
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingAvatar() {
    return const CircleAvatar(radius: 70, child: CircularProgressIndicator());
  }

  Widget _buildUploadedAvatar(String url) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage:
              _presignedUrl != null ? NetworkImage(_presignedUrl!) : null,
          child:
              _presignedUrl == null
                  ? const Icon(Icons.person, size: 70, color: Colors.white)
                  : null,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {
              widget.cubit.removeAvatar();
              widget.onAvatarConfirmedChange(false);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusText() {
    return widget.state.when(
      initial:
          () => const Text(
            "Добавьте аватар профиля",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
      avatarSelected:
          (uri, bytes) => const Text(
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
    );
  }

  Widget _buildActionButtons() {
    return widget.state.when(
      initial:
          () => ElevatedButton(
            onPressed: widget.onPickAvatar,
            child: const Text("Выбрать аватар"),
          ),
      avatarSelected:
          (uri, bytes) => Column(
            children: [
              ElevatedButton(
                onPressed: () => widget.cubit.confirmAndUploadAvatar(),
                child: const Text("Подтвердить и загрузить аватар"),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: widget.cubit.removeAvatar,
                child: const Text("Удалить аватар"),
              ),
            ],
          ),
      avatarUploadSuccess:
          (url) => Column(
            children: [
              ElevatedButton(
                onPressed: widget.onPickAvatar,
                child: const Text("Изменить аватар"),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  widget.cubit.removeAvatar();
                  widget.onAvatarConfirmedChange(false);
                },
                child: const Text("Удалить аватар"),
              ),
            ],
          ),
      gallerySelected:
          (paths) => ElevatedButton(
            onPressed: widget.onPickAvatar,
            child: const Text("Выбрать аватар"),
          ),
      imagesUploadSuccess:
          (urls) => ElevatedButton(
            onPressed: widget.onPickAvatar,
            child: const Text("Выбрать аватар"),
          ),
      imagesLoading:
          () => ElevatedButton(
            onPressed: widget.onPickAvatar,
            child: const Text("Выбрать аватар"),
          ),
      error:
          (message) => ElevatedButton(
            onPressed: widget.onPickAvatar,
            child: const Text("Выбрать аватар"),
          ),
      avatarLoading: () => const SizedBox(),
    );
  }
}
