import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/product.model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> products = [];

  void setProducts(List<Product> products) {
    this.products = products;
    notifyListeners();
  }

  List<Product> getProducts() {
    return products;
  }
}
