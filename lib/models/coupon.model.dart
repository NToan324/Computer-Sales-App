import 'package:computer_sales_app/models/order.model.dart';

class CouponModel {
  String code;
  double discountAmount;
  int usageCount;
  int usageLimit;
  List<OrderModel> ordersUsed;
  bool isActive;

  CouponModel({
    required this.code,
    required this.discountAmount,
    required this.usageCount,
    required this.usageLimit,
    required this.ordersUsed,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'],
      discountAmount: json['discount_amount'],
      usageCount: json['usage_count'],
      usageLimit: json['usage_limit'],
      ordersUsed: (json['orders_used'] as List<dynamic>)
          .map((orderJson) =>
              OrderModel.fromJson(orderJson as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_amount': discountAmount,
      'usage_count': usageCount,
      'usage_limit': usageLimit,
      'orders_used': ordersUsed,
      'isActive': isActive,
    };
  }
}
