class UsersNotFoundException implements Exception {
  final String message;
  UsersNotFoundException([this.message = 'Пользователей не найдено']);

  @override
  String toString() => message;
}
