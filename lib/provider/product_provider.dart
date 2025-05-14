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

class ProductProvider with ChangeNotifier {
  List<ProductModel> products = [];
  List<BrandModel> brands = [];
  List<CategoryModel> categories = [];
  List<String> filters = [];
  int page = 1;
  int limit = 12;
  int totalPage = 0;
  String? errorMessage;

  final BrandService brandService = BrandService();
  final CategoryService categoryService = CategoryService();
  final ProductService productService = ProductService();

  Future<void> fetchBrands() async {
    final response = await brandService.getBrands();
    brands.addAll(response.map((brand) => brand).toList());
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    final response = await categoryService.getCategories();
    categories.addAll(response.map((category) => category).toList());
    notifyListeners();
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
      if (categoryIds != null) ...getNamCatrgoryById(categoryIds),
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
  List<String> getNamCatrgoryById(List<String> categoryIds) {
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
