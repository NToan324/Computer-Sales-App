// providers/cart_provider.dart
import 'dart:convert';

import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/services/cart.service.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartItems = [];
  ProductService productService = ProductService();
  CartService cartService = CartService();
  bool isLoading = false;

  Future<void> getCartByUserId() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    cartItems.clear();

    if (token == null) {
      await _loadLocalCart(); // GỌI HÀM ĐÃ TÁCH RA
    } else {
      try {
        print('User is logged in');
        await cartService.getCartByUserId();
      } catch (e) {
        // handle
      }
    }
    isLoading = false;
    notifyListeners();
  }

  //Handle add to cart
  void handleAddToCart(String productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final productForCartModel = {
      'productVariantId': productId,
      'quantity': quantity,
    };

    if (accessToken == null) {
      final existingCart = prefs.getStringList('cart') ?? [];
      List<Map<String, dynamic>> cartItemsJson = existingCart
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      bool found = false;

      for (var item in cartItemsJson) {
        if (item['productVariantId'] == productId) {
          item['quantity'] += quantity;
          found = true;
          break;
        }
      }

      if (!found) {
        cartItemsJson.add(productForCartModel);
      }

      final updatedCart =
          cartItemsJson.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList('cart', updatedCart);

      // ✅ Cập nhật state `cartItems` ngay
      final existingIndex = cartItems.indexWhere(
        (item) => item.items.productVariantId == productId,
      );

      if (existingIndex != -1) {
        cartItems[existingIndex].items.quantity += quantity;
      } else {
        // Nếu sản phẩm chưa có trong cartItems, tạo dummy CartModel
        cartItems.add(CartModel(
          items: ProductForCartModel(
            productVariantId: productId,
            productVariantName: '', // bạn có thể để tạm, sẽ update sau
            quantity: quantity,
            unitPrice: 0,
            discount: 0,
            images: ProductImage(url: '', publicId: ''),
          ),
        ));
      }

      print('Updated cartItems state without reload');
    } else {
      try {
        // Gọi API nếu đăng nhập
      } catch (e) {
        print('Error saving to server cart: $e');
      }
    }

    notifyListeners();
  }

  void handleRemoveToCart(String productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      final existingCart = prefs.getStringList('cart') ?? [];

      List<Map<String, dynamic>> cartItemsJson = existingCart
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      bool updated = false;

      for (int i = 0; i < cartItemsJson.length; i++) {
        if (cartItemsJson[i]['productVariantId'] == productId) {
          final currentQuantity = cartItemsJson[i]['quantity'];

          // ✅ Nếu đang là 1 hoặc nhỏ hơn thì không làm gì cả
          if (currentQuantity <= 1) {
            print('Số lượng đã là 1. Không thể giảm thêm.');
            return;
          }

          // ✅ Giảm số lượng
          cartItemsJson[i]['quantity'] = currentQuantity - quantity;
          updated = true;
          break;
        }
      }

      if (updated) {
        final updatedCart =
            cartItemsJson.map((item) => jsonEncode(item)).toList();
        await prefs.setStringList('cart', updatedCart);

        // ✅ Đồng bộ với cartItems state
        final index = cartItems
            .indexWhere((item) => item.items.productVariantId == productId);

        if (index != -1) {
          final currentQuantity = cartItems[index].items.quantity;
          if (currentQuantity > 1) {
            cartItems[index].items.quantity -= quantity;
          }
        }

        notifyListeners();
      }
    } else {
      try {
        // TODO: gọi API khi đã đăng nhập
      } catch (e) {
        print('Error updating server cart: $e');
      }
    }
  }



  void handleDeleteToCart(String productId) async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      final existingCart = prefs.getStringList('cart') ?? [];

      List<Map<String, dynamic>> cartItemsLocal = existingCart
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      cartItemsLocal
          .removeWhere((item) => item['productVariantId'] == productId);

      final updatedCart =
          cartItemsLocal.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList('cart', updatedCart);

      // ✅ Gọi lại hàm vừa tách để cập nhật cartItems
      await _loadLocalCart();
      print('Deleted from local cart');
    } else {
      try {
        // TODO: call API
      } catch (e) {
        print('Error deleting from server cart: $e');
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadLocalCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart');
    cartItems.clear();

    final List<Map<String, dynamic>> productVariantItems = cart
            ?.map((item) => jsonDecode(item) as Map<String, dynamic>)
            .toList() ??
        [];

    for (var item in productVariantItems) {
      final productVariantId = item['productVariantId'];
      final product =
          await productService.getProductVariantById(productVariantId);

      cartItems.add(
        CartModel(
          items: ProductForCartModel(
            productVariantId: productVariantId,
            productVariantName: product.variantName,
            quantity: item['quantity'],
            unitPrice: product.price,
            discount: product.discount,
            images: product.images.isNotEmpty
                ? product.images[0]
                : ProductImage(url: '', publicId: ''),
          ),
        ),
      );
    }
  }

  double get subTotalPrice {
    return cartItems.fold(
      0,
      (total, item) => total + (item.items.unitPrice * item.items.quantity),
    );
  }
}
