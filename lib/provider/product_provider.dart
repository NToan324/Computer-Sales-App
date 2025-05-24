import 'dart:core';
import 'package:computer_sales_app/consts/index.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/models/product_entity.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/services/brand.service.dart';
import 'package:computer_sales_app/services/category.service.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProductProvider with ChangeNotifier {
  List<ProductEntity> productsData = [];
  List<ProductModel> products = [];
  List<BrandModel> brands = [];
  List<CategoryModel> categories = [];
  List<String> filters = [];
  String? selectedCategoryId;
  String? selectedBrandId;
  int page = 1;
  int limit = 12;
  int totalPage = 0;
  String? errorMessage;
  Box<ProductModel>? _productBox;
  Box<CategoryModel>? _categoryBox;
  Box<BrandModel>? _brandBox;

  final BrandService brandService = BrandService();
  final CategoryService categoryService = CategoryService();
  final ProductService productService = ProductService();

  Future<void> fetchBrands() async {
    try {
      final response = await brandService.getBrands();
      brands = response.map((brand) => brand).toList();

      // Lưu cache
      if (_brandBox != null) {
        await _brandBox!.clear();
        for (var brand in brands) {
          await _brandBox!.put(brand.id, brand);
        }
      }
    } catch (e) {
      // Nếu lỗi (mất mạng), lấy từ cache
      if (_brandBox != null && _brandBox!.isNotEmpty) {
        brands = _brandBox!.values.toList();
        debugPrint("Đã load brand từ cache do lỗi: $e");
      } else {
        debugPrint("Không có dữ liệu brand cache và lỗi xảy ra: $e");
      }
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await categoryService.getCategories();
      categories = response.map((category) => category).toList();
      await _updateCategoryHiveCache(categories);
    } catch (e) {
      // Nếu lỗi (mất mạng), lấy từ cache
      if (_categoryBox != null && _categoryBox!.isNotEmpty) {
        categories = _categoryBox!.values.toList();
        debugPrint("Đã load category từ cache do lỗi: $e");
      } else {
        debugPrint("Không có dữ liệu category cache và lỗi xảy ra: $e");
      }
    }

    notifyListeners();
  }

  Future<void> _updateCategoryHiveCache(
      List<CategoryModel> newCategories) async {
    if (_categoryBox == null) return;
    await _categoryBox!.clear();
    for (var category in newCategories) {
      await _categoryBox!.put(category.id, category);
    }
  }

  Future<List<ProductModel>> fetchVariants(String productId) async {
    try {
      final response = await productService.get('product/$productId/variants');
      List<dynamic> variantList;
      if (response['data'] is Map &&
          (response['data']['data'] as List?) != null) {
        variantList = response['data']['data'] as List;
      } else {
        return [];
      }

      return variantList
          .map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> fetchFilteredProductsManagement({
    int page = 1,
    int limit = 12,
  }) async {
    try {
      String endpoint = 'product?page=$page&limit=$limit';
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
          continue; // Bỏ qua sản phẩm không hợp lệ
        }
      }

      productsData = tempProducts;
      totalPage = response['data']['totalPages'] ?? 1;
      this.page = response['data']['page'] ?? page;
      this.limit = response['data']['limit'] ?? limit;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to fetch products: $e';
      notifyListeners();
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

  Future<void> fetchProducts(
      {page = 1, limit = 12, resetFilter = false}) async {
    List<String> brandIds = [];
    List<String> categoryIds = [];
    double? minPrice;
    double? maxPrice;
    num? rating;

    if (!resetFilter) {
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
        } else if (brands.any((b) => b.name == filter)) {
          brandIds.add(brands.firstWhere((b) => b.name == filter).id);
        } else if (categories.any((c) => c.name == filter)) {
          categoryIds.add(categories.firstWhere((c) => c.name == filter).id);
        } else if (RatingFilterValue.values
            .any((rating) => filter.contains(rating.label.toString()))) {
          rating = (RatingFilterValue.values
              .firstWhere((rating) => filter.contains(rating.label.toString()))
              .value);
        }
      }
    }
    try {
      final data = await productService.searchProductVariants(
        page: page,
        limit: limit,
        brandIds: brandIds.isNotEmpty ? brandIds : null,
        categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
        ratings: rating,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      products = data['data'];
      totalPage = data['totalPages'];
      this.page = data['page'];
      this.limit = data['limit'];
    } on BadRequestException catch (e) {
      errorMessage = e.message;
    } finally {
      notifyListeners();
    }
  }

  Future<void> searchFilteredProducts({
    String? name,
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final response = await productService.searchProducts(
        name: name,
        categoryIds: selectedCategoryId != null ? [selectedCategoryId!] : null,
        brandIds: selectedBrandId != null ? [selectedBrandId!] : null,
        page: page,
        limit: limit,
      );

      List<ProductEntity> tempProducts = [];
      for (var product in (response['data'] as List<ProductEntity>)) {
        try {
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
          continue; // Skip invalid products
        }
      }

      productsData = tempProducts;
      this.page = response['page'];
      this.limit = response['limit'];
      totalPage = response['totalPages'];
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to search products: $e';
      notifyListeners();
      throw Exception('Failed to search products: $e');
    }
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
      } else if (RatingFilterValue.values
          .any((rating) => filter.contains(rating.label.toString()))) {
        rating = RatingFilterValue.values
            .firstWhere((rating) => filter.contains(rating.label.toString()))
            .value;
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
      page: 1,
      limit: limit,
    );

    products = response['data'];
    totalPage = response['totalPages'];
    page = response['page'];
    limit = response['limit'];
    notifyListeners();
  }

  Future<void> fetchFilteredProducts() async {
    List<String> brandIds = [];
    List<String> categoryIds = [];
    double? minPrice;
    double? maxPrice;
    num? ratings;

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
      } else if (brands.any((b) => b.name == filter)) {
        brandIds.add(brands.firstWhere((b) => b.name == filter).id);
      } else if (categories.any((c) => c.name == filter)) {
        categoryIds.add(categories.firstWhere((c) => c.name == filter).id);
      } else if (RatingFilterValue.values
          .any((rating) => filter.contains(rating.label.toString()))) {
        ratings = (RatingFilterValue.values
            .firstWhere((rating) => filter.contains(rating.label.toString()))
            .value);
      }
    }
    try {
      final response = await productService.searchProductVariants(
        brandIds: brandIds.isNotEmpty ? brandIds : null,
        categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
        ratings: ratings,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: 1,
        limit: limit,
      );

      if (response['data'].length == 0) {
        products = [];
        totalPage = 0;
        page = 0;
        limit = 0;
        return;
      }

      products = response['data'];
      totalPage = response['totalPages'];
      page = response['page'];
      limit = response['limit'];
    } catch (e) {
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> applyFilters({
    double? minPrice,
    double? maxPrice,
    List<String>? brandIds,
    List<String>? categoryIds,
    RatingFilterValue? rating,
    int page = 1,
    int limit = 12,
  }) async {
    final response = await productService.searchProductVariants(
      minPrice: minPrice,
      maxPrice: maxPrice,
      brandIds: brandIds,
      categoryIds: categoryIds,
      ratings: rating?.value,
      page: page,
      limit: limit,
    );

    // Cập nhật danh sách filters để hiển thị ra giao diện
    final Set<String> combined = {
      if (minPrice != null && maxPrice != null)
        '${formatMoney(minPrice)} - ${formatMoney(maxPrice)}',
      if (brandIds != null) ...getNameBrandById(brandIds),
      if (categoryIds != null) ...getNameCategoryById(categoryIds),
      if (rating != null && rating.value != null) rating.label,
    };

    updateFilters(combined.toList());

    if (response['data'].length == 0) {
      products = [];
      totalPage = 0;
      this.page = 0;
      this.limit = 0;
      return;
    }

    products = response['data'];
    totalPage = response['totalPages'];
    page = response['page'];
    limit = response['limit'];
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
    await fetchFilteredProducts();
    notifyListeners();
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
        return 'Unknown';
      }
    }).toList();
  }

  //Get name of category by id
  List<String> getNameCategoryById(List<String> categoryIds) {
    return categoryIds
        .map((categoryId) =>
            categories.firstWhere((category) => category.id == categoryId).name)
        .toList();
  }

  void setProducts(List<ProductModel> products) {
    this.products = products;
    notifyListeners();
  }

  Future<void> getProductsBestSelling() async {
    try {
      final response = await productService.getProductsBestSelling();

      if (response['data'].length == 0) {
        products = [];
        totalPage = 0;
        page = 0;
        limit = 0;
        notifyListeners();
        return;
      }

      products = response['data'];
      totalPage = response['totalPages'];
      page = response['page'];
      limit = response['limit'];
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getProductsNewest() async {
    try {
      final response = await productService.getProductsNewest();

      if (response['data'].length == 0) {
        products = [];
        totalPage = 0;
        page = 0;
        limit = 0;
        notifyListeners();
        return;
      }

      products = response['data'];
      totalPage = response['totalPages'];
      page = response['page'];
      limit = response['limit'];
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
