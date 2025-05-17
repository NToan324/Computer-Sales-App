import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function()? onDelete;
  final String buttonLabel;
  final Map<String, dynamic>? initialCategory;

  const CategoryForm({
    super.key,
    required this.onSubmit,
    this.onDelete,
    required this.buttonLabel,
    this.initialCategory,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController nameController;
  bool isActive = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialCategory;
    print('Initial category: $data'); // Debug

    nameController = TextEditingController(text: data?['name'] ?? '');
    isActive = data?['isActive'] ?? true;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      isLoading = true;
    });

    try {
      final categoryData = {
        'name': nameController.text,
        'isActive': isActive,
      };

      print('Category data sent to API: $categoryData'); // Debug

      Map<String, dynamic> result;
      if (widget.initialCategory == null) {
        // Thêm danh mục mới
        result = await Provider.of<CategoryProvider>(context, listen: false)
            .createCategory(categoryData);
      } else {
        // Cập nhật danh mục
        result = await Provider.of<CategoryProvider>(context, listen: false)
            .updateCategory(widget.initialCategory!['_id'], categoryData);
      }

      // Gửi dữ liệu đã cập nhật qua onSubmit
      widget.onSubmit(result);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error submitting category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save category: $e')),
      );
    }
  }

  Future<void> _handleDelete() async {
    if (widget.initialCategory == null || widget.onDelete == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await Provider.of<CategoryProvider>(context, listen: false)
          .deleteCategory(widget.initialCategory!['_id']);
      widget.onDelete!();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error deleting category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete category: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400, // Thu hẹp kích thước so với ProductForm vì không có hình ảnh
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isActive,
                      onChanged: (value) => setState(() => isActive = value!),
                    ),
                    const Text('Active'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(
                          widget.buttonLabel,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    if (widget.onDelete != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleDelete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}