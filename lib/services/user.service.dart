import 'dart:io';
import 'package:computer_sales_app/models/user.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import '../models/order.model.dart';

class UserService extends BaseClient {
  // Get user profile
  Future<UserModel> getUserInfoById() async {
    try {
      final response = await get('user/profile');
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Get user profile by ID (ADMIN)
  Future<UserModel> getUserProfileById(String userId) async {
    try {
      final response = await get('user/$userId');
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch user profile by ID: $e');
    }
  }

  // Get list of users (ADMIN)
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await get('user/');
      // Kiểm tra nếu response là Map và có trường 'data'
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is Map<String, dynamic> && data.containsKey('users')) {
          final users = data['users'];
          if (users is List) {
            return users.map((user) => UserModel.fromJson(user)).toList();
          } else {
            throw Exception('Unexpected users format: "users" is not a List');
          }
        } else {
          throw Exception('Invalid data format: No "users" field found in "data"');
        }
      } else {
        throw Exception('Invalid response format: No "data" field found');
      }
    } catch (e) {
      debugPrint('Get users error: $e'); // Log full error
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Search users (ADMIN)
  Future<List<UserModel>> searchUsers({
    String? name,
    String? email,
    String? role,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (name != null) queryParams['name'] = name;
      if (email != null) queryParams['email'] = email;
      if (role != null) queryParams['role'] = role;
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final response = await get('user/search', queryParameters: queryParams);
      return (response['data'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Get user's orders
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await get('user/orders');
      return (response['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Get orders by user ID (ADMIN)
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      final response = await get('user/$userId/orders');
      return (response['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders by user ID: $e');
    }
  }

  // Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final data = {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
      await put('user/change-password', data);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Update user info
  Future<UserModel> updateUserInfo({
    String? fullName,
    String? phone,
    String? address,
    UserImage? avatar,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (fullName != null && fullName.isNotEmpty) data['fullName'] = fullName;
      if (phone != null && phone.isNotEmpty) data['phone'] = phone;
      if (address != null && address.isNotEmpty) data['address'] = address;
      if (avatar != null) {
        data['avatar'] = {
          'url': avatar.url,
          'public_id': avatar.public_id,
        };
      }

      final response = await put('user/profile', data);
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update user info: $e');
    }
  }

  // Update user info by ID (ADMIN)
  Future<UserModel> updateUserInfoById({
    required String userId,
    String? fullName,
    String? phone,
    String? address,
    UserImage? avatar,
    bool? isActive,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (fullName != null && fullName.isNotEmpty) data['fullName'] = fullName;
      if (phone != null && phone.isNotEmpty) data['phone'] = phone;
      if (address != null && address.isNotEmpty) data['address'] = address;
      if (avatar != null) {
        data['avatar'] = {
          'url': avatar.url,
          'public_id': avatar.public_id,
        };
      }
      if (isActive != null) data['isActive'] = isActive;

      final response = await put('user/$userId', data);
      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update user info by ID: $e');
    }
  }

  // Upload avatar
  Future<UserImage> uploadAvatar({
    File? file,
    Uint8List? bytes,
    String? filename,
  }) async {
    try {
      if (!kIsWeb) {
        if (file == null || !file.existsSync()) {
          throw Exception('File does not exist');
        }
        final formData = await createMultipartFormDataMobile(file);
        final response = await upload('user/upload', formData);
        return UserImage.fromJson(response['data']);
      } else {
        if (bytes == null || filename == null) {
          throw Exception('Bytes or filename is null on web');
        }
        final formData = createMultipartFormDataWeb(bytes, filename);
        final response = await upload('user/upload', formData);
        return UserImage.fromJson(response['data']);
      }
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  Future<FormData> createMultipartFormDataMobile(File file) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
      return FormData.fromMap({'file': multipartFile});
    } catch (e) {
      throw Exception('Failed to create mobile form data: $e');
    }
  }

  FormData createMultipartFormDataWeb(Uint8List bytes, String filename) {
    try {
      final multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      );
      return FormData.fromMap({'file': multipartFile});
    } catch (e) {
      throw Exception('Failed to create web form data: $e');
    }
  }
}