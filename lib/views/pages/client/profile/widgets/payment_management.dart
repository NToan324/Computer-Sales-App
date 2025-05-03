import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentManagement extends StatefulWidget {
  const PaymentManagement({super.key});

  @override
  State<PaymentManagement> createState() => _PaymentManagementState();
}

class _PaymentManagementState extends State<PaymentManagement> {
  List<Map<String, dynamic>> paymentMethodItems = [
    {'title': 'Cash', 'icon': CupertinoIcons.creditcard},
    {'title': 'Credit Card', 'icon': CupertinoIcons.hand_raised},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => listTileCustom(
        paymentMethodItems[index]['icon'],
        paymentMethodItems[index]['title'],
      ),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 0,
      ),
      itemCount: paymentMethodItems.length,
    );
  }
}
