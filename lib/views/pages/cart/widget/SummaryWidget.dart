import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/utils/widget/Button.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class SummaryWidget extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  double discount = 0.0;
  double total;

  SummaryWidget(
      {super.key,
      required this.subtotal,
      required this.deliveryFee,
      required this.total});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  final TextEditingController promoCodeController = TextEditingController();

  void applyPromoCode() {
    if (promoCodeController.text == 'DISCOUNT') {
      widget.discount = 20.0;
    } else {
      widget.discount = 0.0;
    }
    widget.total = widget.subtotal + widget.deliveryFee - widget.discount;
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.medium,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              '\$${amount.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: FontSizes.medium,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: Responsive.isMobile(context)
                ? const Radius.circular(0)
                : const Radius.circular(10),
            bottomRight: Responsive.isMobile(context)
                ? const Radius.circular(0)
                : const Radius.circular(10),
          ),
          color: Responsive.isMobile(context)
              ? AppColor.white
              : AppColor.lightgrey,
          boxShadow: Responsive.isMobile(context)
              ? [
                  BoxShadow(
                    color: AppColor.black,
                    offset: Offset(0, 5),
                    blurRadius: 20.0,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: TextField(
                textAlign: TextAlign.start,
                controller: promoCodeController,
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
                          text: "Apply",
                          onPressed: () {
                            setState(() {
                              applyPromoCode();
                            });
                          })),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  // Checkout
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColor.primary),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Proceed to checkout',
                    style: TextStyle(
                      fontSize: FontSizes.medium,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
