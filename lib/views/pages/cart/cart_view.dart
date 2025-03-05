import 'package:computer_sales_app/views/pages/cart/mobile/mobile_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/cart/web/web_cart_view.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? const MobileCartView()
        : const WebCartView();
  }
}
