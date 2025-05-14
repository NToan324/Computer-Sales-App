// providers/cart_provider.dart
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:flutter/material.dart';
import '../models/product.model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get totalItems => _items.length;

  void addToCart(ProductModel product, int quantity) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(
        productVariantId: product.id,
        quantity: quantity,
        unitPrice: product.price,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.values.fold(
        0.0,
        (sum, item) => sum + item.unitPrice * item.quantity,
      );
}
