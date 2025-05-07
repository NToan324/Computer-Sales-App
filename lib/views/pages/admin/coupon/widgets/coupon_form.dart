import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CouponForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final String buttonLabel;
  final Map<String, dynamic>? initialCoupon;

  const CouponForm({
    super.key,
    required this.onSubmit,
    required this.buttonLabel,
    this.initialCoupon,
  });

  @override
  State<CouponForm> createState() => _CouponFormState();
}

class _CouponFormState extends State<CouponForm> {
  late TextEditingController codeController;
  late String discountValue;
  late int usageCount;
  late int maxUsage;

  @override
  void initState() {
    super.initState();
    final data = widget.initialCoupon ?? {};
    codeController = TextEditingController(
      text: data['code'] ??
          _generateRandomCode(), // Tạo mã ngẫu nhiên nếu là coupon mới
    );
    discountValue = data['discountValue']?.toString() ?? '10000';
    usageCount = data['usageCount'] ?? 0;
    maxUsage = data['maxUsage'] ?? 10;
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(5, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: "Coupon Code",
                border: OutlineInputBorder(),
              ),
              enabled: widget.initialCoupon == null, // Chỉ chỉnh sửa mã khi tạo mới
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discount Value",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: double.infinity,
                      child: DropdownMenu<String>(
                        width: constraints.maxWidth,
                        initialSelection: discountValue,
                        onSelected: (value) =>
                            setState(() => discountValue = value!),
                        dropdownMenuEntries: [
                          '10000',
                          '20000',
                          '50000',
                          '100000'
                        ]
                            .map((value) => DropdownMenuEntry(
                                  value: value,
                                  label: "$valueđ",
                                ))
                            .toList(),
                        textStyle:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        menuStyle: MenuStyle(
                          maximumSize: WidgetStatePropertyAll(
                            Size(constraints.maxWidth, double.infinity),
                          ),
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Created At: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.initialCoupon?['createdAt'] ?? DateTime.now())}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Text(
              "Usage Count: $usageCount",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Max Usage (up to 10)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  maxUsage = int.tryParse(value) ?? 10;
                  if (maxUsage > 10) maxUsage = 10;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Applied Orders: ${widget.initialCoupon?['appliedOrders']?.join(", ") ?? "None"}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final couponData = {
                    'code': codeController.text,
                    'createdAt': widget.initialCoupon?['createdAt'] ?? DateTime.now(),
                    'discountValue': int.parse(discountValue),
                    'usageCount': widget.initialCoupon?['usageCount'] ?? 0,
                    'maxUsage': maxUsage,
                    'appliedOrders': widget.initialCoupon?['appliedOrders'] ?? [],
                  };
                  widget.onSubmit(couponData);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(widget.buttonLabel,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}