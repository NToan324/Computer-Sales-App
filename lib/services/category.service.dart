import 'dart:io';
import 'dart:typed_data';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; // Added for MIME type lookup

class CategoryService extends BaseClient {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await get('category/admin');
      if (res['data'] == null || res['data']['categories'] == null) {
        throw Exception('No categories data found in response');
      }
      final data = res['data']['categories'] as List<dynamic>;
      return data
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in getCategories: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> uploadCategoryImage(dynamic image) async {
    try {
      FormData formData;
      String fileName;
      String? contentType;

      if (image is File) {
        fileName = image.path.split('/').last;
        contentType = lookupMimeType(fileName);
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: contentType != null ? MediaType.parse(contentType) : null,
          ),
        });
      } else if (image is Uint8List) {
        final mimeType = lookupMimeType('', headerBytes: image);
        if (mimeType == 'image/jpeg') {
          fileName = 'category_image.jpg';
          contentType = 'image/jpeg';
        } else if (mimeType == 'image/png') {
          fileName = 'category_image.png';
          contentType = 'image/png';
        } else {
          throw Exception('Unsupported image type: $mimeType');
        }
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            image,
            filename: fileName,
            contentType: MediaType.parse(contentType),
          ),
        });
      } else {
        throw Exception('Invalid image format');
      }

      // Debug form data
      formData.fields.forEach((field) => print('Field: ${field.key}, Value: ${field.value}'));
      formData.files.forEach((field) => print('File: ${field.key}, Filename: ${field.value.filename}, ContentType: ${field.value.contentType}'));

      final res = await upload('category/upload', formData);

      // Check and parse response
      if (res is Map<String, dynamic> && res.containsKey('data') && res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        final url = data['url'] as String?;
        final publicId = data['public_id'] as String?;

        if (url == null || publicId == null) {
          throw Exception('Missing URL or Public ID in response: $res');
        }

        return {
          'url': url,
          'publicId': publicId,
        };
      } else {
        throw Exception('Invalid response format: $res');
      }
    } catch (e) {
      print('Upload category image error: $e, Response: ${e is DioException ? e.response?.data : e.toString()}');
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getCategoryById(String id) async {
    try {
      final res = await get('category/$id');
      print('API Response (getCategoryById): $res'); // Debug
      if (res['data'] == null) {
        print('Invalid API response: $res');
        throw Exception('No category data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      print('Error in getCategoryById: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final res = await post('category', categoryData);
      if (res['data'] == null) {
        throw Exception('No category data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      print('Error in createCategory: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> categoryData) async {
    try {
      final res = await put('category/$id', categoryData);
      if (res['data'] == null) {
        throw Exception('No category data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final res = await delete('category/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final res = await get('category?search=$query');
      if (res['data'] == null || res['data']['categories'] == null) {
        throw Exception('No categories data found in search response');
      }
      final data = res['data']['categories'] as List<dynamic>;
      return data
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}