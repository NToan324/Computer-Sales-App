import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/order_summary.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/payment_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.getCartByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    final cartProvider = Provider.of<CartProvider>(context);
    final totalAmount = cartProvider.subTotalPrice;

    return Scaffold(
      appBar: CustomAppBarMobile(title: 'Payment', isBack: true),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            final cartItems = cartProvider.cartItems;
            final totalAmount = cartProvider.subTotalPrice;
            return Container(
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
                                OrderSummary(
                                  cartItems: cartItems,
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: PaymentDetails(
                                    totalAmount: totalAmount,
                                  ),
                                ),
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
                                  child:
                                      PaymentDetails(totalAmount: totalAmount),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 24),
                    if (!isMobile) FooterWidget()
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: isMobile
          ? Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 28, top: 20),
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
            )
          : null,
    );
  }
}
