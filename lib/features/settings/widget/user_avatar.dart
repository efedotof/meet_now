import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/uploads_avatars/cubit/uploads_avatars_cubit.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, this.avatarKey, required this.radius});

  final String? avatarKey;
  final double radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String? _presignedUrl;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPresignedUrl();
  }

  Future<void> _loadPresignedUrl() async {
    if (widget.avatarKey == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final cubit = context.read<UploadsAvatarsCubit>();
      final url = await cubit.getPresignedUrl(widget.avatarKey!);

      if (mounted) {
        setState(() => _presignedUrl = url);
      }
    } catch (e) {
      debugPrint("Произошла ошибка: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => FullscreenMediaView(
                    urlMedia: true,
                    urlMedial: _presignedUrl,
                  ),
            ),
          ),
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundImage:
            _presignedUrl != null ? NetworkImage(_presignedUrl!) : null,
        child:
            _presignedUrl == null
                ? Icon(Icons.person, size: widget.radius, color: Colors.white)
                : null,
      ),
    );
  }
}
