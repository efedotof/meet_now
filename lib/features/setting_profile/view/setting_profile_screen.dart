import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/user/user.dart';

@RoutePage()
class SettingProfileScreen extends StatefulWidget {
  final User user;

  const SettingProfileScreen({super.key, required this.user});

  @override
  State<SettingProfileScreen> createState() => _SettingProfileScreenState();
}

class _SettingProfileScreenState extends State<SettingProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _firstnameController;
  late TextEditingController _subnameController;
  late TextEditingController _descriptionController;
  late TextEditingController _cityController;
  late TextEditingController _ageController;
  late List<String> _interests;
  late List<String> _purposes;
  late bool _isSearchable;

  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _firstnameController = TextEditingController(
      text: widget.user.firstname ?? '',
    );
    _subnameController = TextEditingController(text: widget.user.subname ?? '');
    _descriptionController = TextEditingController(
      text: widget.user.description ?? '',
    );
    _cityController = TextEditingController(text: widget.user.city ?? '');
    _ageController = TextEditingController(
      text: widget.user.age?.toString() ?? '',
    );
    _interests = List.from(widget.user.interests);
    _purposes = List.from(widget.user.purposes);
    _isSearchable = widget.user.isSearchable;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstnameController.dispose();
    _subnameController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _interestController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _addInterest() {
    if (_interestController.text.isNotEmpty) {
      setState(() {
        _interests.add(_interestController.text);
        _interestController.clear();
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

  void _addPurpose() {
    if (_purposeController.text.isNotEmpty) {
      setState(() {
        _purposes.add(_purposeController.text);
        _purposeController.clear();
      });
    }
  }

  void _removePurpose(String purpose) {
    setState(() {
      _purposes.remove(purpose);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование профиля'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => context.maybePop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        widget.user.avatar != null
                            ? NetworkImage(
                              "$uploadGetAddress${widget.user.avatar!}",
                            )
                            : null,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    child:
                        widget.user.avatar == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white70,
                            )
                            : null,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.black : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 20),
                      onPressed: () {
                        // Логика загрузки фото
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Имя пользователя',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: 'Имя',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subnameController,
                      decoration: InputDecoration(
                        labelText: 'Фамилия',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Город',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Возраст',
                        prefixIcon: const Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'О себе',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Видим в поиске'),
                      subtitle: const Text(
                        'Другие пользователи могут найти вас',
                      ),
                      value: _isSearchable,
                      onChanged: (value) {
                        setState(() {
                          _isSearchable = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Мои интересы', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _interests
                              .map(
                                (interest) => Chip(
                                  label: Text(interest),
                                  onDeleted: () => _removeInterest(interest),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _interestController,
                            decoration: InputDecoration(
                              hintText: 'Добавьте интерес',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addInterest,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(14),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Цели знакомства', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _purposes
                              .map(
                                (purpose) => Chip(
                                  label: Text(purpose),
                                  onDeleted: () => _removePurpose(purpose),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _purposeController,
                            decoration: InputDecoration(
                              hintText: 'Добавьте цель',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addPurpose,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(14),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
