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
    await preferences.remove(_passwordKey);
  }

  @override
  String getPinCode() {
    final combined = preferences.getString(_passwordKey);
    if (combined == null) {
      return '';
    }

    try {
      final parts = combined.split('::');
      if (parts.length != 2) {
        return '';
      }

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      final encrypter = Encrypter(AES(_encryptionKey));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      return '';
    }
  }

  @override
  Future<void> setPinCode({required String pincode}) async {
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(_encryptionKey));
    final encrypted = encrypter.encrypt(pincode, iv: iv);
    final combined = '${iv.base64}::${encrypted.base64}';
    await preferences.setString(_passwordKey, combined);
  }
}
