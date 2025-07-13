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
    final iv = IV.fromSecureRandom(16); // Новый случайный IV
    final encrypter = Encrypter(AES(_encryptionKey));
    final encrypted = encrypter.encrypt(password, iv: iv);

    // Сохраняем base64 пароля и iv вместе, разделённые символом ::
    final combined = '${iv.base64}::${encrypted.base64}';
    await preferences.setString(_passwordKey, combined);
  }

  @override
  String getPassword() {
    final combined = preferences.getString(_passwordKey);
    if (combined == null) {
      throw Exception('Пароль не установлен');
    }

    try {
      final parts = combined.split('::');
      if (parts.length != 2) {
        throw Exception('Неверный формат сохранённого пароля');
      }

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      final encrypter = Encrypter(AES(_encryptionKey));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      throw Exception('Ошибка расшифровки пароля: $e');
    }
  }
}
