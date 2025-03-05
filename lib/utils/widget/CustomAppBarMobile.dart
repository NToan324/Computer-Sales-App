import 'package:flutter/material.dart';

class CustomAppBarMobile extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarMobile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: BackButton(
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
