import 'package:computer_sales_app/models/product.model.dart';
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
  Future<Map<String, dynamic>> createProduct(
      Map<String, dynamic> productData) async {
    final res = await post('products', productData);
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

  Future<List<dynamic>> getTopSellingProducts() async {
    final res = await get('product/top-selling');
    return res['data'];
  }

  Future<List<dynamic>> getVariants() async {
    final res = await get('product/variant');
    return res['data']['data'];
  }

  Future<List<dynamic>> getVariantsByProduct(String productId) async {
    final res = await get('product/$productId/variant');
    return res['data'];
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

  Future<List<ProductModel>> searchProductVariants({
    String? name,
    List<String>? categoryIds,
    List<String>? brandIds,
    double? minPrice,
    double? maxPrice,
    List<double>? ratings,
    String? sortPrice, // "asc" | "desc"
    String? sortName, // "asc" | "desc"
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
    if (ratings != null && ratings.isNotEmpty) {
      for (final r in ratings) {
        queryList.add('ratings=${r.toString()}');
      }
    }
    if (sortPrice != null) queryList.add('sort_price=$sortPrice');
    if (sortName != null) queryList.add('sort_name=$sortName');

    final uri = Uri.parse("product/variant/search?${queryList.join('&')}");
    final res = await get(uri.toString());
    return res['data'].map<ProductModel>((item) => ProductModel.fromJson(item)).toList();
  }
}
