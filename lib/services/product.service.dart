import 'package:computer_sales_app/services/base_client.dart';

class ProductService extends BaseClient {
  ProductService() : super();

  // Lấy danh sách sản phẩm (basic)
  Future<List<dynamic>> getProducts() async {
    final res = await get('products');
    return res['data'];
  }

  // Lấy chi tiết sản phẩm
  Future<Map<String, dynamic>> getProductDetail(String id) async {
    final res = await get('product/$id');
    return res['data'];
  }

  // Tạo sản phẩm mới
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    final res = await post('products', productData);
    return res['data'];
  }

  // Cập nhật thông tin sản phẩm
  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> productData) async {
    final res = await put('product/$id', productData);
    return res['data'];
  }

  // Xoá sản phẩm
  Future<void> deleteProduct(String id) async {
    await delete('product/$id');
  }

  // 🔍 Tìm kiếm sản phẩm nâng cao với filter (có phân trang)
  // Future<Map<String, dynamic>> searchProducts({
  //   String? name,
  //   String? categoryId,
  //   String? brandId,
  //   double? minPrice,
  //   double? maxPrice,
  //   double? rating,
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   final res = await get('product/search', params: {
  //     if (name != null) 'name': name,
  //     if (categoryId != null) 'category_id': categoryId,
  //     if (brandId != null) 'brand_id': brandId,
  //     if (minPrice != null) 'min_price': minPrice.toString(),
  //     if (maxPrice != null) 'max_price': maxPrice.toString(),
  //     if (rating != null) 'rating': rating.toString(),
  //     'page': page.toString(),
  //     'limit': limit.toString(),
  //   });
  //   return res['data'];
  // }

  // 🌟 Lấy danh sách sản phẩm bán chạy
  Future<List<dynamic>> getTopSellingProducts() async {
    final res = await get('product/top-selling');
    return res['data'];
  }
  // Lấy danh sách các biến thể
  Future<List<dynamic>> getVariants() async {
    final res = await get('product/variant');
    return res['data']['data'];
  }
  // 🔄 Lấy danh sách biến thể của 1 sản phẩm
  Future<List<dynamic>> getVariantsByProduct(String productId) async {
    final res = await get('product/$productId/variant');
    return res['data'];
  }

  // ➕ Tạo biến thể mới cho sản phẩm
  Future<Map<String, dynamic>> createProductVariant(String productId, Map<String, dynamic> variantData) async {
    final res = await post('product/$productId/variant', variantData);
    return res['data'];
  }

  // 📝 Cập nhật biến thể sản phẩm
  Future<Map<String, dynamic>> updateProductVariant(String variantId, Map<String, dynamic> variantData) async {
    final res = await put('product/variants/$variantId', variantData);
    return res['data'];
  }

  // ❌ Xoá biến thể sản phẩm
  Future<void> deleteProductVariant(String variantId) async {
    await delete('product/variants/$variantId');
  }

  // // 🔍 Tìm kiếm biến thể
  // Future<Map<String, dynamic>> searchProductVariants({
  //   String? name,
  //   String? categoryId,
  //   String? brandId,
  //   double? minPrice,
  //   double? maxPrice,
  //   double? rating,
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   final res = await get('product/variants/search', params: {
  //     if (name != null) 'name': name,
  //     if (categoryId != null) 'category_id': categoryId,
  //     if (brandId != null) 'brand_id': brandId,
  //     if (minPrice != null) 'min_price': minPrice.toString(),
  //     if (maxPrice != null) 'max_price': maxPrice.toString(),
  //     if (rating != null) 'rating': rating.toString(),
  //     'page': page.toString(),
  //     'limit': limit.toString(),
  //   });
  //   return res['data'];
  // }
}
