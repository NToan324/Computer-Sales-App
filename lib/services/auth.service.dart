// lib/services/auth_service.dart
import 'package:computer_sales_app/services/base_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends BaseClient {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthService() : super();

  // Đăng ký tài khoản mới
  Future<Map<String, dynamic>> signup({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String password,
  }) async {
    final res = await post('auth/signup', {
      'fullName': name,
      'phone': phone,
      'email': email,
      'address': address,
      'password': password,
    });
    return res['data'];
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await post('auth/login', {
      'email': email,
      'password': password,
    });
    await _storage.write(key: 'access_token', value: res['accessToken']);
    await _storage.write(key: 'refresh_token', value: res['refreshToken']);
    return res['user'];
  }

  // Quên mật khẩu
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final res = await post('auth/forgot-password', {
     'email': email,
    });
    return res['data'];
  }

  // Kiểm tra mã OTP
  Future<void> verifyOtp({
    required String otpCode,
    required String id,
  }) async {
    await post('auth/verify-otp', {
      'otp_code': otpCode,
      'user_id': id,
    });
  }


  // Reset mật khẩu
  Future<void> forgetPasswordReset({
    required String id,
    required String newPassword,
  }) async {
    await post('auth/forgot-password-reset', {
      'id': id,
      'password': newPassword,
    });
  }
}
