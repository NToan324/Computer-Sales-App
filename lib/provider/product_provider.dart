import 'package:computer_sales_app/consts/index.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/models/product_entity.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/services/brand.service.dart';
import 'package:computer_sales_app/services/category.service.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<ProductEntity> productsData = [];
  List<ProductModel> products = [];
  List<BrandModel> brands = [];
  List<CategoryModel> categories = [];
  List<String> filters = [];
  String? selectedCategoryId;
  String? selectedBrandId;

  final BrandService brandService = BrandService();
  final CategoryService categoryService = CategoryService();
  final ProductService productService = ProductService();

  Future<void> fetchBrands() async {
    try {
      final response = await brandService.getBrands();
      brands = response;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch brands: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await categoryService.getCategories();
      categories = response;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<ProductModel>> fetchVariants(String productId) async {
    try {
      final response = await productService.get('product/$productId/variants');
      List<dynamic> variantList;
      if (response['data'] is Map && (response['data']['data'] as List?) != null) {
        variantList = response['data']['data'] as List;
      } else {
        print('Unexpected data format for product $productId: ${response['data'].runtimeType}');
        return [];
      }

      return variantList
          .map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Failed to fetch variants for product $productId: $e');
      return [];
    }
  }

  Future<void> fetchFilteredProducts() async {
    try {
      String endpoint = 'product?page=1&limit=10';
      if (selectedCategoryId != null) {
        endpoint += '&category_ids=$selectedCategoryId';
      }
      if (selectedBrandId != null) {
        endpoint += '&brand_ids=$selectedBrandId';
      }
      final response = await productService.get(endpoint);

      // Kiểm tra response format
      if (response['data'] == null || response['data']['data'] == null) {
        throw Exception('Invalid API response: data or data.data is null');
      }

      List<ProductEntity> tempProducts = [];
      for (var item in (response['data']['data'] as List)) {
        try {
          // Chỉ thêm sản phẩm nếu không có lỗi khi parse
          final product = ProductEntity.fromMap(item);
          final variants = await fetchVariants(product.id);
          tempProducts.add(ProductEntity(
            id: product.id,
            productName: product.productName,
            isActive: product.isActive,
            categoryId: product.categoryId,
            brandId: product.brandId,
            productImage: product.productImage,
            variants: variants,
          ));
        } catch (e) {
          print('Skipping invalid product: $item, Error: $e');
          continue; // Bỏ qua sản phẩm không hợp lệ
        }
      }

      productsData = tempProducts;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  void setCategoryFilter(String? categoryId) {
    selectedCategoryId = categoryId;
    fetchFilteredProducts();
  }

  void setBrandFilter(String? brandId) {
    selectedBrandId = brandId;
    fetchFilteredProducts();
  }

  Future<void> handleSortChange(String value) async {
    String? sortName;
    String? sortPrice;
    List<String> brandIds = [];
    List<String> categoryIds = [];
    double? minPrice;
    double? maxPrice;
    num? rating;

    for (final filter in filters) {
      if (filter.contains(' - ')) {
        final priceRange = filter.split(' - ');
        if (priceRange.length == 2) {
          minPrice = parseMoney(priceRange[0]);
          maxPrice = parseMoney(priceRange[1]);
        }
      } else if (brands.any((b) => b.name == filter)) {
        brandIds.add(brands.firstWhere((b) => b.name == filter).id);
      } else if (categories.any((c) => c.name == filter)) {
        categoryIds.add(categories.firstWhere((c) => c.name == filter).id);
      } else if (RatingFilterValue.values.any((rating) => filter.contains(rating.label.toString()))) {
        rating = RatingFilterValue.values.firstWhere((rating) => filter.contains(rating.label.toString())).value;
      }
    }

    if (value == 'Name: A to Z') {
      sortName = 'asc';
    } else if (value == 'Name: Z to A') {
      sortName = 'desc';
    } else if (value == 'Price: Low to High') {
      sortPrice = 'asc';
    } else if (value == 'Price: High to Low') {
      sortPrice = 'desc';
    }

    final response = await productService.searchProductVariants(
      sortName: sortName,
      sortPrice: sortPrice,
      brandIds: brandIds.isNotEmpty ? brandIds : null,
      categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
      ratings: rating,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    products = response;
    notifyListeners();
  }

  Future<void> applyFilters({
    double? minPrice,
    double? maxPrice,
    List<String>? brandIds,
    List<String>? categoryIds,
    RatingFilterValue? rating,
  }) async {
    final response = await productService.searchProductVariants(
      minPrice: minPrice,
      maxPrice: maxPrice,
      brandIds: brandIds,
      categoryIds: categoryIds,
      ratings: rating?.value,
    );

    final Set<String> combined = {
      if (minPrice != null && maxPrice != null) '${formatMoney(minPrice)} - ${formatMoney(maxPrice)}',
      if (brandIds != null) ...getNameBrandById(brandIds),
      if (categoryIds != null) ...getNameCategoryById(categoryIds),
      if (rating != null && rating.value != null) rating.label,
    };

    updateFilters(combined.toList());
    products = response;
    notifyListeners();
  }

  Future<void> clearFilters() async {
    filters.clear();
    products = [];
    notifyListeners();
    await fetchFilteredProducts();
  }

  Future<void> removeFilterByName(String name) async {
    filters.removeWhere((item) => item == name);
    notifyListeners();
    await fetchFilteredProducts();
  }

  void updateFilters(List<String> newFilters) {
    filters = newFilters;
    notifyListeners();
  }

  List<ProductEntity> getProductsData() {
    return productsData;
  }

  List<ProductModel> getProducts() {
    return products;
  }

  List<String> getNameBrandById(List<String> brandIds) {
    return brandIds.map((brandId) {
      try {
        return brands.firstWhere((brand) => brand.id == brandId).name;
      } catch (e) {
        print('Brand not found for ID: $brandId');
        return 'Unknown';
      }
    }).toList();
  }

  List<String> getNameCategoryById(List<String> categoryIds) {
    return categoryIds.map((categoryId) {
      try {
        return categories.firstWhere((category) => category.id == categoryId).name;
      } catch (e) {
        print('Category not found for ID: $categoryId');
        return 'Unknown';
      }
    }).toList();
  }

  void setProducts(List<ProductModel> products) {
    this.products = products;
    notifyListeners();
  }
}