import 'dart:io';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:dio/dio.dart';

class CategoryService extends BaseClient {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await get('category');
      print('API Response (getCategories): $res'); // Debug
      if (res['data'] == null || res['data']['categories'] == null) {
        print('Invalid API response: $res');
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
      if (image is File) {
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path, filename: 'category_image.jpg'),
        });
      } else {
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(image as List<int>, filename: 'category_image.jpg'),
        });
      }

      final res = await upload('category/upload', formData);
      print('API Response (uploadCategoryImage): $res'); // Debug
      return {
        'url': res['url'] as String,
        'publicId': res['public_id'] as String,
      };
    } catch (e) {
      print('Upload category image error: $e');
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
      print('API Response (createCategory): $res'); // Debug
      if (res['data'] == null) {
        print('Invalid API response: $res');
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
      print('API Response (updateCategory): $res'); // Debug
      if (res['data'] == null) {
        print('Invalid API response: $res');
        throw Exception('No category data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      print('Error in updateCategory: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final res = await delete('category/$id');
      print('API Response (deleteCategory): $res'); // Debug
    } catch (e) {
      print('Error in deleteCategory: $e');
      rethrow;
    }
  }

  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final res = await get('category?search=$query');
      print('API Response (searchCategories): $res'); // Debug
      if (res['data'] == null || res['data']['categories'] == null) {
        print('Invalid search API response: $res');
        throw Exception('No categories data found in search response');
      }
      final data = res['data']['categories'] as List<dynamic>;
      return data
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in searchCategories: $e');
      rethrow;
    }
  }
}