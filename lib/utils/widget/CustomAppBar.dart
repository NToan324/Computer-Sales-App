import 'dart:ui';

import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      // flexibleSpace: ClipRRect(
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //     child: Container(
      //       color: Colors.transparent,
      //     ),
      //   ),
      // ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
