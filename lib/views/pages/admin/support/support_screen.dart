// lib/admin/support/support_screen.dart
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hỗ trợ"), // Title of the app bar
      ),
      body: const Center(
        child: Text("Danh sách hỗ trợ"), // Body content of the screen
      ),
    );
  }
}