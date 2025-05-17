import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/product_table.dart';
import 'package:computer_sales_app/views/pages/admin/product/widgets/add_product_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchBrands();
    productProvider.fetchCategories();
    productProvider.fetchFilteredProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Container(
          color: Colors.grey[100],
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddProductButton(),
                const SizedBox(height: 16),
                ProductTable(products: productProvider.productsData),
              ],
            ),
          ),
        );
      },
    );
  }
}