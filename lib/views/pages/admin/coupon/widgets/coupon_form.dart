import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:computer_sales_app/provider/coupon_provider.dart';
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
  late TextEditingController discountController;
  late TextEditingController usageLimitController;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    final data = widget.initialCoupon ?? {};
    codeController = TextEditingController(
      text: data['code'] ?? _generateRandomCode(),
    );
    discountController = TextEditingController(
      text: data['discount_amount']?.toString() ?? '0',
    );
    usageLimitController = TextEditingController(
      text: data['usage_limit']?.toString() ?? '1',
    );
    isActive = data['isActive'] ?? true;
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(5, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  bool _isValidCode(String code) {
    return RegExp(r'^[A-Z0-9]{5}$').hasMatch(code);
  }

  String? _validateDiscount(String value) {
    final numValue = double.tryParse(value);
    if (numValue == null) return 'Discount must be a number';

    return null;
  }

  String? _validateUsageLimit(String value) {
    final intValue = int.tryParse(value);
    if (intValue == null) return 'Usage limit must be an integer';
    if (intValue < 1) return 'Usage limit must be at least 1';
    if (intValue > 10) return 'Usage limit must not exceed 10';
    return null;
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
              decoration: InputDecoration(
                labelText: 'Coupon Code',
                border: const OutlineInputBorder(),
                errorText: !_isValidCode(codeController.text)
                    ? 'Code must be 5 uppercase letters/numbers'
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: discountController,
              decoration: InputDecoration(
                labelText: 'Discount Amount',
                border: const OutlineInputBorder(),
                suffixText: 'đ',
                errorText: _validateDiscount(discountController.text),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Text(
              'Created At: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.initialCoupon?['createdAt'] as DateTime? ?? DateTime.now())}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usageLimitController,
              decoration: InputDecoration(
                labelText: 'Usage Limit (1-10)',
                border: const OutlineInputBorder(),
                errorText: _validateUsageLimit(usageLimitController.text),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 20),
            if (widget.initialCoupon != null) ...[
              SwitchListTile(
                title: const Text('Active'),
                value: isActive,
                onChanged: (value) => setState(() => isActive = value),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 20),
            ],
            Text(
              'Applied Orders: ${widget.initialCoupon?['ordersUsed']?.join(', ') ?? 'None'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Center(
              child: Consumer<CouponProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [

                      ElevatedButton(
                        onPressed: provider.isLoading ||
                            !_isValidCode(codeController.text) ||
                            _validateDiscount(discountController.text) != null ||
                            _validateUsageLimit(usageLimitController.text) != null
                            ? null
                            : () async {
                          final couponData = {
                            'code': codeController.text,
                            'createdAt':
                            widget.initialCoupon?['createdAt'] ?? DateTime.now(),
                            'discount_amount': double.parse(discountController.text),
                            'usage_limit': int.parse(usageLimitController.text),
                            'ordersUsed': widget.initialCoupon?['ordersUsed'] ?? [],
                            'isActive': isActive,
                          };
                          try {
                            if (widget.initialCoupon == null) {
                              await provider.createCoupon(
                                code: codeController.text,
                                discountAmount: double.parse(discountController.text),
                                usageLimit: int.parse(usageLimitController.text),
                                isActive: true,
                              );
                            } else {
                              await provider.updateCoupon(
                                code: codeController.text,
                                discountAmount: double.parse(discountController.text),
                                usageLimit: int.parse(usageLimitController.text),
                                isActive: isActive,
                              );
                              await provider.loadCoupons();
                            }
                            widget.onSubmit(couponData);
                            Navigator.of(context).pop();
                          } catch (e) {

                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          widget.buttonLabel,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}