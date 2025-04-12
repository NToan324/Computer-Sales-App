import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/product_table.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/add_product_btn.dart'; // Import widget mới

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100], // đảm bảo background giống dashboard
      width: double.infinity, // full width
      height: double.infinity, // full height
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddProductButton(),
            const SizedBox(height: 16),
            const ProductTable(),
          ],
        ),
      ),
    );
  }


}
