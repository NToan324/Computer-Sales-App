import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/product_table.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/add_product_btn.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  // Loại bỏ const để danh sách có thể sửa đổi
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Laptop A',
      'stock': 20,
      'originalPrice': 1600,
      'sellingPrice': 1500,
      'status': 'Active',
    },
    {
      'id': 2,
      'name': 'PC B',
      'stock': 5,
      'originalPrice': 2100,
      'sellingPrice': 2000,
      'status': 'Disabled',
    },
    {
      'id': 3,
      'name': 'Mouse X',
      'stock': 100,
      'originalPrice': 30,
      'sellingPrice': 25,
      'status': 'Active',
    },
  ];

  void addProduct(Map<String, dynamic> productData) {
    setState(() {
      products.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': productData['name'],
        'stock': productData['stock'],
        'originalPrice': productData['originalPrice'],
        'sellingPrice': productData['sellingPrice'],
        'status': productData['disabled'] ? 'Disabled' : 'Active',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddProductButton(),
            const SizedBox(height: 16),
            ProductTable(products: products),
          ],
        ),
      ),
    );
  }
}