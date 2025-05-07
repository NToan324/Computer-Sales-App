import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/product_table.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/add_product_btn.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  // Danh sách sản phẩm (dữ liệu mẫu, có thể thay thế bằng dữ liệu từ API hoặc database)
  final List<Map<String, dynamic>> products = const [
    {
      "id": 1,
      "name": "Laptop A",
      "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
      "stock": 20,
      "originalPrice": 1600,
      "sellingPrice": 1500,
      "status": "Active",
    },
    {
      "id": 2,
      "name": "PC B",
      "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
      "stock": 5,
      "originalPrice": 2100,
      "sellingPrice": 2000,
      "status": "Disabled",
    },
    {
      "id": 3,
      "name": "Mouse X",
      "imageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3",
      "stock": 100,
      "originalPrice": 30,
      "sellingPrice": 25,
      "status": "Active",
    },
  ];

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
            ProductTable(products: products), // Truyền dữ liệu products xuống ProductTable
          ],
        ),
      ),
    );
  }
}