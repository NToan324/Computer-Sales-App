import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/order/widget/order_item.dart';

class TimelineList extends StatelessWidget {
  final List<Map<String, String>> orders;
  final String state;
  
  TimelineList({super.key, required this.orders, required this.state});

  @override
  Widget build(BuildContext context) {
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

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  state == "Track Order"
                      ? Icons.local_shipping
                      : (state == "Review"
                          ? Icons.rate_review
                          : Icons.shopping_cart),
                  color: state == "Track Order"
                      ? AppColors.blue
                      : (state == "Review"
                          ? AppColors.green
                          : AppColors.red),
                  size: 24,
                ),
                if (index != filteredOrders.length - 1) // Không hiển thị đường kẻ ở mục cuối cùng
                  Container(
                    width: 2,
                    height: 50,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OrderItem(order: filteredOrders[index], state: state),
            ),
          ],
        );
      },
    );
  }
}
