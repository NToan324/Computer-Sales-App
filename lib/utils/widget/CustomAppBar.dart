import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: FontSizes.large, fontWeight: FontWeight.bold),
      ),
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      backgroundColor: BackgroundColor.secondary,
      forceMaterialTransparency: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
