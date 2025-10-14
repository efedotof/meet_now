import 'dart:developer';
import 'package:encrypt/encrypt.dart';
import 'package:meet_now_app/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'password_storage_interface.dart';

class PasswordStorageRepository implements PasswordStorageInterface {
  final SharedPreferences preferences;
  static const _passwordKey = 'encrypted_password';
  static final _encryptionKey = encryptionKey;

  PasswordStorageRepository({required this.preferences});

  @override
  Future<void> setPassword({required String password}) async {
    try {
      final iv = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(_encryptionKey));
      final encrypted = encrypter.encrypt(password, iv: iv);
      final combined = '${iv.base64}::${encrypted.base64}';
      await preferences.setString(_passwordKey, combined);

      log(
        '🔐 Пароль успешно зашифрован и сохранён',
        name: 'PasswordStorageRepository',
      );
    } catch (e, s) {
      log(
        '❌ Ошибка при сохранении пароля: $e',
        name: 'PasswordStorageRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  String getPassword() {
    final combined = preferences.getString(_passwordKey);
    if (combined == null) {
      log('⚠️ Пароль не найден', name: 'PasswordStorageRepository');
      throw Exception('Пароль не установлен');
    }

    try {
      final parts = combined.split('::');
      if (parts.length != 2) {
        log(
          '⚠️ Неверный формат сохранённого пароля',
          name: 'PasswordStorageRepository',
        );
        throw Exception('Неверный формат сохранённого пароля');
      }

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      final encrypter = Encrypter(AES(_encryptionKey));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      log('✅ Пароль успешно расшифрован', name: 'PasswordStorageRepository');
      return decrypted;
    } catch (e, s) {
      log(
        '❌ Ошибка при расшифровке пароля: $e',
        name: 'PasswordStorageRepository',
        error: e,
        stackTrace: s,
      );
      throw Exception('Ошибка расшифровки пароля: $e');
    }
  }

  @override
  Future<void> clearPassword() async {
    try {
      await preferences.remove(_passwordKey);
      log('🗑️ Пароль успешно удалён', name: 'PasswordStorageRepository');
    } catch (e, s) {
      log(
        '❌ Ошибка при удалении пароля: $e',
        name: 'PasswordStorageRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
