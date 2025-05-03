import 'package:flutter/material.dart';

Widget listTileCustom(IconData icon, String title, {Function()? onTap}) {
  return ListTile(
    onTap: onTap,
    leading: Icon(icon),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    trailing: Container(
      width: 60,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 229, 202),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          'Edit',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 85, 0),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}
