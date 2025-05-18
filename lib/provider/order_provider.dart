import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/services/order.service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel>? orders;
  OrderModel? selectedOrder;
  final orderService = OrderService();

  // Load danh sách đơn hàng khi khởi tạo
  Future<void> loadOrders({int page = 1, int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return;
    }

    final data = await orderService.getOrders(page: page, limit: limit);
    orders = data;
    notifyListeners();
  }

  // Tìm kiếm đơn hàng
  Future<void> searchOrders({
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
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return;
    }

    final data = await orderService.searchOrders(
      name: name,
      orderId: orderId,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      fromDate: fromDate,
      toDate: toDate,
      page: page,
      limit: limit,
    );
    orders = data;
    notifyListeners();
  }

  // Lấy chi tiết đơn hàng theo ID
  Future<void> loadOrderById(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return;
    }

    final data = await orderService.getOrderById(orderId);
    selectedOrder = data;
    notifyListeners();
  }

  // Tạo đơn hàng mới
  Future<void> createOrder({
    required String name,
    required String email,
    required String address,
    required String paymentMethod,
    required List<OrderItemModel> items,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return;
    }

    final data = await orderService.createOrder(
      name: name,
      email: email,
      address: address,
      paymentMethod: paymentMethod,
      items: items,
    );
    if (orders != null) {
      orders!.add(data);
    } else {
      orders = [data];
    }
    notifyListeners();
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return;
    }

    final data = await orderService.updateOrderStatus(orderId: orderId, status: status);
    if (selectedOrder != null && selectedOrder!.id == orderId) {
      selectedOrder = data;
    }
    if (orders != null) {
      final index = orders!.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        orders![index] = data;
      }
    }
    notifyListeners();
  }

  // Xóa đơn hàng khỏi danh sách (nếu cần)
  void clearOrder() {
    selectedOrder = null;
    notifyListeners();
  }

  // Xóa toàn bộ danh sách đơn hàng (nếu cần)
  void clearOrders() {
    orders = null;
    notifyListeners();
  }
}