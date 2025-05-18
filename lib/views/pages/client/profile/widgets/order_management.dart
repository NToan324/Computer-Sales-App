import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key, required this.userId});

  final String userId;

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
      itemBuilder: (context, index) {
        bool isExistUser = widget.userId.isNotEmpty;
        if (!isExistUser) {
          return Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Center(
              child: Text(
                'Please login to view your orders',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
        return listTileCustom(
          myAccountItems[index]['icon'],
          myAccountItems[index]['title'],
          onTap: () {
            if (index == 0) {
              Navigator.pushNamed(context, 'order-view');
            } else if (index == 1) {
              Navigator.pushNamed(context, 'order-view');
            } else if (index == 2) {
              Navigator.pushNamed(context, 'order-view');
            }
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 0,
      ),
      itemCount: widget.userId.isNotEmpty ? myAccountItems.length : 1,
    );
  }
}
