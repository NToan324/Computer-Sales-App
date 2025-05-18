import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class OrderService extends BaseClient {
  Future<OrderModel> createOrder({
    required String name,
    required String email,
    required String address,
    required String paymentMethod,
    required List<OrderItemModel> items,
  }) async {
    final response = await post(
      'order',
      {
        'name': name,
        'email': email,
        'address': address,
        'payment_method': paymentMethod,
        'items': items.map((item) => item.toJson()).toList(),
      },
    );
    return OrderModel.fromJson(response['data']);
  }

  Future<List<OrderModel>> getOrdersById() async {
    final response = await get('user/orders');
    return response['data']
        .map<OrderModel>((order) => OrderModel.fromJson(order))
        .toList();
  }
}
