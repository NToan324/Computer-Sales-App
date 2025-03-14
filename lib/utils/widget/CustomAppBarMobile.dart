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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      // leading: BackButton(
      //   color: Colors.black,
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
