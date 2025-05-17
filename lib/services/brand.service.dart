import 'dart:io';
import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:dio/dio.dart';

class BrandService extends BaseClient {
  Future<List<BrandModel>> getBrands() async {
    try {
      final res = await get('brand');
      print('API Response (getBrands): $res'); // Debug
      if (res['data'] == null || res['data']['brands'] == null) {
        print('Invalid API response: $res');
        throw Exception('No brands data found in response');
      }
      final data = res['data']['brands'] as List<dynamic>;
      return data
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in getBrands: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> uploadBrandImage(dynamic image) async {
    try {
      FormData formData;
      if (image is File) {
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path, filename: 'brand_image.jpg'),
        });
      } else {
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(image as List<int>, filename: 'brand_image.jpg'),
        });
      }

      final res = await upload('brand/upload', formData);
      print('API Response (uploadBrandImage): $res'); // Debug
      return {
        'url': res['url'] as String,
        'publicId': res['public_id'] as String,
      };
    } catch (e) {
      print('Upload brand image error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBrandById(String id) async {
    try {
      final res = await get('brand/$id');
      print('API Response (getBrandById): $res'); // Debug
      if (res['data'] == null) {
        print('Invalid API response: $res');
        throw Exception('No brand data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      print('Error in getBrandById: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createBrand(Map<String, dynamic> brandData) async {
    try {
      final res = await post('brand', brandData);
      print('API Response (createBrand): $res'); // Debug
      if (res['data'] == null) {
        print('Invalid API response: $res');
        throw Exception('No brand data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      print('Error in createBrand: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateBrand(String id, Map<String, dynamic> brandData) async {
    try {
      final res = await put('brand/$id', brandData);
      print('API Response (updateBrand): $res'); // Debug
      if (res['data'] == null) {
        print('Invalid API response: $res');
        throw Exception('No brand data found in response');
      }
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      print('Error in updateBrand: $e');
      rethrow;
    }
  }

  Future<void> deleteBrand(String id) async {
    try {
      final res = await delete('brand/$id');
      print('API Response (deleteBrand): $res'); // Debug
    } catch (e) {
      print('Error in deleteBrand: $e');
      rethrow;
    }
  }

  Future<List<BrandModel>> searchBrands(String query) async {
    try {
      final res = await get('brand?search=$query');
      print('API Response (searchBrands): $res'); // Debug
      if (res['data'] == null || res['data']['brands'] == null) {
        print('Invalid search API response: $res');
        throw Exception('No brands data found in search response');
      }
      final data = res['data']['brands'] as List<dynamic>;
      return data
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in searchBrands: $e');
      rethrow;
    }
  }
}