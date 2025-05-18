import 'package:computer_sales_app/consts/index.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/services/brand.service.dart';
import 'package:computer_sales_app/services/category.service.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:hive/hive.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> products = [];
  List<BrandModel> brands = [];
  List<CategoryModel> categories = [];
  List<String> filters = [];
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

  ProductProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _productBox = await Hive.openBox<ProductModel>('productsBox');
    _categoryBox = await Hive.openBox<CategoryModel>('categoriesBox');
    _brandBox =
        await Hive.openBox<BrandModel>('brandsBox'); // mở box cho brands

    final cachedProducts = _productBox!.values.toList();
    if (cachedProducts.isNotEmpty) {
      products = cachedProducts;
    }

    final cachedCategories = _categoryBox!.values.toList();
    if (cachedCategories.isNotEmpty) {
      categories = cachedCategories;
    }

    final cachedBrands = _brandBox!.values.toList();
    if (cachedBrands.isNotEmpty) {
      brands = cachedBrands;
    }

    notifyListeners();
  }

  Future<void> fetchBrands() async {
    final response = await brandService.getBrands();
    brands = response.map((brand) => brand).toList();

    // Cập nhật cache Hive
    if (_brandBox != null) {
      await _brandBox!.clear();
      for (var brand in brands) {
        await _brandBox!.put(brand.id, brand);
      }
    }

    notifyListeners();
  }

  Future<void> fetchCategories() async {
    final response = await categoryService.getCategories();
    categories = response.map((category) => category).toList();
    await _updateCategoryHiveCache(categories);
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
      if (data['data'].length == 0) {
        products = [];
        totalPage = 0;
        this.page = 0;
        this.limit = 0;
        return;
      }
      products = data['data'];
      totalPage = data['totalPages'];
      this.page = data['page'];
      this.limit = data['limit'];

      await _updateHiveCache(products);
    } on BadRequestException catch (e) {
      if (_productBox != null && _productBox!.isNotEmpty) {
        products = _productBox!.values.toList();
      }
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _updateHiveCache(List<ProductModel> newProducts) async {
    if (_productBox == null) return;
    await _productBox!.clear();
    for (var product in newProducts) {
      await _productBox!.put(product.id, product);
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
        rating = (RatingFilterValue.values
            .firstWhere((rating) => filter.contains(rating.label.toString()))
            .value);
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

    final response = await productService.searchProductVariants(
      brandIds: brandIds.isNotEmpty ? brandIds : null,
      categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
      ratings: ratings,
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
      if (minPrice != null && maxPrice != null) ...[
        '${formatMoney(minPrice)} - ${formatMoney(maxPrice)}'
      ],
      if (brandIds != null) ...getNameBrandById(brandIds),
      if (categoryIds != null) ...getNamCategoryById(categoryIds),
      if (rating != null && rating.value != null) rating.label,
    };

    updateFilters(combined.toList());

    products = response['data'];
    totalPage = response['totalPages'];
    page = response['page'];
    limit = response['limit'];
    notifyListeners();
  }

  Future<void> clearFilters() async {
    filters.clear();
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

  List<ProductModel> getProducts() {
    return products;
  }

  //Get name of brand by id
  List<String> getNameBrandById(List<String> brandIds) {
    return brandIds
        .map(
            (brandId) => brands.firstWhere((brand) => brand.id == brandId).name)
        .toList();
  }

  //Get name of category by id
  List<String> getNamCategoryById(List<String> categoryIds) {
    return categoryIds
        .map((categoryId) =>
            categories.firstWhere((category) => category.id == categoryId).name)
        .toList();
  }

  void setProducts(List<ProductModel> products) {
    this.products = products;
    notifyListeners();
  }
}
