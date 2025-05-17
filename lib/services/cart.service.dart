import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class CartService extends BaseClient {
  Future<CartModel> addToCart({
    required String productId,
    required int quantity,
  }) async {
    final response = await post('cart', {
      'productVariantId': productId,
      'quantity': quantity,
    });
    if (response['data'].length == 0) {
      return CartModel(items: []);
    }
    return CartModel.fromMap(response['data']);
  }

  Future<CartModel> getCartByUserId() async {
    final response = await get('cart');
    if (response['data'].length == 0) {
      return CartModel(items: []);
    }
    return CartModel.fromMap(response['data']);
  }

  Future<CartModel> updateCart({
    required String productId,
    required int quantity,
  }) async {
    final response = await put('cart/$productId', {
      'quantity': quantity,
    });
    if (response['data'].length == 0) {
      return CartModel(items: []);
    }
    return CartModel.fromMap(response['data']);
  }

  Future<CartModel> removeCartByProductVarianId({
    required String productId,
  }) async {
    final response = await delete('cart/$productId');
    if (response['data'].length == 0) {
      return CartModel(items: []);
    }
    return CartModel.fromMap(response['data']);
  }
}
