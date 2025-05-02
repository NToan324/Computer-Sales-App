import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/item_cart.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/product_order.dart';

class OrderSummary extends StatelessWidget {
  final List<CartItem> cartItems;

  const OrderSummary({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary Order',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const SizedBox(
          width: 300,
          child: Text(
            'Check your order summary before payment for better experience',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 500,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return ProductOrdered(item: cartItems[index]);
            },
          ),
        ),
      ],
    );
  }
}
