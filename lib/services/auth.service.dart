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
    String? email,
    required String password,
  }) async {
    final res = await super.post('signup', {
      'name': name,
      'phone': phone,
      if (email != null) 'email': email,
      'password': password,
    });
    return res;
  }

  // Đăng nhập
  Future<void> login(String identifier, String password) async {
    final res = await super.post('login', {
      identifier.contains('@') ? 'email' : 'phone': identifier,
      'password': password,
    });
    // Lưu token vào secure storage
    await _storage.write(key: 'access_token', value: res['accessToken']);
    await _storage.write(key: 'refresh_token', value: res['refreshToken']);
  }

  // Lấy thông tin người dùng
  Future<Map<String, dynamic>> getProfile() async {
    final res = await super.get('me');
    return res;
  }

  // Quên mật khẩu
  Future<void> forgotPassword(String identifier) async {
    await super.post('forgot-password', {
      identifier.contains('@') ? 'email' : 'phone': identifier,
    });
    // Xử lý nếu cần
  }

  // Kiểm tra mã OTP
  Future<void> verifyOtp({
    required String otpCode,
    required String id,
  }) async {
    await super.post('verify-otp', {
      'otp_code': otpCode,
      'id': id,
    });
  }

  // Reset mật khẩu
  Future<void> resetPassword({
    required String id,
    required String newPassword,
  }) async {
    await super.post('reset-password', {
      'id': id,
      'password': newPassword,
    });
  }
}
