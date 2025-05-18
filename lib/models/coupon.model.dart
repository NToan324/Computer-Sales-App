import 'package:computer_sales_app/models/order.model.dart';

class CouponModel {
  String code;
  double discountAmount;
  int usageCount;
  int usageLimit;
  List<OrderModel> ordersUsed; // Cần xem xét thay bằng List<String> nếu API trả về chuỗi
  bool isActive;
  DateTime? createdAt; // Thêm createdAt với nullable

  CouponModel({
    required this.code,
    required this.discountAmount,
    required this.usageCount,
    required this.usageLimit,
    required this.ordersUsed,
    required this.isActive,
    this.createdAt, // Cho phép null
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    try {
      return CouponModel(
        code: json['code'] ?? json['_id'] ?? '',
        discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
        usageCount: json['usage_count'] ?? 0,
        usageLimit: json['usage_limit'] ?? 0,
        ordersUsed: (json['orders_used'] as List<dynamic>?)
            ?.map((orderJson) => OrderModel.fromJson(orderJson as Map<String, dynamic>))
            .toList() ?? [], // Xử lý trường hợp orders_used null
        isActive: json['isActive'] ?? false,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      );
    } catch (e) {
      print('Error parsing CouponModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_amount': discountAmount,
      'usage_count': usageCount,
      'usage_limit': usageLimit,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'discount_amount': discountAmount,
      'usage_count': usageCount,
      'usage_limit': usageLimit,
      'appliedOrders': ordersUsed.map((order) => order.id ?? 'Unknown').toList(),
      'createdAt': createdAt, // Thêm createdAt vào toMap
    };
  }
}