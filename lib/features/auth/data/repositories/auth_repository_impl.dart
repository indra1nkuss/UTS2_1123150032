import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseToken(String firebaseToken) async {
    final response = await DioClient.instance.post(
      ApiConstants.verifyToken,
      data: {'firebase_token': firebaseToken},
    );

    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    // Cek apakah request berhasil (statusCode 200)
    if (statusCode != 200 || responseData == null) {
      final message = responseData?['message'] ?? 'Gagal verifikasi token';
      final errorCode = responseData?['error_code'] ?? 'UNKNOWN_ERROR';
      debugPrint('[AUTH_REPO] Error $statusCode - $errorCode: $message');
      throw Exception('[$errorCode] $message');
    }

    // Pastikan data['data']['access_token'] ada
    final data = responseData['data'];
    if (data == null || data['access_token'] == null) {
      throw Exception('Response backend tidak mengandung access_token');
    }

    return data['access_token'] as String;
  }
}