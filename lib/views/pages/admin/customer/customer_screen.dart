import 'package:flutter/material.dart';
// import 'package:flutter_app/admin/product/widgets/product_widget.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const ProductWidget();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khách hàng"),
      ),
      body: const Center(
        child: Text("Danh sách Khách hàng"),
      ),
    );
  }
}