import 'package:computer_sales_app/views/pages/client/order/widget/order_item.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/timeline_list.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class OrderView extends StatelessWidget {
  OrderView({super.key});

  final List<Map<String, String>> orders = List.generate(
    100,
    (index) => {
      "title": "MacBook Air 13\" M2",
      "specs": "RAM: 8GB | SSD: 256GB",
      "price": "15,000,000 VND",
      "image": "assets/images/laptop.png",
      "state": index % 3 == 0
          ? "Track Order"
          : (index % 3 == 1 ? "Review" : "Re-Order"),
      "date": "24/03/2025",
    },
  );

  Widget buildOrderView(List<Map<String, String>> orders, String state) {
    final filteredOrders =
        orders.where((order) => order['state'] == state).toList();

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text(
          "No orders available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Responsive(
      mobile: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return OrderItem(order: filteredOrders[index], state: state);
        },
      ),
 desktop: Center(
        child: Container(
          color: Colors.grey[200], // Nền xám cho giao diện web
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800), // Giới hạn chiều rộng
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền trắng
                borderRadius: BorderRadius.circular(12), // Bo góc nhẹ
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25), // Màu bóng nhẹ
                    blurRadius: 15, // Độ mờ của bóng
                    spreadRadius: 3, // Độ lan của bóng
                    offset: const Offset(0, 4), // Bóng đổ xuống dưới
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: TimelineList(orders: filteredOrders, state: state),
            ),
          ),
        ),
      ),
    );
  }

  @override
 Widget build(BuildContext context) {
    return Responsive(
      mobile: Container(
        color: Colors.white, // Nền trắng trên mobile
        height: MediaQuery.of(context).size.height,
        child: TabBarView(
          children: [
            buildOrderView(orders, 'Track Order'),
            buildOrderView(orders, 'Review'),
            buildOrderView(orders, 'Re-Order'),
          ],
        ),
      ),
      desktop: Container(
        color: Colors.grey[200], // Nền xám trên web
        height: MediaQuery.of(context).size.height,
        child: TabBarView(
          children: [
            buildOrderView(orders, 'Track Order'),
            buildOrderView(orders, 'Review'),
            buildOrderView(orders, 'Re-Order'),
          ],
        ),
      ),
    );
  }
}
