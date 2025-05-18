import 'dart:io';
import 'dart:typed_data';
import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; // Added for MIME type lookup

class BrandService extends BaseClient {
  Future<List<BrandModel>> getBrands() async {
    try {
      final res = await get('brand/admin');
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
          fileName = 'brand_image.jpg';
          contentType = 'image/jpeg';
        } else if (mimeType == 'image/png') {
          fileName = 'brand_image.png';
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

      final res = await upload('brand/upload', formData);

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
      print('Upload brand image error: $e, Response: ${e is DioException ? e.response?.data : e.toString()}');
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