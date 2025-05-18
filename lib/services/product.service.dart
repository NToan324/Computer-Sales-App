import 'dart:io';
import 'dart:typed_data';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:mime/mime.dart'; // Thêm import cho lookupMimeType
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

import '../models/product_entity.dart';

class ProductService extends BaseClient {
  ProductService() : super();

  //Upload ảnh sản phẩm
  Future<Map<String, String>> uploadProductImage(dynamic image) async {
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
          fileName = 'image.jpg';
          contentType = 'image/jpeg';
        } else if (mimeType == 'image/png') {
          fileName = 'image.png';
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

      formData.fields.forEach((field) => print('Field: ${field.key}, Value: ${field.value}'));
      formData.files.forEach((field) => print('File: ${field.key}, Filename: ${field.value.filename}, ContentType: ${field.value.contentType}'));

      final res = await upload('product/upload', formData);
      // Kiểm tra và lấy dữ liệu từ res['data']
      if (res is Map<String, dynamic> && res.containsKey('data') && res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        final url = data['url'] as String?;
        final publicId = data['public_id'] as String?;

        if (url == null || publicId == null) {
          throw Exception('Missing URL or Public ID in response: $res');
        }

        return {
          'url': url!,
          'publicId': publicId!,
        };
      } else {
        throw Exception('Invalid response format: $res');
      }
    } catch (e) {
      print('Upload product image error: $e, Response: ${e is DioException ? e.response?.data : e.toString()}');
      rethrow;
    }
  }
  // Lấy danh sách sản phẩm (basic)
  Future<List<dynamic>> getProducts() async {
    final res = await get('product/admin');
    return res['data'];
  }

  Future<ProductModel> getProductVariantById(String id) async {
    final res = await get('product/variant/$id/admin');
    return ProductModel.fromJson(res['data']['productVariant']);
  }

  // Lấy chi tiết sản phẩm
  Future<Map<String, dynamic>> getProductDetail(String id) async {
    final res = await get('product/$id');
    return res['data'];
  }

  // Tạo sản phẩm mới
  Future<Map<String, dynamic>> createProduct(
      Map<String, dynamic> productData) async {
    final res = await post('product', productData);
    return res['data'];
  }
  // Cập nhật thông tin sản phẩm
  Future<Map<String, dynamic>> updateProduct(
      String id, Map<String, dynamic> productData) async {
    final res = await put('product/$id', productData);
    return res['data'];
  }

  // Xoá sản phẩm
  Future<void> deleteProduct(String id) async {
    await delete('product/$id');
  }

  //Tìm kiếm sản phẩm
  Future<Map<String, dynamic>> searchProducts({
    String? name,
    List<String>? categoryIds,
    List<String>? brandIds,
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final queryList = <String>[];
      if (name != null && name.isNotEmpty) queryList.add('name=$name');
      if (categoryIds != null && categoryIds.isNotEmpty) {
        for (final id in categoryIds) {
          queryList.add('category_ids=$id');
        }
      }
      if (brandIds != null && brandIds.isNotEmpty) {
        for (final id in brandIds) {
          queryList.add('brand_ids=$id');
        }
      }
      queryList.add('page=$page');
      queryList.add('limit=$limit');

      final uri = Uri.parse('product/search?${queryList.join('&')}');
      final res = await get(uri.toString());

      if (res['data'] == null || res['data']['data'] == null) {
        return {
          'data': [],
          'totalPages': 0,
          'page': page,
          'limit': limit,
        };
      }

      return {
        'data': (res['data']['data'] as List)
            .map((item) => ProductEntity.fromMap(item as Map<String, dynamic>))
            .toList(),
        'totalPages': res['data']['totalPages'] ?? 1,
        'page': res['data']['page'] ?? page,
        'limit': res['data']['limit'] ?? limit,
      };
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<List<dynamic>> getTopSellingProducts() async {
    final res = await get('product/top-selling');
    return res['data'];
  }

  Future<Map<String, dynamic>> getVariants(
      {num page = 1, num limit = 10}) async {
    final res = await get('product/variant/admin?page=$page&limit=$limit');
    if (res['data'].length == 0) {
      return {
        'data': [] as List<ProductModel>,
        'totalPages': 0,
        'page': 0,
        'limit': 0,
      };
    }
    return {
      'totalPages': res['data']['totalPages'],
      'page': res['data']['page'],
      'limit': res['data']['limit'],
      'data': res['data']['data']
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList() as List<ProductModel>
    };
  }

  Future<Map<String, dynamic>> createProductVariant(
      String productId, Map<String, dynamic> variantData) async {
    final res = await post('product/$productId/variant', variantData);
    return res['data'];
  }

  Future<Map<String, dynamic>> updateProductVariant(
      String variantId, Map<String, dynamic> variantData) async {
    final res = await put('product/variants/$variantId', variantData);
    return res['data'];
  }

  Future<void> deleteProductVariant(String variantId) async {
    await delete('product/variants/$variantId');
  }

  Future<Map<String, dynamic>> getProductVariantsById(String variantId) async {
    final res = await get('product/variant/$variantId');
    return res['data'];
  }

  // 🔍 Tìm kiếm biến thể

  Future<Map<String, dynamic>> searchProductVariants({
    String? name,
    List<String>? categoryIds,
    List<String>? brandIds,
    double? minPrice,
    double? maxPrice,
    String? sortPrice, // "asc" | "desc"
    String? sortName, // "asc" | "desc"
    num? ratings,
    int page = 1,
    int limit = 12,
  }) async {
    final queryList = <String>[];

    if (name != null) queryList.add('name=$name');
    if (categoryIds != null && categoryIds.isNotEmpty) {
      for (final id in categoryIds) {
        queryList.add('category_ids=$id');
      }
    }
    if (brandIds != null && brandIds.isNotEmpty) {
      for (final id in brandIds) {
        queryList.add('brand_ids=$id');
      }
    }
    if (minPrice != null) queryList.add('min_price=$minPrice');
    if (maxPrice != null) queryList.add('max_price=$maxPrice');
    if (ratings != null) queryList.add('ratings=$ratings');
    if (sortPrice != null) queryList.add('sort_price=$sortPrice');
    if (sortName != null) queryList.add('sort_name=$sortName');
    queryList.add('page=$page');
    queryList.add('limit=$limit');

    final uri = Uri.parse("product/variant/search?${queryList.join('&')}");
    final res = await get(uri.toString());
    if (res['data'].length == 0) {
      return {
        'data': [],
        'totalPages': 0,
        'page': 0,
        'limit': 0,
      };
    }

    return {
      'totalPages': res['data']['totalPages'],
      'page': res['data']['page'],
      'limit': res['data']['limit'],
      'data': res['data']['data']
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList() as List<ProductModel>
    };
  }
}
