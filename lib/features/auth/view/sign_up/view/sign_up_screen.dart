import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/auth/view/sign_up/cubit/sign_up_cubit.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _subnameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  String _avatar = '';
  int _age = 0;
  List<String> _purposes = [];
  List<String> _interests = [];
  bool _isSearchable = false;

  void _onNextPressed(BuildContext context) {
    context.read<SignUpCubit>().check(
      username: _usernameController,
      email: _emailController,
      firstname: _firstnameController,
      subname: _subnameController,
      descriptio: _descriptionController,
      avatar: _avatar,
      city: _cityController,
      age: _age,
      purposes: _purposes,
      interests: _interests,
      isSearchable: _isSearchable,
      password: _passwordController,
    );
  }

  void _onRegisterPressed(BuildContext context) {
    context.read<SignUpCubit>().registration(
      username: _usernameController,
      email: _emailController,
      firstname: _firstnameController,
      subname: _subnameController,
      descriptio: _descriptionController,
      avatar: _avatar,
      city: _cityController,
      age: _age,
      purposes: _purposes,
      interests: _interests,
      isSearchable: _isSearchable,
      password: _passwordController,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: _subnameController,
              decoration: const InputDecoration(labelText: 'Фамилия'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Город'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Возраст'),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() {
                  _age = int.tryParse(val) ?? 0;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Ссылка на аватар'),
              onChanged: (val) => _avatar = val,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Примитивная реализация интересов и целей
            Wrap(
              spacing: 8,
              children:
                  ['Дружба', 'Любовь', 'Общение'].map((e) {
                    final selected = _purposes.contains(e);
                    return FilterChip(
                      label: Text(e),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _purposes.add(e);
                          } else {
                            _purposes.remove(e);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  ['Спорт', 'Игры', 'Книги', 'Музыка'].map((e) {
                    final selected = _interests.contains(e);
                    return FilterChip(
                      label: Text(e),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _interests.add(e);
                          } else {
                            _interests.remove(e);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isSearchable,
                  onChanged: (val) {
                    setState(() {
                      _isSearchable = val ?? false;
                    });
                  },
                ),
                const Text('Разрешить поиск моего профиля'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onNextPressed(context),
              child: const Text('Проверить данные'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _onRegisterPressed(context),
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
