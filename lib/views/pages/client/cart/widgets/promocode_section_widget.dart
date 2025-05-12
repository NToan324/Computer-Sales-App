import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:flutter/material.dart';

class PromocodeSectionWidget extends StatefulWidget {
  const PromocodeSectionWidget({super.key, required this.cartItems});
  final List<CartItem> cartItems;

  @override
  State<PromocodeSectionWidget> createState() => _PromocodeSectionWidgetState();
}

class _PromocodeSectionWidgetState extends State<PromocodeSectionWidget> {
  final TextEditingController _promoCodeController = TextEditingController();

  double get subtotal => widget.cartItems
      .fold(0, (sum, item) => sum + item.unitPrice * item.quantity);

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'voucher');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [
                  Text(
                    'Voucher',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 255, 222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Shipping Free',
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color.fromARGB(255, 0, 69, 23),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.black12,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Pay',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        formatMoney(total),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'payment');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
