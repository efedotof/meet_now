abstract interface class PasswordStorageInterface {
  String getPassword();
  Future<void> setPassword({required String password});
}
