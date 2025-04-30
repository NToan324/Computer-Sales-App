// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthService({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'http://localhost:3000/auth',
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        )),
        _storage = storage ?? const FlutterSecureStorage() {
    // Gắn interceptor để tự động thêm access token và xử lý 401
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final refresh = await _storage.read(key: 'refresh_token');
          if (refresh != null) {
            try {
              final r = await _dio.post('/tokens', data: {'refreshToken': refresh});
              final newAccess = r.data['accessToken'];
              await _storage.write(key: 'access_token', value: newAccess);
              // retry original request
              e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
              final retryRes = await _dio.fetch(e.requestOptions);
              return handler.resolve(retryRes);
            } catch (_) {}
          }
        }
        handler.next(e);
      },
    ));
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String phone,
    String? email,
    required String password,
  }) async {
    final res = await _dio.post('/signup', data: {
      'name': name,
      'phone': phone,
      if (email != null) 'email': email,
      'password': password,
    });
    return res.data;
  }

  Future<void> login(String identifier,String password) async {
    final res = await _dio.post('/login', data: {
      identifier.contains('@') ? 'email' : 'phone': identifier,
      'password': password,
    });
    await _storage.write(key: 'access_token', value: res.data['accessToken']);
    await _storage.write(key: 'refresh_token', value: res.data['refreshToken']);
  }

Future<Map<String, dynamic>> forgotPassword(String identifier) async {
  final res = await _dio.post('/forgot-password', data: {
    identifier.contains('@') ? 'email' : 'phone': identifier,
  });
  return res.data; 
}


  Future<void> verifyOtp({
    required String otpCode,
    required String id,
  }) async {
    await _dio.post('/verify-otp', data: {
      'otp_code': otpCode,
      'id': id,
    });
  }

  Future<void> resetPassword({
    required String id,
    required String newPassword,
  }) async {
    await _dio.post('/reset-password', data: {
      'id': id,
      'password': newPassword,
    });
  }

  Future<void> createGuest({
    required String name,
    String? phone,
  }) async {
    final res = await _dio.post('/guest', data: {
      'name': name,
      if (phone != null) 'phone': phone,
    });
    // giả sử API trả về token
    await _storage.write(key: 'access_token', value: res.data['token']);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await _dio.get('/me');
    return res.data;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
