abstract interface class TokenInterface {
  Future<void> saveToken(String token);
  String getToken();
  Future<void> clearToken();
}
