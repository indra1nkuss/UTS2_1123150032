import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // FIX: Hapus encryptedSharedPreferences yang deprecated
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      // encryptedSharedPreferences dihapus - deprecated
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      accountName: 'flutter_secure_storage_service',
    ),
  );

  static const _keyAuthToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyEmail = 'user_email';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<void> saveUserData(String id, String email) async {
    await _storage.write(key: _keyUserId, value: id);
    await _storage.write(key: _keyEmail, value: email);
  }

  static Future<Map<String, String?>> getUserData() async {
    final id = await _storage.read(key: _keyUserId);
    final email = await _storage.read(key: _keyEmail);
    return {'id': id, 'email': email};
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}