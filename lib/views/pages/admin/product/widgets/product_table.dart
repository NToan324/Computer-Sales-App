import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'product_form.dart'; // Import widget ProductForm

class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> products = [
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

  List<Map<String, dynamic>> get filteredProducts {
    if (_searchController.text.isEmpty) {
      return products;
    } else {
      return products.where((product) {
        return product['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Disabled":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  void _showProductForm(Map<String, dynamic> product) {
    final TextEditingController nameController =
        TextEditingController(text: product['name']);
    final TextEditingController stockController =
        TextEditingController(text: product['stock'].toString());
    final TextEditingController originalPriceController =
        TextEditingController(text: product['originalPrice'].toString());
    final TextEditingController sellingPriceController =
        TextEditingController(text: product['sellingPrice'].toString());
    String status = product['status'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            product['name'],
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
              buttonLabel: "Save",
              initialProduct: {
                'name': product['name'],
                'stock': product['stock'],
                'originalPrice': product['originalPrice'],
                'sellingPrice': product['sellingPrice'],
                'status': product['status'],
              },
              onSubmit: (updatedProductData) {
                setState(() {
                  product['name'] = updatedProductData['name'];
                  product['stock'] = updatedProductData['stock'];
                  product['originalPrice'] = updatedProductData['originalPrice'];
                  product['sellingPrice'] = updatedProductData['sellingPrice'];
                  product['status'] = updatedProductData['status'];
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  TableRow buildHeaderRow(List<String> headers, List<double> colWidths) {
    return TableRow(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
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

  TableRow buildProductRow(Map<String, dynamic> product, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);
    
    return TableRow(
      children: isMobile
          ? [
              cellText(product['id'].toString(), colWidths[0]),
              productCell(product, colWidths[1]),
              cellText("\$${product['sellingPrice']}", colWidths[2]),
            ]
          : [
              cellText(product['id'].toString(), colWidths[0]),
              productCell(product, colWidths[1]),
              cellText(product['stock'].toString(), colWidths[2]),
              cellText("\$${product['originalPrice']}", colWidths[3]),
              cellText("\$${product['sellingPrice']}", colWidths[4]),
              Container(
                width: colWidths[5],
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Chip(
                  label: Text(
                    product['status'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(product['status']),
                ),
              ),
            ],
    );
  }

  Widget cellText(String text, double width) {
    return GestureDetector(
      onTap: () {
        final product = products.firstWhere(
          (p) => p['id'].toString() == text,
          orElse: () => {},
        );
        if (product.isNotEmpty) _showProductForm(product);
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(text),
      ),
    );
  }

  Widget productCell(Map<String, dynamic> product, double width) {
    return GestureDetector(
      onTap: () {
        _showProductForm(product);
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['imageUrl'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "ID: ${product['id']}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
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
            ? [tableWidth * 0.08, tableWidth * 0.45, tableWidth * 0.3]
            : [
                tableWidth * 0.1,
                tableWidth * 0.3,
                tableWidth * 0.12,
                tableWidth * 0.15,
                tableWidth * 0.15,
                tableWidth * 0.15,
              ];

        final headers = isMobile
            ? ["Number", "Product", "Price"]
            : [
                "Number",
                "Product",
                "Stock",
                "Original Price",
                "Selling Price",
                "Status"
              ];

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
              /// Header + Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Product List",
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
                        hintText: "Search by name",
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

              /// Table
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
                      ...filteredProducts
                          .map((product) => buildProductRow(product, colWidths)),
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
