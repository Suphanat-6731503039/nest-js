import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _jwtKey = 'jwt_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _jwtKey);
  }
}
