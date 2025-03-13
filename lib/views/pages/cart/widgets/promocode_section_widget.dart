import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/item_cart.dart';
import 'package:flutter/material.dart';

class PromocodeSectionWidget extends StatefulWidget {
  const PromocodeSectionWidget({super.key, required this.cartItems});
  final List<CartItem> cartItems;

  @override
  State<PromocodeSectionWidget> createState() => _PromocodeSectionWidgetState();
}

class _PromocodeSectionWidgetState extends State<PromocodeSectionWidget> {
  final TextEditingController _promoCodeController = TextEditingController();

  double get subtotal =>
      widget.cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get deliveryFee => 5.0;
  // Example delivery fee
  double _discount = 10.0;

  double get discount => _discount;

  set discount(double value) {
    setState(() {
      _discount = value;
    });
  }

  double get total => subtotal + deliveryFee - discount;

  // void _applyPromoCode() {
  //   if (_promoCodeController.text == 'DISCOUNT') {
  //     discount = 20.0;
  //   } else {
  //     discount = 0.0;
  //   }
  // }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w300,
                  color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              formatMoney(amount),
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apply Coupon',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15,
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter Coupon Code',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black38, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: AppColors.primary),
                    onPressed: () {},
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          _buildSummaryRow('Discount', -discount),
          const Divider(),
          _buildSummaryRow('Total Pay', total, isTotal: true),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Checkout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
