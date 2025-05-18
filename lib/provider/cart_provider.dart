// providers/cart_provider.dart
import 'dart:convert';

import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/services/cart.service.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<ProductForCartModel> cartItems = [];
  ProductService productService = ProductService();
  CartService cartService = CartService();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> getCartByUserId() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    cartItems.clear();

    if (token == null) {
      await _loadLocalCart();
      isLoading = false;
      notifyListeners();
    } else {
      try {
        final isCartSynced = prefs.getBool('isCartSynced') ?? false;

        if (!isCartSynced) {
          final getCartByLocalStorage = prefs.getStringList('cart') ?? [];

          final addToCartFutures =
              getCartByLocalStorage.map((itemString) async {
            final itemMap = jsonDecode(itemString) as Map<String, dynamic>;
            final productVariantId = itemMap['productVariantId'];
            final quantity = itemMap['quantity'];

            return cartService.addToCart(
              productId: productVariantId,
              quantity: quantity,
            );
          }).toList();
          await Future.wait(addToCartFutures);
          await prefs.setBool('isCartSynced', true);
        }

        await Future.delayed(Duration(milliseconds: 1000));

        final response = await cartService.getCartByUserId();

        for (var item in response.items) {
          cartItems.add(
            ProductForCartModel(
              productVariantId: item.productVariantId,
              productVariantName: item.productVariantName,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              discount: item.discount,
              images: item.images,
            ),
          );
        }

        // Cập nhật lại localStorage từ server
        final simpleCartItems = cartItems.map((item) {
          return jsonEncode({
            'productVariantId': item.productVariantId,
            'quantity': item.quantity,
          });
        }).toList();

        await prefs.setStringList('cart', simpleCartItems);
      } catch (e) {
        errorMessage = 'Error fetching cart: $e';
        print('Error fetching cart: $e');
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  //Handle add to cart
  Future<void> handleAddToCart(String productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final productForCartModel = {
      'productVariantId': productId,
      'quantity': quantity,
    };

    void updateLocalCartItems() {
      final existingIndex = cartItems.indexWhere(
        (item) => item.productVariantId == productId,
      );

      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += quantity;
      } else {
        cartItems.add(ProductForCartModel(
          productVariantId: productId,
          productVariantName: '',
          quantity: quantity,
          unitPrice: 0,
          discount: 0,
          images: ProductImage(url: '', publicId: ''),
        ));
      }
    }

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

      updateLocalCartItems();
    } else {
      try {
        await cartService.addToCart(productId: productId, quantity: quantity);
        updateLocalCartItems();
      } catch (e) {
        errorMessage = 'Error adding to cart: $e';
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> handleRemoveToCart(String productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    // Hàm local dùng để cập nhật cartItems state trong app
    void updateLocalCartItems() {
      final index =
          cartItems.indexWhere((item) => item.productVariantId == productId);
      if (index != -1) {
        final currentQuantity = cartItems[index].quantity;
        if (currentQuantity > 1) {
          cartItems[index].quantity -= quantity;
        }
      }
    }

    if (accessToken == null) {
      final existingCart = prefs.getStringList('cart') ?? [];
      List<Map<String, dynamic>> cartItemsJson = existingCart
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      bool updated = false;

      for (int i = 0; i < cartItemsJson.length; i++) {
        if (cartItemsJson[i]['productVariantId'] == productId) {
          final currentQuantity = cartItemsJson[i]['quantity'];

          if (currentQuantity <= 1) {
            return;
          }

          cartItemsJson[i]['quantity'] = currentQuantity - quantity;
          updated = true;
          break;
        }
      }

      if (updated) {
        final updatedCart =
            cartItemsJson.map((item) => jsonEncode(item)).toList();
        await prefs.setStringList('cart', updatedCart);

        updateLocalCartItems();
        notifyListeners();
      }
    } else {
      try {
        final index =
            cartItems.indexWhere((item) => item.productVariantId == productId);

        if (index != -1) {
          final currentQuantity = cartItems[index].quantity;

          if (currentQuantity <= 1) {
            return;
          }

          final updatedQuantity = currentQuantity - quantity;

          // Gọi API với số lượng mới
          await cartService.updateCart(
            productId: productId,
            quantity: updatedQuantity,
          );

          // Cập nhật local state
          cartItems[index].quantity = updatedQuantity;
          notifyListeners();
        }
      } catch (e) {
        errorMessage = 'Error updating cart: $e';
      } finally {
        notifyListeners();
      }
    }
  }

  void handleDeleteToCart(String productId) async {
    isLoading = true;
    notifyListeners();

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
    } else {
      try {
        // ✅ Gọi API xoá sản phẩm khỏi giỏ hàng
        final updatedCart = await cartService.removeCartByProductVarianId(
          productId: productId,
        );

        // ✅ Cập nhật cartItems state từ response mới
        cartItems = updatedCart.items;
      } catch (e) {
        errorMessage = 'Error removing item from cart: $e';
      } finally {
        isLoading = false;
        notifyListeners();
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
        ProductForCartModel(
          productVariantId: productVariantId,
          productVariantName: product.variantName,
          quantity: item['quantity'],
          unitPrice: product.price,
          discount: product.discount,
          images: product.images.isNotEmpty
              ? product.images[0]
              : ProductImage(url: '', publicId: ''),
        ),
      );
    }
  }

  double get subTotalPrice {
    return cartItems.fold(
      0,
      (total, item) =>
          total +
          ((item.unitPrice - item.unitPrice * item.discount) * item.quantity),
    );
  }
}
