import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/exception/data_exception.dart';
import 'package:meet_now_app_server/model/auth/login/login.dart';
import 'package:meet_now_app_server/model/auth/user/user.dart';
import 'package:meet_now_app_server/model/keys/key_upload_request/key_upload_request.dart';
import 'package:meet_now_app_server/model/keys/salt_upload_request/salt_upload_request.dart';
import 'package:meet_now_app_server/repository/auth/auth_interface.dart';
import 'package:meet_now_app_server/repository/keys_api/keys_api_interface.dart';
import 'package:meet_now_app_server/service/logging/logger_service.dart';
import 'package:meet_now_app_server/storage/rsa_keys/rsa_keys_interface.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required AuthInterface authInterface,
    required RsaKeysInterface rsaKeys,
    required KeysApiInterface keysApi,
  }) : _authInterface = authInterface,
       _rsaKeys = rsaKeys,
       _keysApi = keysApi,
       super(SignInState.initial());

  final AuthInterface _authInterface;
  final RsaKeysInterface _rsaKeys;
  final KeysApiInterface _keysApi;
  final LoggerService _logger = LoggerService();

  void check({
    required TextEditingController username,
    required TextEditingController password,
  }) {
    final un = username.text.trim();
    final pass = password.text.trim();

    if (un.isNotEmpty && pass.isNotEmpty) {
      emit(SignInState.noEmpty());
    }
  }

  Future<void> login({
    required BuildContext context,
    required TextEditingController username,
    required TextEditingController password,
  }) async {
    final un = username.text.trim();
    final pass = password.text.trim();

    if (un.isEmpty || pass.isEmpty) {
      emit(
        SignInState.error(
          error: S.of(context).enter_your_username_and_password,
        ),
      );
      return;
    }

    emit(SignInState.loading());

    try {
      final loginData = Login(username: un, password: pass);
      final user = await _authInterface.login(login: loginData);

      await _ensureKeysExist(pass, user.id);

      emit(SignInState.success());

      if (context.mounted) {
        _checkAvatarUser(user: user, context: context);
      }
    } catch (e) {
      emit(SignInState.error(error: e.toString()));
    }
  }

  Future<void> _ensureKeysExist(String password, String userId) async {
    try {
      String salt;
      String encryptedPrivateKey;

      try {
        final saltResponse = await _keysApi.getSalt();
        final encryptedKeyResponse = await _keysApi.getEncryptedPrivateKey();
        salt = saltResponse.salt;
        encryptedPrivateKey = encryptedKeyResponse;
      } catch (e) {
        if (_isNotFoundError(e)) {
          _logger.info(
            'Keys not found on server, generating new keys for user $userId',
          );
          emit(SignInState.loadingKeys());
          final generatedKeys = await _generateAndUploadKeys(password, userId);
          salt = generatedKeys.salt;
          encryptedPrivateKey = generatedKeys.encryptedPrivateKey;
        } else {
          _logger.error('Error checking keys: $e');
          rethrow;
        }
      }

      await _rsaKeys.saveEncryptedPrivateKey(encryptedPrivateKey);

      final decryptedPrivateKey = await _rsaKeys.decryptPrivateKey(
        password,
        salt,
      );
      if (decryptedPrivateKey == null) {
        throw Exception(
          'Не удалось расшифровать приватный ключ. Проверьте пароль.',
        );
      }

      _logger.info('Private key successfully decrypted and stored');
    } catch (e) {
      _logger.error('Error ensuring keys: $e');
      throw Exception('Ошибка получения/расшифровки ключей: $e');
    }
  }

  bool _isNotFoundError(dynamic e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data?.toString().toLowerCase() ?? '';
      return statusCode == 404 ||
          data.contains('not found') ||
          data.contains('не найден') ||
          data.contains('не найдена');
    } else if (e is DataException) {
      final fullMessage = e.toString().toLowerCase();
      return fullMessage.contains('not found') ||
          fullMessage.contains('не найден') ||
          fullMessage.contains('не найдена');
    }
    return false;
  }

  Future<({String salt, String encryptedPrivateKey})> _generateAndUploadKeys(
    String password,
    String userId,
  ) async {
    try {
      final keys = await _rsaKeys.generateAndSaveKeysWithPasswordAndReturnSalt(
        password,
      );

      await _keysApi.uploadKeys(
        KeyUploadRequest(
          publicKey: keys.publicKey,
          encryptedPrivateKey: keys.encryptedPrivateKey,
        ),
      );
      await _keysApi.uploadSalt(SaltUploadRequest(salt: keys.salt));

      _logger.info('New keys generated and uploaded for user $userId');
      return (salt: keys.salt, encryptedPrivateKey: keys.encryptedPrivateKey);
    } catch (e) {
      _logger.error('Error generating and uploading keys: $e');
      throw Exception('Ошибка генерации и отправки ключей: $e');
    }
  }

  Future<void> _checkAvatarUser({
    required User user,
    required BuildContext context,
  }) async {
    if (user.avatar == null || user.avatar == "") {
      context.replaceRoute(UploadsAvatarsRoute());
    } else if (user.isBlocked != null && user.isBlocked == true) {
      context.replaceRoute(LockedRoute(blockReason: user.blockReason!));
    } else {
      context.router.replaceAll([MainHomeRoute()]);
    }
  }
}
