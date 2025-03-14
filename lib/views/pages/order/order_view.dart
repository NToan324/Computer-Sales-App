import 'package:computer_sales_app/views/pages/order/widget/order_item.dart';
import 'package:flutter/material.dart';

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
    },
  );
  Widget buildListViewSeparated(
      List<Map<String, String>> orders, String state) {
    final filteredOrders =
        orders.where((order) => order['state'] == state).toList();
    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          "No orders available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return OrderItem(order: filteredOrders[index], state: state);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: TabBarView(
        children: [
          buildListViewSeparated(orders, 'Track Order'),
          buildListViewSeparated(orders, 'Review'),
          buildListViewSeparated(orders, 'Re-Order'),
        ],
      ),
    );
  }
}
