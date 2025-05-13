import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/order_summary.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/payment_details.dart';
import 'package:flutter/material.dart';

class PaymentView extends StatelessWidget {
  final List<CartItem> cartItems = [
    CartItem(
      productVariantId: 'Item 1',
      quantity: 4,
      unitPrice: 10000000,
    ),
    CartItem(
      productVariantId: 'Item 2',
      quantity: 20,
      unitPrice: 50000000,
    ),
    CartItem(
      productVariantId: 'Item 3',
      quantity: 3,
      unitPrice: 20000000,
    ),
  ];

  PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    double totalAmount = cartItems.fold(
      0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );

    return Scaffold(
      appBar: CustomAppBarMobile(title: 'Payment', isBack: true),
      body: SafeArea(
        child: Container(
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
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.only(left: 24, right: 24, bottom: 28, top: 20),
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
