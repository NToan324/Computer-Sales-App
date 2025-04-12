import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:flutter/material.dart';

class AppBarOrderCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarOrderCustom({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('My Order',
          style: TextStyle(
              color: Colors.black,
              fontSize: FontSizes.large,
              fontWeight: FontWeight.bold)),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      bottom: TabBar(
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        tabs: [
          Tab(text: 'Active'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }
}
