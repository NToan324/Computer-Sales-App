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
  Future<List<OrderModel>> getOrders({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await get('order', queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    return (response['data']['data'] as List)
        .map<OrderModel>((order) => OrderModel.fromJson(order))
        .toList();
  }

  // Lấy chi tiết đơn hàng theo ID
  Future<OrderModel> getOrderById(String orderId) async {
    final response = await get('order/$orderId');
    return OrderModel.fromJson(response['data']);
  }

  // Tìm kiếm đơn hàng
  Future<List<OrderModel>> searchOrders({
    String? name,
    String? orderId,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? fromDate,
    String? toDate,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParameters = <String, String>{};
    if (name != null) queryParameters['name'] = name;
    if (orderId != null) queryParameters['order_id'] = orderId;
    if (status != null) queryParameters['status'] = status;
    if (paymentStatus != null) queryParameters['payment_status'] = paymentStatus;
    if (paymentMethod != null) queryParameters['payment_method'] = paymentMethod;
    if (fromDate != null) queryParameters['from_date'] = fromDate;
    if (toDate != null) queryParameters['to_date'] = toDate;
    queryParameters['page'] = page.toString();
    queryParameters['limit'] = limit.toString();

    final response = await get('order/search', queryParameters: queryParameters);
    return (response['data']['data'] as List)
        .map<OrderModel>((order) => OrderModel.fromJson(order))
        .toList();
  }

  // Cập nhật trạng thái đơn hàng
  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final response = await patch(
      'order/$orderId/status',
      {'status': status},
    );
    return OrderModel.fromJson(response['data']);
  }
}

