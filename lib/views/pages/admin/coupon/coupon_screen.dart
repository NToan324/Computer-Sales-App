// lib/admin/coupon/coupon_screen.dart
import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mã giảm giá"),
      ),
      body: const Center(
        child: Text("Danh sách mã giảm giá"),
      ),
    );
  }
}