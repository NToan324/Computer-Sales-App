import 'package:computer_sales_app/models/product_entity.dart' as entity;
import 'package:computer_sales_app/models/product.model.dart' as model;
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../views/pages/admin/product/widgets/product_form.dart';
import 'dart:async';

class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchBrands();
    productProvider.fetchCategories();
    productProvider.fetchFilteredProductsManagement(page: 1, limit: 12);
    // Listen for search changes
    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      if (_searchController.text.isEmpty) {
        productProvider.fetchFilteredProductsManagement(page: 1, limit: productProvider.limit);
      } else {
        productProvider.searchFilteredProducts(
          name: _searchController.text,
          page: 1,
          limit: productProvider.limit,
        );
      }
    });
  }

  List<entity.ProductEntity> get filteredProducts {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (_searchController.text.isEmpty) {
      return productProvider.productsData;
    } else {
      return productProvider.productsData.where((product) {
        return (product.productName ?? '')
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

  List<entity.ProductEntity> _sortProducts(List<entity.ProductEntity> products) {
    return products..sort((a, b) => b.id.compareTo(a.id)); // Newest first (MongoDB ObjectId)
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Disabled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showProductForm(entity.ProductEntity product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            product.productName,
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
            child: ProductForm(
              buttonLabel: 'Save',
              initialProduct: {
                '_id': product.id,
                'product_name': product.productName, // Đổi từ 'name' để khớp với ProductForm
                'stock': 10.toString(),
                'category': product.categoryId,
                'brand': product.brandId,
                'product_image': product.productImage?.toMap(),
                'disabled': !product.isActive,
                'variants': product.variants.map((variant) => variant.toMap()).toList(),
              },
              onSubmit: (updatedProductData) async {
                print('ProductTable onSubmit: updatedProductData = $updatedProductData');
                final productProvider = Provider.of<ProductProvider>(context, listen: false);
                try {
                  setState(() {
                    final index = productProvider.productsData.indexWhere((p) => p.id == product.id);
                    if (index != -1) {
                      productProvider.productsData[index] = entity.ProductEntity(
                        id: product.id,
                        productName: updatedProductData['product_name']?.toString() ?? product.productName,
                        isActive: updatedProductData['disabled'] != null ? !updatedProductData['disabled'] : product.isActive,
                        categoryId: updatedProductData['category']?.toString() ?? product.categoryId,
                        brandId: updatedProductData['brand']?.toString() ?? product.brandId,
                        productImage: updatedProductData['product_image'] is Map<String, dynamic>
                            ? entity.ProductImage.fromMap(updatedProductData['product_image'] as Map<String, dynamic>)
                            : product.productImage,
                        variants: (updatedProductData['variants'] as List<dynamic>?)
                            ?.map((item) => model.ProductModel.fromMap(item as Map<String, dynamic>))
                            .toList() ??
                            product.variants,
                      );
                      print('ProductTable: Updated product at index $index: ${productProvider.productsData[index].toJson()}');
                    } else {
                      print('ProductTable: Product not found in productsData');
                    }
                  });
                  await productProvider.fetchFilteredProductsManagement(
                    page: productProvider.page,
                    limit: productProvider.limit,
                  );
                  print('ProductTable onSubmit: fetchFilteredProductsManagement completed');
                  Navigator.of(context).pop();
                } catch (e) {
                  print('ProductTable onSubmit: Error = $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating product: $e')),
                  );
                }
              },
              onDelete: () async {
                print('ProductTable onDelete: Deleting product ${product.id}');
                final productProvider = Provider.of<ProductProvider>(context, listen: false);
                try {
                  await productProvider.productService.deleteProduct(product.id);
                  await productProvider.fetchFilteredProductsManagement(
                    page: productProvider.page,
                    limit: productProvider.limit,
                  );
                  print('ProductTable onDelete: fetchFilteredProductsManagement completed');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product deleted successfully')),
                  );
                } catch (e) {
                  print('ProductTable onDelete: Error = $e');
                  if (e.toString().contains('Sản phẩm không tồn tại')) {
                    // Product already deleted, treat as success
                    await productProvider.fetchFilteredProductsManagement(
                      page: productProvider.page,
                      limit: productProvider.limit,
                    );
                    print('ProductTable onDelete: Product already deleted, treated as success');
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product deleted successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting product: $e')),
                    );
                  }
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

  TableRow buildProductRow(entity.ProductEntity product, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    String getShortId(String id) {
      return id.length > 5 ? id.substring(0, 5) : id;
    }

    String categoryName = product.categoryId != null && productProvider.categories.isNotEmpty
        ? (productProvider.getNameCategoryById([product.categoryId!]).firstOrNull ?? 'Unknown')
        : 'N/A';
    String brandName = product.brandId != null && productProvider.brands.isNotEmpty
        ? (productProvider.getNameBrandById([product.brandId!]).firstOrNull ?? 'Unknown')
        : 'N/A';

    print('buildProductRow: categoryId = ${product.categoryId}, categoryName = $categoryName');
    print('buildProductRow: brandId = ${product.brandId}, brandName = $brandName');

    final totalStock = product.variants.isNotEmpty
        ? product.variants
        .map((variant) => variant.quantity ?? 0)
        .reduce((a, b) => a + b)
        .toString()
        : '0';

    print('buildProductRow: totalStock = $totalStock for product ${product.id}');

    return TableRow(
      children: isMobile
          ? [
        InkWell(
          onTap: () => _showProductForm(product),
          child: cellText(getShortId(product.id), colWidths[0]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: productCell(product, colWidths[1]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: cellText(product.isActive ? 'Active' : 'Disabled', colWidths[2]),
        ),
      ]
          : [
        InkWell(
          onTap: () => _showProductForm(product),
          child: cellText(getShortId(product.id), colWidths[0]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: productCell(product, colWidths[1]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: cellText(totalStock, colWidths[2]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: cellText(categoryName, colWidths[3]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: cellText(brandName, colWidths[4]),
        ),
        InkWell(
          onTap: () => _showProductForm(product),
          child: Container(
            width: colWidths[5],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Chip(
              label: Text(
                product.isActive ? 'Active' : 'Disabled',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: _getStatusColor(product.isActive ? 'Active' : 'Disabled'),
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

  Widget productCell(entity.ProductEntity product, double width) {
    String getShortId(String id) {
      return id.length > 5 ? id.substring(0, 5) : id;
    }

    print('productCell: productImage.url = ${product.productImage?.url} for product ${product.id}');

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
            child: product.productImage?.url != null && product.productImage!.url!.isNotEmpty
                ? Image.network(
              product.productImage!.url!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
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
                  product.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  'ID: ${getShortId(product.id)}',
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

  Widget _buildPagination(ProductProvider productProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: productProvider.page > 1
              ? () {
            productProvider.fetchFilteredProductsManagement(
              page: productProvider.page - 1,
              limit: productProvider.limit,
            );
          }
              : null,
        ),
        Text('Page ${productProvider.page} of ${productProvider.totalPage}'),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: productProvider.page < productProvider.totalPage
              ? () {
            productProvider.fetchFilteredProductsManagement(
              page: productProvider.page + 1,
              limit: productProvider.limit,
            );
          }
              : null,
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: productProvider.limit,
          items: [12, 24, 48].map((value) => DropdownMenuItem(
            value: value,
            child: Text('$value per page'),
          )).toList(),
          onChanged: (value) {
            if (value != null) {
              productProvider.fetchFilteredProductsManagement(page: 1, limit: value);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final sortedProducts = _sortProducts(filteredProducts);
    print('filteredProducts: searchText = ${_searchController.text}, filteredCount = ${sortedProducts.length}');

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final tableWidth = constraints.maxWidth;

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.08, tableWidth * 0.55, tableWidth * 0.25]
            : [
          tableWidth * 0.08,
          tableWidth * 0.30,
          tableWidth * 0.12,
          tableWidth * 0.15,
          tableWidth * 0.15,
          tableWidth * 0.15,
        ];

        final headers = isMobile
            ? ['ID', 'Product', 'Status']
            : ['ID', 'Product', 'Stock', 'Category', 'Brand', 'Status'];

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
              // Header + Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Product List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
              // Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth - 40,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (int i = 0; i < colWidths.length; i++) i: FixedColumnWidth(colWidths[i]),
                    },
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      buildHeaderRow(headers, colWidths),
                      ...sortedProducts.map((product) => buildProductRow(product, colWidths)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPagination(productProvider),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}