import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class CartService extends BaseClient {
  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    await post('cart', {
      'productVariantId': productId,
      'quantity': quantity,
    });
  }

  Future<CartModel> getCartByUserId() async {
    final response = await get('cart');
    return response['data'];
  }
}
