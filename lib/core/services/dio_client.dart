import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'secure_storage.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      responseType: ResponseType.json,
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Otomatis suntikkan Bearer Token jika ada
          final token = await SecureStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Di sini kamu bisa tambahkan logic kalau token expired (401)
          return handler.next(e);
        },
      ),
    );

  // Akses instance Dio
  static Dio get instance => _dio;
}