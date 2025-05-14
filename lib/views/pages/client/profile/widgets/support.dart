import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportAccount extends StatefulWidget {
  const SupportAccount({super.key});

  @override
  State<SupportAccount> createState() => _SupportAccountState();
}

class _SupportAccountState extends State<SupportAccount> {
  List<Map<String, dynamic>> supportItems = [
    {'title': 'Contact Us', 'icon': CupertinoIcons.phone},
    {'title': 'FAQ', 'icon': CupertinoIcons.question},
    {'title': 'Feedback', 'icon': CupertinoIcons.pencil},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => listTileCustom(
        supportItems[index]['icon'],
        supportItems[index]['title'],
      ),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 0,
      ),
      itemCount: supportItems.length,
    );
  }
}
