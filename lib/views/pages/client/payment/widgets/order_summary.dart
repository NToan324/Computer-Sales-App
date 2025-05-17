import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/product_order.dart';

class OrderSummary extends StatelessWidget {
  final List<ProductForCartModel> cartItems;

  const OrderSummary(
      {super.key, required this.cartItems, this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    double height = cartItems.isEmpty ? 1 * 120 : cartItems.length * 160;
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
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 320,
          ),
          child: Container(
            width: 500,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isLoading
                ? Center(
                    child: SkeletonHorizontalProduct(),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return ProductOrdered(item: cartItems[index]);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
