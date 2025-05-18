import 'dart:io';

import 'package:computer_sales_app/models/user.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class UserService extends BaseClient {
  Future<UserModel> getUserInfoById() async {
    final response = await get('user/profile');
    return UserModel.fromJson(response['data']);
  }

  Future<UserImage> uploadAvatar({
    File? file,
    Uint8List? bytes,
    String? filename,
  }) async {
    if (!kIsWeb) {
      // Mobile platform, file phải khác null
      if (file == null || !file.existsSync()) {
        throw Exception('File does not exist');
      }
      final formData = await createMultipartFormDataMobile(file);
      final response = await upload('user/upload', formData);
      return UserImage.fromJson(response['data']);
    } else {
      // Web platform, bytes + filename phải khác null
      if (bytes == null || filename == null) {
        throw Exception('Bytes or filename is null on web');
      }
      final formData = createMultipartFormDataWeb(bytes, filename);
      final response = await upload('user/upload', formData);

      return UserImage.fromJson(response['data']);
    }
  }

  Future<FormData> createMultipartFormDataMobile(File file) async {
    final multipartFile = await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    );
    return FormData.fromMap({'file': multipartFile});
  }

  FormData createMultipartFormDataWeb(Uint8List bytes, String filename) {
    final multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: MediaType('image', 'jpeg'), // hoặc image/png tùy bạn
    );
    return FormData.fromMap({'file': multipartFile});
  }

  Future<UserModel> updateUserInfo({
    String? fullName,
    String? phone,
    String? address,
    UserImage? avatar,
  }) async {
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

    final response = await put(
      'user/profile',
      data,
    );

    return UserModel.fromJson(response['data']);
  }
}
