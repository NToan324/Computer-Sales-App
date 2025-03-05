import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/utils/widget/Button.dart';

class SummaryWidget extends StatefulWidget {
  final TextEditingController promoCodeController;
  final Function applyPromoCode;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  const SummaryWidget(
      {super.key,
      required this.promoCodeController,
      required this.applyPromoCode,
      required this.subtotal,
      required this.deliveryFee,
      required this.discount,
      required this.total});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.medium,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: FontSizes.medium,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.black,
              offset: Offset(0, 5),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: TextField(
                textAlign: TextAlign.start,
                controller: widget.promoCodeController,
                decoration: InputDecoration(
                  hintText: 'Promo Code',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  suffixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Button(
                          text: "Apply", onPressed: widget.applyPromoCode)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildSummaryRow('Subtotal', widget.subtotal),
            _buildSummaryRow('Delivery Fee', widget.deliveryFee),
            _buildSummaryRow('Discount', widget.discount),
            const Divider(),
            _buildSummaryRow('Total', widget.total, isTotal: true),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Button(
                onPressed: () {
                  // Checkout
                },
                text: 'Proceed to checkout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
