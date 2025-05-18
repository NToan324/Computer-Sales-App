import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/provider/category_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_form.dart';

class CategoryTable extends StatefulWidget {
  final List<CategoryModel> categories;

  const CategoryTable({super.key, required this.categories});

  @override
  State<CategoryTable> createState() => _CategoryTableState();
}

class _CategoryTableState extends State<CategoryTable> {
  final TextEditingController _searchController = TextEditingController();

  List<CategoryModel> get filteredCategories {
    if (_searchController.text.isEmpty) {
      return widget.categories;
    } else {
      return widget.categories.where((category) {
        return category.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCategoryForm(CategoryModel category) {
    print('showCategoryForm: Category data = ${category.toJson()}'); // Debug
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
                labelStyle: TextStyle(color: Colors.black),
                floatingLabelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            child: CategoryForm(
              buttonLabel: 'Save',
              initialCategory: {
                '_id': category.id,
                'category_name': category.name, // Fixed key
                'category_description': category.description ?? '', // Added description
                'isActive': category.isActive,
                'category_image': category.image?.toMap(),
              },
              onSubmit: (updatedCategoryData) async {
                try {
                  await Provider.of<CategoryProvider>(context, listen: false)
                      .updateCategory(category.id, updatedCategoryData);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
              onDelete: () async {
                try {
                  await Provider.of<CategoryProvider>(context, listen: false)
                      .deleteCategory(category.id);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete category: $e')),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  TableRow buildHeaderRow(List<String> headers, List<double> colWidths) {
    return TableRow(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
      children: List.generate(headers.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          width: colWidths[index],
          child: Text(
            headers[index],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  TableRow buildCategoryRow(CategoryModel category, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);

    String getShortId(String id) {
      return id.length > 5 ? id.substring(0, 5) : id;
    }

    return TableRow(
      children: isMobile
          ? [
        InkWell(
          onTap: () => _showCategoryForm(category),
          child: cellText(getShortId(category.id), colWidths[0]),
        ),
        InkWell(
          onTap: () => _showCategoryForm(category),
          child: categoryCell(category, colWidths[1]),
        ),
        InkWell(
          onTap: () => _showCategoryForm(category),
          child: Container(
            width: colWidths[2],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Chip(
              label: Text(
                category.isActive ? 'Active' : 'Inactive',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor:
              _getStatusColor(category.isActive ? 'Active' : 'Inactive'),
            ),
          ),
        ),
      ]
          : [
        InkWell(
          onTap: () => _showCategoryForm(category),
          child: cellText(getShortId(category.id), colWidths[0]),
        ),
        InkWell(
          onTap: () => _showCategoryForm(category),
          child: categoryCell(category, colWidths[1]),
        ),
        InkWell(
          onTap: () => _showCategoryForm(category),
          child: Container(
            width: colWidths[2],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Chip(
              label: Text(
                category.isActive ? 'Active' : 'Inactive',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor:
              _getStatusColor(category.isActive ? 'Active' : 'Inactive'),
            ),
          ),
        ),
      ],
    );
  }

  Widget cellText(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget categoryCell(CategoryModel category, double width) {
    String getShortId(String id) {
      return id.length > 5 ? id.substring(0, 5) : id;
    }

    print('Category ${category.id} image URL: ${category.image?.url}'); // Debug

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: category.image?.url != null && category.image!.url.isNotEmpty
                ? Image.network(
              category.image!.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Image.network error for category ${category.id}: $error');
                return Container(
                  color: Colors.grey[300],
                  child: const Center(child: Text("No Image")),
                );
              },
            )
                : Container(
              color: Colors.grey[300],
              child: const Center(child: Text("No Image")),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  'ID: ${getShortId(category.id)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final tableWidth = constraints.maxWidth;

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.15, tableWidth * 0.50, tableWidth * 0.25]
            : [
          tableWidth * 0.15,
          tableWidth * 0.65,
          tableWidth * 0.15,
        ];

        final headers = isMobile
            ? ['ID', 'Category', 'Status']
            : ['ID', 'Category', 'Status'];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Category List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        hintText: 'Search by name',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth - 40,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (int i = 0; i < colWidths.length; i++)
                        i: FixedColumnWidth(colWidths[i]),
                    },
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      buildHeaderRow(headers, colWidths),
                      ...filteredCategories
                          .map((category) => buildCategoryRow(category, colWidths)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}