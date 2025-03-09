import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/views/pages/order/widget/order_item.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';

class OrderWebView extends StatelessWidget {
  final List<Map<String, String>> orders;
  OrderWebView({Key? key, required this.orders}) : super(key: key);

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('My Order',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: FontSizes.large,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            bottom: TabBar(
                indicatorColor: AppColor.primary,
                labelColor: AppColor.primary,
                tabs: [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ]),
          ),
          body: TabBarView(children: [
            buildListViewSeparated(orders, 'Track Order'),
            buildListViewSeparated(orders, 'Review'),
            buildListViewSeparated(orders, 'Re-Order'),
          ])),
    );
  }
}
