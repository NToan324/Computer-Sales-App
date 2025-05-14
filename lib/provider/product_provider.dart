import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/product.model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> products = [];
  List<String> filters = [];

  final ProductService productService = ProductService();

  void setProducts(List<ProductModel> products) {
    this.products = products;
    notifyListeners();
  }

  Future<void> handleSortChange(String value) async {
    String? sortName;
    String? sortPrice;

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
    );

    products = response;
    notifyListeners();
  }

  Future<void> handleSortByFilter(
      {double? minPrice,
      double? maxPrice,
      List<String>? brandIds,
      List<String>? categoryIds,
      List<String>? ratings}) async {
    final response = await productService.searchProductVariants(
      minPrice: minPrice,
      maxPrice: maxPrice,
      brandIds: brandIds,
      categoryIds: categoryIds,
    );

    final Set<String> combined = {
      if (minPrice != null) ...['Min Price: ${formatMoney(minPrice)}'],
      if (maxPrice != null) ...['Max Price: ${formatMoney(maxPrice)}'],
      if (brandIds != null) ...brandIds,
      if (categoryIds != null) ...categoryIds,
      if (ratings != null) ...ratings,
    };

    updateFilters(
      combined.toList(),
    );

    products = response;
    notifyListeners();
  }

  void updateFilters(List<String> newFilters) {
    filters = newFilters;
    notifyListeners();
  }

  void clearFilters() {
    filters.clear();
    notifyListeners();
  }

  List<ProductModel> getProducts() {
    return products;
  }
}
