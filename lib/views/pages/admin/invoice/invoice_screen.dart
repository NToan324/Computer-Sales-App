// lib/admin/invoice/invoice_screen.dart
import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hóa đơn"), // Title of the app bar
      ),
      body: const Center(
        child: Text("Danh sách hóa đơn"), // Body content of the screen
      ),
    );
  }
}