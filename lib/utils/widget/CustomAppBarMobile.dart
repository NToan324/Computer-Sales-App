import 'package:flutter/material.dart';

class CustomAppBarMobile extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarMobile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
