import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/coupon/widgets/add_coupon_btn.dart';
import 'package:computer_sales_app/views/pages/admin/coupon/widgets/coupon_table.dart';

class CouponManagementScreen extends StatelessWidget {
  CouponManagementScreen({super.key});

  // Danh sách coupons
  final List<Map<String, dynamic>> coupons = [
    {
      "code": "A1B2C",
      "createdAt": DateTime.now().subtract(const Duration(days: 5)),
      "discountValue": 10000,
      "usageCount": 3,
      "maxUsage": 10,
      "appliedOrders": ["Order001", "Order002"],
    },
    {
      "code": "X9Y8Z",
      "createdAt": DateTime.now().subtract(const Duration(days: 10)),
      "discountValue": 50000,
      "usageCount": 7,
      "maxUsage": 10,
      "appliedOrders": ["Order003", "Order004", "Order005"],
    },
    {
      "code": "P5Q6R",
      "createdAt": DateTime.now().subtract(const Duration(days: 2)),
      "discountValue": 20000,
      "usageCount": 1,
      "maxUsage": 10,
      "appliedOrders": ["Order006"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddCouponButton(),
            const SizedBox(height: 16),
            CouponTable(coupons: coupons), // Truyền coupons xuống CouponTable
          ],
        ),
      ),
    );
  }
}