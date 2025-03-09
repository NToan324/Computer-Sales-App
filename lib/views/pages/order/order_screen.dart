import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/order/mobile/order_mobile_view.dart';
import 'package:computer_sales_app/views/pages/order/web/order_web_view.dart';
class OrderScreen extends StatelessWidget {
  final List<Map<String, String>> orders;
  OrderScreen({Key? key})
      : orders = List.generate(
          100,
          (index) => {
            "title": "MacBook Air 13\" M2",
            "specs": "RAM: 8GB | SSD: 256GB",
            "price": "15,000,000 VND",
            "image": "assets/images/laptop.png",
            "state": index % 3 == 0 ? "Track Order" : (index % 3 == 1 ? "Review" : "Re-Order"),
          },
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? OrderMobileView(
            orders: orders,
          )
        : OrderWebView(
            orders: orders,
          );
  }
}
