import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/item_cart.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/order_summary.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/payment_details.dart';
import 'package:flutter/material.dart';

class PaymentView extends StatelessWidget {
  final List<CartItem> cartItems = [
    CartItem(
      name: 'Item 1',
      price: 10000000.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 4,
    ),
    CartItem(
      name: 'Item 2',
      price: 20.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 1,
    ),
    CartItem(
      name: 'Item 3',
      price: 30.0,
      image: 'assets/images/laptop_banner.jpg',
      quantity: 3,
    ),
  ];

  PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    double totalAmount = cartItems.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              isMobile
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OrderSummary(cartItems: cartItems),
                          const SizedBox(height: 24),
                          PaymentDetails(totalAmount: totalAmount),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 64, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: OrderSummary(cartItems: cartItems),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 1,
                            child: PaymentDetails(totalAmount: totalAmount),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 24),
              if (!isMobile) FooterWidget()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tổng tiền
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  formatMoney(totalAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Nút thanh toán
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Order Now',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
