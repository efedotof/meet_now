import 'dart:developer';
import 'package:encrypt/encrypt.dart';
import 'package:meet_now_app/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pincode_storage_interface.dart';

class PincondeStorageRepository implements PincodeStorageInterface {
  final SharedPreferences preferences;
  static const _passwordKey = 'pin_code_keys';
  static final _encryptionKey = encryptionKey;

  PincondeStorageRepository({required this.preferences});

  @override
  Future<void> clearPinCode() async {
    try {
      await preferences.remove(_passwordKey);
      log('🗑️ PIN-код успешно удалён', name: 'PincondeStorageRepository');
    } catch (e, s) {
      log(
        '❌ Ошибка при удалении PIN-кода: $e',
        name: 'PincondeStorageRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  String getPinCode() {
    final combined = preferences.getString(_passwordKey);
    if (combined == null) {
      log('ℹ️ PIN-код не найден', name: 'PincondeStorageRepository');
      return '';
    }

    try {
      final parts = combined.split('::');
      if (parts.length != 2) {
        log(
          '⚠️ Неверный формат сохранённого PIN-кода',
          name: 'PincondeStorageRepository',
        );
        return '';
      }

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      final encrypter = Encrypter(AES(_encryptionKey));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      log('✅ PIN-код успешно расшифрован', name: 'PincondeStorageRepository');
      return decrypted;
    } catch (e, s) {
      log(
        '❌ Ошибка при расшифровке PIN-кода: $e',
        name: 'PincondeStorageRepository',
        error: e,
        stackTrace: s,
      );
      return '';
    }
  }

  @override
  Future<void> setPinCode({required String pincode}) async {
    try {
      final iv = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(_encryptionKey));
      final encrypted = encrypter.encrypt(pincode, iv: iv);
      final combined = '${iv.base64}::${encrypted.base64}';
      await preferences.setString(_passwordKey, combined);

      log('🔐 PIN-код успешно сохранён', name: 'PincondeStorageRepository');
    } catch (e, s) {
      log(
        '❌ Ошибка при сохранении PIN-кода: $e',
        name: 'PincondeStorageRepository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
