import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  List<Map<String, dynamic>> myAccountItems = [
    {'title': 'My Orders', 'icon': CupertinoIcons.square_grid_2x2},
    {'title': 'Order History', 'icon': Icons.history},
    {'title': 'Order Tracking', 'icon': Icons.track_changes},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => listTileCustom(
        myAccountItems[index]['icon'],
        myAccountItems[index]['title'],
      ),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 0,
      ),
      itemCount: myAccountItems.length,
    );
  }
}
