import 'package:computer_sales_app/provider/category_provider.dart';
import 'package:computer_sales_app/views/pages/admin/category/widgets/category_table.dart';
import 'package:computer_sales_app/views/pages/admin/category/widgets/add_category_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi fetchCategories sau khi widget được gắn vào cây
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Container(
          color: Colors.grey[100],
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddCategoryButton(),
                const SizedBox(height: 16),
                CategoryTable(categories: categoryProvider.getFilteredCategories()),
              ],
            ),
          ),
        );
      },
    );
  }
}